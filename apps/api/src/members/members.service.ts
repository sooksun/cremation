import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService, DocumentType } from '../common/document-number.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { MemberStatus } from '@prisma/client';

export interface MemberQueryParams {
  schoolId?: string;
  status?: MemberStatus;
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
  ) {}

  async create(dto: CreateMemberDto) {
    // Auto-generate memberNo if not provided
    const memberNo = dto.memberNo || (await this.documentNumberService.generateNumber(DocumentType.MEMBER));
    const joinDate = new Date(dto.joinDate);

    const member = await this.prisma.member.create({
      data: {
        memberNo,
        schoolId: dto.schoolId,
        memberTypeId: dto.memberTypeId,
        groupId: dto.groupId,
        firstName: dto.firstName,
        lastName: dto.lastName,
        idCardNo: dto.idCardNo,
        birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
        address: dto.address,
        phone: dto.phone,
        joinDate,
        status: dto.status || MemberStatus.ACTIVE,
        salaryDeduction: dto.salaryDeduction ?? false,
        beneficiaries: dto.beneficiaries
          ? {
              create: dto.beneficiaries.map((b, i) => ({
                fullName: b.fullName,
                relationship: b.relationship,
                phone: b.phone,
                priority: b.priority || i + 1,
              })),
            }
          : undefined,
      },
      include: {
        school: true,
        memberType: true,
        group: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
      },
    });

    // สมาชิกฌาปนกิจทุกคนเป็นสมาชิกสมาคมผู้ประกอบวิชาชีพด้วย
    try {
      await this.prisma.associationMember.create({
        data: {
          memberId: member.id,
          schoolId: member.schoolId,
          memberTypeId: member.memberTypeId,
          associationJoinDate: joinDate,
        },
      });
    } catch {
      // Table อาจยังไม่มี (ก่อน migration) - ไม่บล็อกการสร้างสมาชิก
    }

    const withProfile = await this.prisma.member.findUnique({
      where: { id: member.id },
      include: {
        school: true,
        memberType: true,
        group: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
        associationProfile: true,
      },
    });
    return withProfile ?? member;
  }

  async findAll(params: MemberQueryParams) {
    const { schoolId, status, memberTypeId, groupId, search, page = 1, limit = 50 } = params;

    const where: any = {};

    if (schoolId) where.schoolId = schoolId;
    if (status) where.status = status;
    if (memberTypeId) where.memberTypeId = memberTypeId;
    if (groupId) where.groupId = groupId;
    if (search) {
      where.OR = [
        { firstName: { contains: search } },
        { lastName: { contains: search } },
        { memberNo: { contains: search } },
        { idCardNo: { contains: search } },
      ];
    }

    const [members, total] = await Promise.all([
      this.prisma.member.findMany({
        where,
        include: {
          school: true,
          memberType: true,
          group: true,
        },
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

  async findById(id: string) {
    const member = await this.prisma.member.findUnique({
      where: { id },
      include: {
        school: true,
        memberType: true,
        group: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
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

    return member;
  }

  async update(id: string, dto: UpdateMemberDto) {
    await this.findById(id);

    return this.prisma.member.update({
      where: { id },
      data: {
        memberTypeId: dto.memberTypeId,
        groupId: dto.groupId,
        firstName: dto.firstName,
        lastName: dto.lastName,
        idCardNo: dto.idCardNo,
        birthDate: dto.birthDate ? new Date(dto.birthDate) : undefined,
        address: dto.address,
        phone: dto.phone,
        joinDate: dto.joinDate ? new Date(dto.joinDate) : undefined,
        status: dto.status,
        salaryDeduction: dto.salaryDeduction,
        resignDate: dto.resignDate ? new Date(dto.resignDate) : undefined,
        deathDate: dto.deathDate ? new Date(dto.deathDate) : undefined,
      },
      include: {
        school: true,
        memberType: true,
        group: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
      },
    });
  }

  async changeStatus(id: string, newStatus: MemberStatus, date?: string) {
    const member = await this.findById(id);

    const updateData: any = { status: newStatus };

    if (newStatus === MemberStatus.RESIGNED && date) {
      updateData.resignDate = new Date(date);
    } else if (newStatus === MemberStatus.DECEASED && date) {
      updateData.deathDate = new Date(date);
    }

    return this.prisma.member.update({
      where: { id },
      data: updateData,
      include: {
        school: true,
        memberType: true,
        group: true,
      },
    });
  }

  async getStatsBySchool(schoolId?: string) {
    const where = schoolId ? { schoolId } : {};

    const stats = await this.prisma.member.groupBy({
      by: ['status'],
      where,
      _count: true,
    });

    const byType = await this.prisma.member.groupBy({
      by: ['memberTypeId'],
      where,
      _count: true,
    });

    const memberTypes = await this.prisma.memberType.findMany({
      where: { id: { in: byType.map((b) => b.memberTypeId) } },
    });

    return {
      byStatus: stats.map((s) => ({
        status: s.status,
        count: s._count,
      })),
      byType: byType.map((b) => ({
        type: memberTypes.find((mt) => mt.id === b.memberTypeId),
        count: b._count,
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

  async remove(id: string) {
    await this.findById(id);
    await this.prisma.member.delete({ where: { id } });
    return { message: 'ลบสมาชิกสำเร็จ' };
  }
}

