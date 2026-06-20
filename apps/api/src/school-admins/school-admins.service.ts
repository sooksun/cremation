import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSchoolAdminDto } from './dto/create-school-admin.dto';
import { UpdateSchoolAdminDto } from './dto/update-school-admin.dto';

export function buildDefaultSchoolAdminUsername(schoolCode: string): string {
  return `admin-${schoolCode.toLowerCase()}`;
}

@Injectable()
export class SchoolAdminsService {
  constructor(private readonly prisma: PrismaService) {}

  private stripPassword<T extends { passwordHash?: string }>(user: T) {
    const { passwordHash: _, ...result } = user;
    return result;
  }

  async assertSchoolHasNoAdmin(schoolId: string, excludeUserId?: string) {
    const existing = await this.prisma.user.findFirst({
      where: {
        role: Role.SCHOOL_ADMIN,
        schoolId,
        ...(excludeUserId ? { id: { not: excludeUserId } } : {}),
      },
    });

    if (existing) {
      throw new ConflictException('โรงเรียนนี้มีผู้ดูแลแล้ว (โรงเรียนละ 1 ผู้ดูแล)');
    }
  }

  async createForSchool(
    schoolId: string,
    data: {
      username: string;
      password: string;
      fullName: string;
      mustChangePassword?: boolean;
    },
  ) {
    const school = await this.prisma.school.findUnique({ where: { id: schoolId } });
    if (!school) {
      throw new NotFoundException('ไม่พบโรงเรียน');
    }

    await this.assertSchoolHasNoAdmin(schoolId);

    const usernameTaken = await this.prisma.user.findUnique({
      where: { username: data.username },
    });
    if (usernameTaken) {
      throw new ConflictException('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว');
    }

    const passwordHash = await bcrypt.hash(data.password, 10);
    const user = await this.prisma.user.create({
      data: {
        username: data.username,
        passwordHash,
        fullName: data.fullName,
        role: Role.SCHOOL_ADMIN,
        schoolId,
        mustChangePassword: data.mustChangePassword ?? true,
      },
      include: { school: true },
    });

    return this.stripPassword(user);
  }

  async create(dto: CreateSchoolAdminDto) {
    return this.createForSchool(dto.schoolId, {
      username: dto.username,
      password: dto.password,
      fullName: dto.fullName,
    });
  }

  async findAll() {
    const schools = await this.prisma.school.findMany({
      where: { isActive: true },
      include: {
        cluster: true,
        users: {
          where: { role: Role.SCHOOL_ADMIN },
          select: {
            id: true,
            username: true,
            fullName: true,
            mustChangePassword: true,
            createdAt: true,
            updatedAt: true,
          },
        },
      },
      orderBy: [{ cluster: { name: 'asc' } }, { name: 'asc' }],
    });

    return schools.map((school) => ({
      school: {
        id: school.id,
        code: school.code,
        name: school.name,
        district: school.district,
        province: school.province,
        cluster: school.cluster,
      },
      admin: school.users[0] ?? null,
    }));
  }

  async findBySchoolId(schoolId: string) {
    const admin = await this.prisma.user.findFirst({
      where: { role: Role.SCHOOL_ADMIN, schoolId },
      include: { school: true },
    });

    if (!admin) {
      throw new NotFoundException('โรงเรียนนี้ยังไม่มีผู้ดูแล');
    }

    return this.stripPassword(admin);
  }

  async update(schoolId: string, dto: UpdateSchoolAdminDto) {
    const admin = await this.prisma.user.findFirst({
      where: { role: Role.SCHOOL_ADMIN, schoolId },
    });

    if (!admin) {
      throw new NotFoundException('โรงเรียนนี้ยังไม่มีผู้ดูแล');
    }

    if (dto.username && dto.username !== admin.username) {
      const usernameTaken = await this.prisma.user.findUnique({
        where: { username: dto.username },
      });
      if (usernameTaken) {
        throw new ConflictException('ชื่อผู้ใช้นี้ถูกใช้งานแล้ว');
      }
    }

    const data: Record<string, unknown> = {};
    if (dto.fullName !== undefined) data.fullName = dto.fullName;
    if (dto.username !== undefined) data.username = dto.username;
    if (dto.password) {
      data.passwordHash = await bcrypt.hash(dto.password, 10);
    }

    if (Object.keys(data).length === 0) {
      throw new BadRequestException('ไม่มีข้อมูลที่ต้องอัปเดต');
    }

    const updated = await this.prisma.user.update({
      where: { id: admin.id },
      data,
      include: { school: true },
    });

    return this.stripPassword(updated);
  }

  async remove(schoolId: string) {
    const admin = await this.prisma.user.findFirst({
      where: { role: Role.SCHOOL_ADMIN, schoolId },
    });

    if (!admin) {
      throw new NotFoundException('โรงเรียนนี้ยังไม่มีผู้ดูแล');
    }

    await this.prisma.user.delete({ where: { id: admin.id } });
    return { message: 'ลบผู้ดูแลโรงเรียนสำเร็จ' };
  }
}