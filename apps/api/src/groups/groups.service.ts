import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';

@Injectable()
export class GroupsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateGroupDto) {
    return this.prisma.group.create({
      data: dto,
      include: {
        school: true,
        leader: true,
      },
    });
  }

  async findAll(schoolId?: string) {
    return this.prisma.group.findMany({
      where: schoolId ? { schoolId } : undefined,
      include: {
        school: true,
        leader: {
          select: {
            id: true,
            associationMember: { select: { firstName: true, lastName: true } },
          },
        },
        _count: { select: { members: true } },
      },
      orderBy: [{ school: { name: 'asc' } }, { code: 'asc' }],
    });
  }

  async findById(id: string) {
    const group = await this.prisma.group.findUnique({
      where: { id },
      include: {
        school: true,
        leader: true,
        members: {
          select: {
            id: true,
            memberNo: true,
            status: true,
            associationMember: { select: { firstName: true, lastName: true } },
          },
        },
      },
    });

    if (!group) {
      throw new NotFoundException('ไม่พบกลุ่ม');
    }

    return group;
  }

  async update(id: string, dto: UpdateGroupDto) {
    await this.findById(id);
    return this.prisma.group.update({
      where: { id },
      data: dto,
      include: { school: true, leader: true },
    });
  }

  async remove(id: string) {
    await this.findById(id);
    await this.prisma.group.delete({ where: { id } });
    return { message: 'ลบกลุ่มสำเร็จ' };
  }
}

