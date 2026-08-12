import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AuditAction, MemberStatus } from '@prisma/client';

// สมาชิกที่สิ้นสุดสมาชิกภาพแล้วไม่ต้องอยู่ในกลุ่มเก็บเงิน
const COLLECTABLE_STATUSES: MemberStatus[] = [
  MemberStatus.ACTIVE,
  MemberStatus.ARREARS,
  MemberStatus.SUSPENDED,
];

@Injectable()
export class GroupsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly schoolScope: SchoolScopeService,
    private readonly auditLog: AuditLogService,
  ) {}

  private async assertLeaderInSchool(leaderId: string, schoolId: string) {
    const leader = await this.prisma.member.findUnique({
      where: { id: leaderId },
      select: { schoolId: true },
    });

    if (!leader) {
      throw new NotFoundException('ไม่พบสมาชิกที่ระบุเป็นหัวหน้ากลุ่ม');
    }

    if (leader.schoolId !== schoolId) {
      throw new BadRequestException('หัวหน้ากลุ่มต้องเป็นสมาชิกของโรงเรียนเดียวกัน');
    }
  }

  async create(dto: CreateGroupDto, actor?: ScopedUser) {
    if (actor) {
      this.schoolScope.assertSchoolAccess(actor, dto.schoolId);
    }

    if (dto.leaderId) {
      await this.assertLeaderInSchool(dto.leaderId, dto.schoolId);
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

    if (dto.leaderId) {
      const targetSchoolId = dto.schoolId ?? before?.schoolId;
      if (targetSchoolId) {
        await this.assertLeaderInSchool(dto.leaderId, targetSchoolId);
      }
    }

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

  // ชื่อโรงเรียนในระบบยาวมาก (มีชื่อกลุ่มเครือข่ายต่อท้าย) — ตัดให้เหลือแค่ชื่อโรงเรียน
  private shortSchoolName(name: string) {
    return name
      .replace(/^โรงเรียน\s*\.?\s*/, '')
      .split(/\s+กลุ่มเครือข่าย/)[0]
      .trim();
  }

  /** ย้ายสมาชิกที่ระบุเข้ากลุ่มทีเดียวหลายคน */
  async assignMembers(groupId: string, memberIds: string[], actor?: ScopedUser) {
    const group = await this.findById(groupId, actor);

    const members = await this.prisma.member.findMany({
      where: { id: { in: memberIds } },
      select: { id: true, schoolId: true },
    });

    if (members.length !== memberIds.length) {
      throw new NotFoundException('ไม่พบสมาชิกบางรายการที่เลือก');
    }

    // กลุ่มเก็บเงินสังกัดโรงเรียน — รับเฉพาะสมาชิกโรงเรียนเดียวกัน ไม่งั้นยอดเก็บเงินจะข้ามโรงเรียน
    const foreign = members.filter((m) => m.schoolId !== group.schoolId);
    if (foreign.length > 0) {
      throw new BadRequestException(
        `มีสมาชิก ${foreign.length} คนไม่ได้สังกัดโรงเรียนเดียวกับกลุ่มนี้`,
      );
    }

    const result = await this.prisma.member.updateMany({
      where: { id: { in: memberIds } },
      data: { groupId },
    });

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.GROUP_UPDATE,
        entityType: 'Group',
        entityId: groupId,
        schoolId: group.schoolId,
        metadata: { assignedMembers: result.count, memberIds },
      });
    }

    return { message: `ย้ายสมาชิก ${result.count} คนเข้ากลุ่มสำเร็จ`, assigned: result.count };
  }

  /**
   * จัดสมาชิกที่ยังไม่มีกลุ่มเข้ากลุ่มของโรงเรียนตัวเอง สร้างกลุ่มให้ถ้ายังไม่มี
   * รันซ้ำได้ — โรงเรียนที่มีกลุ่มอยู่แล้วจะใช้กลุ่มเดิม ไม่สร้างเพิ่ม
   */
  async autoAssignBySchool(schoolId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;
    if (scopedSchoolId) {
      this.schoolScope.assertSchoolAccess(actor as ScopedUser, scopedSchoolId);
    }

    const pending = await this.prisma.member.findMany({
      where: {
        groupId: null,
        status: { in: COLLECTABLE_STATUSES },
        ...(scopedSchoolId ? { schoolId: scopedSchoolId } : {}),
      },
      select: { id: true, schoolId: true, school: { select: { name: true } } },
    });

    if (pending.length === 0) {
      return { message: 'ไม่มีสมาชิกที่ต้องจัดกลุ่ม', groupsCreated: 0, membersAssigned: 0, perSchool: [] };
    }

    const bySchool = new Map<string, { name: string; memberIds: string[] }>();
    for (const m of pending) {
      const entry = bySchool.get(m.schoolId) ?? { name: m.school.name, memberIds: [] };
      entry.memberIds.push(m.id);
      bySchool.set(m.schoolId, entry);
    }

    let groupsCreated = 0;
    let membersAssigned = 0;
    const perSchool: Array<{ schoolName: string; groupName: string; assigned: number; createdGroup: boolean }> = [];

    for (const [sid, { name, memberIds }] of bySchool) {
      let group = await this.prisma.group.findFirst({
        where: { schoolId: sid },
        orderBy: { code: 'asc' },
      });

      let createdGroup = false;
      if (!group) {
        group = await this.prisma.group.create({
          data: { schoolId: sid, code: 'G01', name: `กลุ่ม${this.shortSchoolName(name)} 1` },
        });
        groupsCreated += 1;
        createdGroup = true;
      }

      const res = await this.prisma.member.updateMany({
        where: { id: { in: memberIds } },
        data: { groupId: group.id },
      });
      membersAssigned += res.count;
      perSchool.push({ schoolName: name, groupName: group.name, assigned: res.count, createdGroup });
    }

    if (actor) {
      await this.auditLog.log({
        userId: actor.id,
        action: AuditAction.GROUP_UPDATE,
        entityType: 'Group',
        entityId: scopedSchoolId ?? 'ALL',
        schoolId: scopedSchoolId,
        metadata: { autoAssign: true, groupsCreated, membersAssigned },
      });
    }

    return {
      message: `จัดกลุ่มสำเร็จ — สร้างกลุ่มใหม่ ${groupsCreated} กลุ่ม, จัดสมาชิก ${membersAssigned} คน`,
      groupsCreated,
      membersAssigned,
      perSchool,
    };
  }

  /** ดูว่าถ้ากด "จัดกลุ่มอัตโนมัติ" จะเกิดอะไรขึ้น โดยยังไม่แก้ข้อมูล */
  async previewAutoAssign(schoolId?: string, actor?: ScopedUser) {
    const scopedSchoolId = actor
      ? this.schoolScope.resolveSchoolId(actor, schoolId)
      : schoolId;

    const pending = await this.prisma.member.findMany({
      where: {
        groupId: null,
        status: { in: COLLECTABLE_STATUSES },
        ...(scopedSchoolId ? { schoolId: scopedSchoolId } : {}),
      },
      select: { schoolId: true, school: { select: { name: true, _count: { select: { groups: true } } } } },
    });

    const bySchool = new Map<string, { schoolName: string; pending: number; willCreateGroup: boolean }>();
    for (const m of pending) {
      const e = bySchool.get(m.schoolId) ?? {
        schoolName: m.school.name,
        pending: 0,
        willCreateGroup: m.school._count.groups === 0,
      };
      e.pending += 1;
      bySchool.set(m.schoolId, e);
    }

    const perSchool = [...bySchool.values()].sort((a, b) => a.schoolName.localeCompare(b.schoolName, 'th'));
    return {
      totalPending: pending.length,
      groupsToCreate: perSchool.filter((s) => s.willCreateGroup).length,
      perSchool,
    };
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