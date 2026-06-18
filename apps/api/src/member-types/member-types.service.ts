import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateMemberTypeDto } from './dto/create-member-type.dto';
import { UpdateMemberTypeDto } from './dto/update-member-type.dto';

@Injectable()
export class MemberTypesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateMemberTypeDto) {
    const existing = await this.prisma.memberType.findUnique({
      where: { code: dto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสประเภทสมาชิกนี้ถูกใช้งานแล้ว');
    }

    return this.prisma.memberType.create({ data: dto });
  }

  async findAll(includeInactive = false) {
    return this.prisma.memberType.findMany({
      where: includeInactive ? undefined : { active: true },
      include: {
        _count: { select: { associationMembers: true } },
      },
      orderBy: { name: 'asc' },
    });
  }

  async findById(id: string) {
    const memberType = await this.prisma.memberType.findUnique({
      where: { id },
    });

    if (!memberType) {
      throw new NotFoundException('ไม่พบประเภทสมาชิก');
    }

    return memberType;
  }

  async update(id: string, dto: UpdateMemberTypeDto) {
    await this.findById(id);
    return this.prisma.memberType.update({
      where: { id },
      data: dto,
    });
  }

  async remove(id: string) {
    await this.findById(id);
    await this.prisma.memberType.update({
      where: { id },
      data: { active: false },
    });
    return { message: 'ปิดใช้งานประเภทสมาชิกสำเร็จ' };
  }
}

