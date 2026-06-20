import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { MemberCsvRowDto } from './dto/import-members.dto';
import { MemberStatus, MembershipClass, Prisma, Role } from '@prisma/client';
import { MembershipRulesService } from './membership-rules.service';
import { ProtectedPersonsService } from './protected-persons.service';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { canViewFullIdCard, maskIdCardNo } from '../common/utils/pii.util';

const memberInclude = {
  school: true,
  group: true,
  associationMember: { include: { memberType: true } },
  beneficiaries: { orderBy: { priority: 'asc' as const } },
  protectedPersons: { orderBy: [{ isActive: 'desc' as const }, { createdAt: 'asc' as const }] },
};

export interface MemberQueryParams {
  schoolId?: string;
  status?: MemberStatus;
  membershipClass?: MembershipClass;
  memberTypeId?: string;
  groupId?: string;
  search?: string;
  page?: number;
  limit?: number;
}

@Injectable()
export class MembersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly documentNumberService: DocumentNumberService,
    private readonly membershipRules: MembershipRulesService,
    private readonly protectedPersons: ProtectedPersonsService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  async create(dto: CreateMemberDto, actor?: ScopedUser) {
    let associationMember;

    if (dto.associationMemberId) {
      associationMember = await this.prisma.associationMember.findUnique({
        where: { id: dto.associationMemberId },
        include: { school: true, memberType: true },
      });
      if (!associationMember) {
        throw new BadRequestException('ไม่พบสมาชิกสมาคมที่เลือก');
      }
      if (actor) {
        this.schoolScope.assertSchoolAccess(actor, associationMember.schoolId);
      }
      const existing = await this.prisma.member.findUnique({
        where: { associationMemberId: dto.associationMemberId },
      });
      if (existing) {
        throw new BadRequestException('สมาชิกสมาคมนี้เป็นสมาชิกฌาปนกิจอยู่แล้ว');
      }
    } else {
      const schoolId = dto.schoolId!;
      if (actor) {
        this.schoolScope.assertSchoolAccess(actor, schoolId);
      }
      const joinDate = new Date(dto.joinDate);
      associationMember = await this.prisma.associationMember.create({
        data: {
          schoolId,
          memberTypeId: dto.memberTypeId!,
          associationMemberNo: dto.associationMemberNo,
          firstName: dto.firstName!,
          lastName: dto.lastName!,
          idCardNo: dto.idCardNo,
          birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
          address: dto.address,
          phone: dto.phone,
          associationJoinDate: joinDate,
        },
        include: { school: true, memberType: true },
      });
    }

    const memberNo =
      dto.memberNo ||
      (await this.documentNumberService.generateNumber(DocumentType.MEMBER));
    const joinDate = new Date(dto.joinDate);
    const memberTypeCode = associationMember.memberType?.code ?? 'STF';
    const membershipFields = this.membershipRules.buildCreateMembershipFields({
      joinDate,
      memberTypeCode,
      salaryDeduction: dto.salaryDeduction,
      membershipClass: dto.membershipClass,
      applicationSubmittedAt: dto.applicationSubmittedAt
        ? new Date(dto.applicationSubmittedAt)
        : undefined,
    });

    const member = await this.prisma.member.create({
      data: {
        associationMemberId: associationMember.id,
        memberNo,
        schoolId: associationMember.schoolId,
        groupId: dto.groupId,
        joinDate,
        status: dto.status ?? MemberStatus.ACTIVE,
        salaryDeduction: dto.salaryDeduction ?? false,
        ...membershipFields,
        beneficiaries: dto.beneficiaries
          ? {
              create: dto.beneficiaries.map((b, i) => ({
                fullName: b.fullName,
                relationship: b.relationship,
                phone: b.phone,
                priority: b.priority ?? i + 1,
              })),
            }
          : undefined,
      },
      include: memberInclude,
    });

    if (dto.protectedPersons?.length) {
      await this.protectedPersons.syncForMember(member.id, dto.protectedPersons);
    }

    return this.findById(member.id);
  }

  async findAll(params: MemberQueryParams) {
    const { schoolId, status, membershipClass, memberTypeId, groupId, search, page = 1, limit = 50 } =
      params;

    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (status) where.status = status;
    if (membershipClass) where.membershipClass = membershipClass;
    if (groupId) where.groupId = groupId;
    if (memberTypeId) {
      where.associationMember = { memberTypeId };
    }
    if (search) {
      where.OR = [
        { memberNo: { contains: search } },
        { associationMember: { firstName: { contains: search } } },
        { associationMember: { lastName: { contains: search } } },
        { associationMember: { idCardNo: { contains: search } } },
      ];
    }

    const [members, total] = await Promise.all([
      this.prisma.member.findMany({
        where,
        include: memberInclude,
        orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.member.count({ where }),
    ]);

    return {
      data: members,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findById(id: string, actor?: ScopedUser) {
    const member = await this.prisma.member.findUnique({
      where: { id },
      include: {
        ...memberInclude,
        contributions: {
          include: { period: true },
          orderBy: { period: { year: 'desc' } },
          take: 12,
        },
        deathClaims: true,
      },
    });

    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    if (actor) {
      this.schoolScope.assertMemberSelfAccess(actor, id);
      this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    }

    return member;
  }

  async update(id: string, dto: UpdateMemberDto, actor?: ScopedUser) {
    await this.findById(id, actor);

    return this.prisma.member.update({
      where: { id },
      data: {
        groupId: dto.groupId,
        joinDate: dto.joinDate ? new Date(dto.joinDate) : undefined,
        status: dto.status,
        salaryDeduction: dto.salaryDeduction,
        membershipClass: dto.membershipClass,
        resignDate: dto.resignDate ? new Date(dto.resignDate) : undefined,
        deathDate: dto.deathDate ? new Date(dto.deathDate) : undefined,
      },
      include: memberInclude,
    });
  }

  async markMemberDeceasedInTransaction(
    tx: Prisma.TransactionClient,
    memberId: string,
    deathDate: string,
  ): Promise<void> {
    const member = await tx.member.findUnique({
      where: { id: memberId },
      include: { associationMember: { include: { memberType: true } } },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    const memberTypeCode = member.associationMember?.memberType?.code;
    await tx.member.update({
      where: { id: memberId },
      data: {
        status: MemberStatus.DECEASED,
        ...this.membershipRules.getStatusChangeExtras(
          MemberStatus.DECEASED,
          memberTypeCode,
          deathDate,
        ),
      },
    });

    await tx.protectedPerson.updateMany({
      where: { memberId, isActive: true },
      data: {
        isActive: false,
        endedAt: new Date(),
        endReason: 'สมาชิกเสียชีวิต',
      },
    });
  }

  async changeStatus(id: string, newStatus: MemberStatus, date?: string, actor?: ScopedUser) {
    const member = await this.findById(id, actor);
    const memberTypeCode = member.associationMember?.memberType?.code;

    const updateData: any = {
      status: newStatus,
      ...this.membershipRules.getStatusChangeExtras(newStatus, memberTypeCode, date),
    };

    await this.prisma.member.update({
      where: { id },
      data: updateData,
    });

    await this.membershipRules.applyStatusSideEffects(id, newStatus, memberTypeCode);
    return this.findById(id);
  }

  async getStatsBySchool(schoolId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    const where: any = scopedSchoolId ? { schoolId: scopedSchoolId } : {};

    const stats = await this.prisma.member.groupBy({
      by: ['status'],
      where,
      _count: true,
    });

    const membersWithType = await this.prisma.member.findMany({
      where,
      select: { associationMember: { select: { memberTypeId: true } } },
    });
    const byTypeMap = new Map<string, number>();
    for (const m of membersWithType) {
      const tid = m.associationMember.memberTypeId;
      byTypeMap.set(tid, (byTypeMap.get(tid) ?? 0) + 1);
    }
    const memberTypeIds = [...byTypeMap.keys()];
    const memberTypes = await this.prisma.memberType.findMany({
      where: { id: { in: memberTypeIds } },
    });

    return {
      byStatus: stats.map((s) => ({ status: s.status, count: s._count })),
      byType: memberTypes.map((mt) => ({
        type: mt,
        count: byTypeMap.get(mt.id) ?? 0,
      })),
    };
  }

  async getActiveCount(schoolId?: string) {
    return this.prisma.member.count({
      where: {
        ...(schoolId && { schoolId }),
        status: MemberStatus.ACTIVE,
      },
    });
  }

  async remove(id: string, actor?: ScopedUser) {
    const member = await this.findById(id, actor);
    const associationMemberId = member.associationMemberId;

    await this.prisma.$transaction(async (tx) => {
      await tx.member.delete({ where: { id } });
      await tx.associationMember.delete({ where: { id: associationMemberId } });
    });

    return { message: 'ลบสมาชิกสำเร็จ' };
  }

  async exportCsv(schoolId?: string, role?: Role): Promise<string> {
    const where: any = schoolId ? { schoolId } : {};
    const members = await this.prisma.member.findMany({
      where,
      include: {
        school: true,
        group: true,
        associationMember: { include: { memberType: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { memberNo: 'asc' }],
    });

    const header = [
      'memberNo',
      'firstName',
      'lastName',
      'schoolCode',
      'memberTypeCode',
      'groupCode',
      'status',
      'membershipClass',
      'joinDate',
      'phone',
      'idCardNo',
    ].join(',');

    const rows = members.map((m) => {
      const am = m.associationMember;
      const idCardNo =
        role && !canViewFullIdCard(role)
          ? maskIdCardNo(am.idCardNo) || ''
          : am.idCardNo || '';
      const values = [
        m.memberNo,
        am.firstName,
        am.lastName,
        m.school.code,
        am.memberType.code,
        m.group?.code || '',
        m.status,
        m.membershipClass,
        m.joinDate.toISOString().split('T')[0],
        am.phone || '',
        idCardNo,
      ];
      return values.map((v) => `"${String(v).replace(/"/g, '""')}"`).join(',');
    });

    return '\uFEFF' + [header, ...rows].join('\n');
  }

  async importCsv(rows: MemberCsvRowDto[], actor?: ScopedUser) {
    const results = { created: 0, updated: 0, skipped: 0, errors: [] as string[] };

    for (const row of rows) {
      try {
        const school = await this.prisma.school.findUnique({
          where: { code: row.schoolCode },
        });
        if (!school) {
          results.errors.push(`${row.memberNo}: ไม่พบโรงเรียน ${row.schoolCode}`);
          results.skipped++;
          continue;
        }

        if (actor) {
          try {
            this.schoolScope.assertSchoolAccess(actor, school.id);
          } catch {
            results.errors.push(`${row.memberNo}: ไม่มีสิทธิ์นำเข้าข้อมูลโรงเรียน ${row.schoolCode}`);
            results.skipped++;
            continue;
          }
        }

        const memberType = await this.prisma.memberType.findUnique({
          where: { code: row.memberTypeCode },
        });
        if (!memberType) {
          results.errors.push(`${row.memberNo}: ไม่พบประเภทสมาชิก ${row.memberTypeCode}`);
          results.skipped++;
          continue;
        }

        let groupId: string | undefined;
        if (row.groupCode) {
          const group = await this.prisma.group.findFirst({
            where: { schoolId: school.id, code: row.groupCode },
          });
          groupId = group?.id;
        }

        const existing = await this.prisma.member.findFirst({
          where: { memberNo: row.memberNo },
          include: { associationMember: true },
        });

        if (existing) {
          if (actor) {
            try {
              this.schoolScope.assertSchoolAccess(actor, existing.schoolId);
            } catch {
              results.errors.push(`${row.memberNo}: ไม่มีสิทธิ์แก้ไขสมาชิกโรงเรียนอื่น`);
              results.skipped++;
              continue;
            }
          }

          await this.prisma.associationMember.update({
            where: { id: existing.associationMemberId },
            data: {
              firstName: row.firstName,
              lastName: row.lastName,
              phone: row.phone,
              idCardNo: row.idCardNo,
              memberTypeId: memberType.id,
            },
          });
          await this.prisma.member.update({
            where: { id: existing.id },
            data: {
              groupId,
              status: (row.status as MemberStatus) || existing.status,
              joinDate: row.joinDate ? new Date(row.joinDate) : undefined,
            },
          });
          results.updated++;
          continue;
        }

        const associationMember = await this.prisma.associationMember.create({
          data: {
            schoolId: school.id,
            memberTypeId: memberType.id,
            firstName: row.firstName,
            lastName: row.lastName,
            phone: row.phone,
            idCardNo: row.idCardNo,
          },
        });

        await this.prisma.member.create({
          data: {
            associationMemberId: associationMember.id,
            memberNo: row.memberNo,
            schoolId: school.id,
            groupId,
            joinDate: row.joinDate ? new Date(row.joinDate) : new Date(),
            status: (row.status as MemberStatus) || MemberStatus.ACTIVE,
          },
        });
        results.created++;
      } catch (err: any) {
        results.errors.push(`${row.memberNo}: ${err.message || 'ข้อผิดพลาด'}`);
        results.skipped++;
      }
    }

    return results;
  }
}
