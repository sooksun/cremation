import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { UpdateAssociationMemberDto } from './dto/update-association-member.dto';
import { MemberStatus } from '@prisma/client';

export interface AssociationMemberQueryParams {
  schoolId?: string;
  status?: MemberStatus;
  search?: string;
  page?: number;
  limit?: number;
}

@Injectable()
export class AssociationMembersService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(params: AssociationMemberQueryParams) {
    const { schoolId, status, search, page = 1, limit = 50 } = params;

    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (status) where.status = status;
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
          associationProfile: true,
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

  async findByMemberId(memberId: string) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: {
        school: true,
        memberType: true,
        group: true,
        associationProfile: true,
        beneficiaries: { orderBy: { priority: 'asc' } },
      },
    });

    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    return member;
  }

  async update(memberId: string, dto: UpdateAssociationMemberDto) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: { associationProfile: true },
    });

    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    const data = {
      associationMemberNo: dto.associationMemberNo,
      position: dto.position,
      associationJoinDate: dto.associationJoinDate
        ? new Date(dto.associationJoinDate)
        : undefined,
      notes: dto.notes,
    };

    if (member.associationProfile) {
      return this.prisma.associationMember.update({
        where: { memberId },
        data,
        include: { member: { include: { school: true, memberType: true, group: true } } },
      });
    }

    return this.prisma.associationMember.create({
      data: {
        memberId,
        schoolId: member.schoolId,
        memberTypeId: member.memberTypeId,
        ...data,
      },
      include: { member: { include: { school: true, memberType: true, group: true } } },
    });
  }

  async ensureAssociationProfile(memberId: string, joinDate?: Date) {
    const existing = await this.prisma.associationMember.findUnique({
      where: { memberId },
    });
    if (existing) return existing;

    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

    return this.prisma.associationMember.create({
      data: {
        memberId,
        schoolId: member.schoolId,
        memberTypeId: member.memberTypeId,
        associationJoinDate: joinDate || member.joinDate,
      },
    });
  }
}
