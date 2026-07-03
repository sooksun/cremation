import { Injectable, ConflictException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateMemberTypeDto } from './dto/create-member-type.dto';
import { UpdateMemberTypeDto } from './dto/update-member-type.dto';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Injectable()
export class MemberTypesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly auditLog: AuditLogService,
  ) {}

  async create(dto: CreateMemberTypeDto, actor?: ScopedUser) {
    const existing = await this.prisma.memberType.findUnique({
      where: { code: dto.code },
    });

    if (existing) {
      throw new ConflictException('รหัสประเภทสมาชิกนี้ถูกใช้งานแล้ว');
    }

    const created = await this.prisma.memberType.create({ data: dto });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.MEMBER_TYPE_CREATE,
        entityType: 'MemberType',
        entityId: created.id,
        metadata: { code: created.code, name: created.name },
      });
    }
    return created;
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

  async update(id: string, dto: UpdateMemberTypeDto, actor?: ScopedUser) {
    await this.findById(id);
    const updated = await this.prisma.memberType.update({
      where: { id },
      data: dto,
    });
    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.MEMBER_TYPE_UPDATE,
        entityType: 'MemberType',
        entityId: id,
        metadata: { updatedFields: Object.keys(dto) },
      });
    }
    return updated;
  }

  async remove(id: string, actor?: ScopedUser) {
    await this.findById(id);
    const mt = await this.prisma.memberType.findUnique({ where: { id } });
    await this.prisma.memberType.update({
      where: { id },
      data: { active: false },
    });
    if (actor && mt) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.MEMBER_TYPE_DELETE,
        entityType: 'MemberType',
        entityId: id,
        metadata: { code: mt.code, name: mt.name },
      });
    }
    return { message: 'ปิดใช้งานประเภทสมาชิกสำเร็จ' };
  }
}

