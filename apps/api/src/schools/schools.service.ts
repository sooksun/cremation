import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSchoolDto } from './dto/create-school.dto';
import { UpdateSchoolDto } from './dto/update-school.dto';
import {
  buildDefaultSchoolAdminUsername,
  SchoolAdminsService,
} from '../school-admins/school-admins.service';
import { generateTemporaryPassword } from '../common/utils/password.util';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class SchoolsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolAdminsService: SchoolAdminsService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(createSchoolDto: CreateSchoolDto, actor?: ScopedUser) {
    const existing = await this.prisma.school.findUnique({
      where: { code: createSchoolDto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสโรงเรียนนี้ถูกใช้งานแล้ว');
    }

    const school = await this.prisma.school.create({
      data: createSchoolDto,
      include: { cluster: true },
    });

    const initialAdminPassword = generateTemporaryPassword();
    await this.schoolAdminsService.createForSchool(school.id, {
      username: buildDefaultSchoolAdminUsername(school.code),
      password: initialAdminPassword,
      fullName: `ผู้ดูแล ${school.name}`,
      mustChangePassword: true,
    }, actor);

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.SCHOOL_CREATE,
        entityType: 'School',
        entityId: school.id,
        schoolId: school.id,
        metadata: { code: school.code, name: school.name },
      });
    }

    return {
      ...school,
      initialAdminPassword,
      initialAdminUsername: buildDefaultSchoolAdminUsername(school.code),
    };
  }

  async findAll(includeInactive = false, clusterId?: string) {
    return this.prisma.school.findMany({
      where: {
        ...(includeInactive ? {} : { isActive: true }),
        ...(clusterId ? { clusterId } : {}),
      },
      include: {
        cluster: true,
        _count: {
          select: { associationMembers: true, groups: true },
        },
      },
      orderBy: [{ cluster: { name: 'asc' } }, { name: 'asc' }],
    });
  }

  async findById(id: string) {
    const school = await this.prisma.school.findUnique({
      where: { id },
      include: {
        cluster: true,
        groups: true,
        _count: {
          select: { associationMembers: true, users: true },
        },
      },
    });

    if (!school) {
      throw new NotFoundException('ไม่พบโรงเรียน');
    }

    return school;
  }

  async update(id: string, updateSchoolDto: UpdateSchoolDto, actor?: ScopedUser) {
    await this.findById(id);

    const updated = await this.prisma.school.update({
      where: { id },
      data: updateSchoolDto,
      include: { cluster: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.SCHOOL_UPDATE,
        entityType: 'School',
        entityId: id,
        schoolId: id,
        metadata: { updatedFields: Object.keys(updateSchoolDto) },
      });
    }

    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id);

    // Soft delete by setting isActive to false
    await this.prisma.school.update({
      where: { id },
      data: { isActive: false },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.SCHOOL_DELETE,
        entityType: 'School',
        entityId: id,
        schoolId: id,
        metadata: { softDelete: true },
      });
    }

    return { message: 'ปิดใช้งานโรงเรียนสำเร็จ' };
  }
}

