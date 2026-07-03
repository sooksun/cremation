import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';

@Injectable()
export class GroupsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateGroupDto, actor?: ScopedUser) {
    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    const group = await this.prisma.group.create({
      data: dto,
      include: {
        school: true,
        leader: true,
      },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.GROUP_CREATE,
        entityType: 'Group',
        entityId: group.id,
        schoolId: group.schoolId,
        metadata: { code: group.code, name: group.name, leaderId: group.leaderId },
      });
    }

    return group;
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

  async findById(id: string, actor?: ScopedUser) {
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

    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, group.schoolId);
    }

    return group;
  }

  async update(id: string, dto: UpdateGroupDto, actor?: ScopedUser) {
    await this.findById(id, actor);
    const before = await this.prisma.group.findUnique({ where: { id } });
    const updated = await this.prisma.group.update({
      where: { id },
      data: dto,
      include: { school: true, leader: true },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.GROUP_UPDATE,
        entityType: 'Group',
        entityId: id,
        schoolId: updated.schoolId,
        metadata: { updatedFields: Object.keys(dto), beforeLeader: before?.leaderId, leaderId: updated.leaderId },
      });
    }
    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id, actor);
    const group = await this.prisma.group.findUnique({ where: { id } });
    await this.prisma.group.delete({ where: { id } });

    if (actor && group) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.GROUP_DELETE,
        entityType: 'Group',
        entityId: id,
        schoolId: group.schoolId,
        metadata: { code: group.code, name: group.name },
      });
    }
    return { message: 'ลบกลุ่มสำเร็จ' };
  }
}