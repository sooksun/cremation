import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSchoolDto } from './dto/create-school.dto';
import { UpdateSchoolDto } from './dto/update-school.dto';

@Injectable()
export class SchoolsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createSchoolDto: CreateSchoolDto) {
    const existing = await this.prisma.school.findUnique({
      where: { code: createSchoolDto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสโรงเรียนนี้ถูกใช้งานแล้ว');
    }

    return this.prisma.school.create({
      data: createSchoolDto,
    });
  }

  async findAll(includeInactive = false) {
    return this.prisma.school.findMany({
      where: includeInactive ? undefined : { isActive: true },
      include: {
        _count: {
          select: { members: true, groups: true },
        },
      },
      orderBy: { name: 'asc' },
    });
  }

  async findById(id: string) {
    const school = await this.prisma.school.findUnique({
      where: { id },
      include: {
        groups: true,
        _count: {
          select: { members: true, users: true },
        },
      },
    });

    if (!school) {
      throw new NotFoundException('ไม่พบโรงเรียน');
    }

    return school;
  }

  async update(id: string, updateSchoolDto: UpdateSchoolDto) {
    await this.findById(id);

    return this.prisma.school.update({
      where: { id },
      data: updateSchoolDto,
    });
  }

  async remove(id: string) {
    await this.findById(id);

    // Soft delete by setting isActive to false
    await this.prisma.school.update({
      where: { id },
      data: { isActive: false },
    });

    return { message: 'ปิดใช้งานโรงเรียนสำเร็จ' };
  }
}

