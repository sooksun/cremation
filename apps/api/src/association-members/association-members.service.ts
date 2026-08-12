import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAssociationMemberDto } from './dto/create-association-member.dto';
import { UpdateAssociationMemberDto } from './dto/update-association-member.dto';
import {
  MemberStatus,
  AssociationMemberStatus,
  MembershipEndReason,
} from '@prisma/client';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';

export interface AssociationMemberQueryParams {
  schoolId?: string;
  status?: MemberStatus;
  search?: string;
  associationStatus?: AssociationMemberStatus;
  membershipEndReason?: MembershipEndReason;
  page?: number;
  limit?: number;
}

@Injectable()
export class AssociationMembersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateAssociationMemberDto, actor?: ScopedUser) {
    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    const created = await this.prisma.associationMember.create({
      data: {
        schoolId: dto.schoolId,
        memberTypeId: dto.memberTypeId,
        associationMemberNo: dto.associationMemberNo,
        firstName: dto.firstName,
        lastName: dto.lastName,
        idCardNo: dto.idCardNo,
        birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
        address: dto.address,
        phone: dto.phone,
        position: dto.position,
        associationJoinDate: dto.associationJoinDate
          ? new Date(dto.associationJoinDate)
          : undefined,
        notes: dto.notes,
      },
      include: {
        school: true,
        memberType: true,
        cremationMember: { include: { group: true } },
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSOCIATION_MEMBER_CREATE,
        entityType: 'AssociationMember',
        entityId: created.id,
        schoolId: created.schoolId,
        metadata: { firstName: created.firstName, lastName: created.lastName, idCardNo: !!created.idCardNo },
      });
    }
    return created;
  }

  async findAll(params: AssociationMemberQueryParams, actor?: ScopedUser) {
    const {
      status,
      search,
      associationStatus,
      membershipEndReason,
      page = 1,
      limit = 50,
    } = params;
    const schoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, params.schoolId)
      : params.schoolId;

    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (status) {
      where.cremationMember = { status };
    }
    if (associationStatus) where.status = associationStatus;
    if (membershipEndReason) where.membershipEndReason = membershipEndReason;
    if (search) {
      where.OR = [
        { firstName: { contains: search } },
        { lastName: { contains: search } },
        { associationMemberNo: { contains: search } },
        { idCardNo: { contains: search } },
      ];
    }

    const [rows, total] = await Promise.all([
      this.prisma.associationMember.findMany({
        where,
        include: {
          school: { include: { cluster: true } },
          memberType: true,
          cremationMember: { include: { group: true } },
        },
        orderBy: [{ school: { name: 'asc' } }, { firstName: 'asc' }, { lastName: 'asc' }],
        skip: (page - 1) * limit,
        take: limit,
      }),
      this.prisma.associationMember.count({ where }),
    ]);

    return {
      data: rows,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findById(associationMemberId: string, actor?: ScopedUser) {
    const row = await this.prisma.associationMember.findUnique({
      where: { id: associationMemberId },
      include: {
        school: true,
        memberType: true,
        cremationMember: {
          include: { group: true, beneficiaries: { orderBy: { priority: 'asc' } } },
        },
      },
    });
    if (!row) {
      throw new NotFoundException('ไม่พบสมาชิกสมาคม');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, row.schoolId);
    }

    return row;
  }

  async findByMemberId(memberId: string, actor?: ScopedUser) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        school: true,
        group: true,
        associationMember: { include: { memberType: true } },
        beneficiaries: { orderBy: { priority: 'asc' } },
      },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    if (actor) {
      this.schoolScope.assertMemberSelfAccess(actor, memberId);
      this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    }

    return member;
  }

  async update(memberId: string, dto: UpdateAssociationMemberDto, actor?: ScopedUser) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: { associationMember: true },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, member.schoolId);
    }

    await this.prisma.associationMember.update({
      where: { id: member.associationMemberId },
      data: this.buildUpdateData(dto),
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSOCIATION_MEMBER_UPDATE,
        entityType: 'AssociationMember',
        entityId: member.associationMemberId,
        schoolId: member.schoolId,
        metadata: { updatedFields: Object.keys(dto), piiChanged: !!(dto.firstName || dto.lastName || dto.idCardNo || dto.birthDate || dto.address) },
      });
    }

    return this.findByMemberId(memberId, actor);
  }

  async updateById(
    associationMemberId: string,
    dto: UpdateAssociationMemberDto,
    actor?: ScopedUser,
  ) {
    const before = await this.findById(associationMemberId, actor);

    const updated = await this.prisma.associationMember.update({
      where: { id: associationMemberId },
      data: this.buildUpdateData(dto),
      include: {
        school: true,
        memberType: true,
        cremationMember: { include: { group: true } },
      },
    });

    if (actor && dto.status && dto.status !== before.status) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSOCIATION_MEMBER_UPDATE,
        entityType: 'AssociationMember',
        entityId: associationMemberId,
        schoolId: updated.schoolId,
        metadata: {
          from: before.status,
          to: dto.status,
          endReason: updated.membershipEndReason,
        },
      });
    }

    return updated;
  }

  private buildUpdateData(dto: UpdateAssociationMemberDto) {
    const data: any = {
      associationMemberNo: dto.associationMemberNo,
      position: dto.position,
      associationJoinDate: dto.associationJoinDate
        ? new Date(dto.associationJoinDate)
        : undefined,
      notes: dto.notes,
    };
    if (dto.firstName !== undefined) data.firstName = dto.firstName;
    if (dto.lastName !== undefined) data.lastName = dto.lastName;
    if (dto.idCardNo !== undefined) data.idCardNo = dto.idCardNo;
    if (dto.birthDate !== undefined) data.birthDate = new Date(dto.birthDate);
    if (dto.address !== undefined) data.address = dto.address;
    if (dto.phone !== undefined) data.phone = dto.phone;
    if (dto.memberTypeId !== undefined) data.memberTypeId = dto.memberTypeId;

    if (dto.status !== undefined) {
      data.status = dto.status;
      if (dto.status === AssociationMemberStatus.ENDED) {
        data.membershipEndReason =
          dto.membershipEndReason ?? MembershipEndReason.TRANSFERRED;
        data.membershipEndDate = dto.membershipEndDate
          ? new Date(dto.membershipEndDate)
          : new Date();
      } else {
        // กลับมาเป็นสมาชิกปกติ — ล้างเหตุและวันที่ทิ้ง ไม่งั้นจะค้างชี้ว่ายังหมดสมาชิกภาพ
        data.membershipEndReason = null;
        data.membershipEndDate = null;
      }
    }

    return data;
  }

  async removeById(associationMemberId: string, actor?: ScopedUser) {
    const row = await this.prisma.associationMember.findUnique({
      where: { id: associationMemberId },
      include: {
        cremationMember: {
          include: {
            user: true,
            _count: {
              select: {
                contributions: true,
                deathClaims: true,
                beneficiaries: true,
                protectedPersons: true,
                leadedGroups: true,
              },
            },
          },
        },
      },
    });
    if (!row) {
      throw new NotFoundException('ไม่พบสมาชิกสมาคม');
    }

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, row.schoolId);
    }

    if (row.cremationMember) {
      const c = row.cremationMember._count;
      if (
        c.contributions > 0 ||
        c.deathClaims > 0 ||
        c.beneficiaries > 0 ||
        c.protectedPersons > 0 ||
        c.leadedGroups > 0 ||
        row.cremationMember.user
      ) {
        throw new ConflictException(
          'ไม่สามารถลบสมาชิกนี้ได้ เนื่องจากมีข้อมูลการเงินหรือบัญชีผู้ใช้ที่เกี่ยวข้องอยู่ กรุณาปิดใช้งานสมาชิกแทน',
        );
      }
    }

    await this.prisma.associationMember.delete({ where: { id: associationMemberId } });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.ASSOCIATION_MEMBER_DELETE,
        entityType: 'AssociationMember',
        entityId: associationMemberId,
        schoolId: row.schoolId,
        metadata: { firstName: row.firstName, lastName: row.lastName },
      });
    }

    return { message: 'ลบสมาชิกสำเร็จ' };
  }
}