import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateAssociationMemberDto } from './dto/create-association-member.dto';
import { UpdateAssociationMemberDto } from './dto/update-association-member.dto';
import { MemberStatus } from '@prisma/client';

export interface AssociationMemberQueryParams {
  schoolId?: string;
  status?: MemberStatus; // สถานะสมาชิกฌาปนกิจ (กรองเฉพาะคนที่เป็นสมาชิกฌาปนกิจ)
  search?: string;
  page?: number;
  limit?: number;
}

@Injectable()
export class AssociationMembersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateAssociationMemberDto) {
    return this.prisma.associationMember.create({
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
  }

  async findAll(params: AssociationMemberQueryParams) {
    const { schoolId, status, search, page = 1, limit = 50 } = params;

    const where: any = {};
    if (schoolId) where.schoolId = schoolId;
    if (status) {
      where.cremationMember = { status };
    }
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

  /** ดึงข้อมูลสมาชิกสมาคมโดยใช้ id ของสมาชิกสมาคม */
  async findById(associationMemberId: string) {
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
    return row;
  }

  /** ดึงข้อมูลสมาชิกสมาคมของสมาชิกฌาปนกิจ (memberId = สมาชิกฌาปนกิจ id) */
  async findByMemberId(memberId: string) {
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
    return member;
  }

  async update(memberId: string, dto: UpdateAssociationMemberDto) {
    const member = await this.prisma.member.findUnique({
      where: { id: memberId },
      include: { associationMember: true },
    });
    if (!member) {
      throw new NotFoundException('ไม่พบสมาชิก');
    }

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

    await this.prisma.associationMember.update({
      where: { id: member.associationMemberId },
      data,
    });

    return this.findByMemberId(memberId);
  }

  /** อัปเดตข้อมูลสมาชิกสมาคมโดยใช้ id ของสมาชิกสมาคม */
  async updateById(associationMemberId: string, dto: UpdateAssociationMemberDto) {
    await this.findById(associationMemberId);

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

    return this.prisma.associationMember.update({
      where: { id: associationMemberId },
      data,
      include: {
        school: true,
        memberType: true,
        cremationMember: { include: { group: true } },
      },
    });
  }
}
