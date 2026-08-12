import { BadRequestException, NotFoundException } from '@nestjs/common';
import { MemberStatus } from '@prisma/client';
import { GroupsService } from './groups.service';

describe('GroupsService bulk assignment', () => {
  const group = { id: 'g1', schoolId: 'school-1', name: 'กลุ่มบ้านเทอดไทย 1', code: 'G01' };

  const makeService = (prismaOverrides: Record<string, unknown> = {}) => {
    const prisma = {
      group: {
        findUnique: jest.fn().mockResolvedValue(group),
        findFirst: jest.fn(),
        create: jest.fn(),
      },
      member: {
        findMany: jest.fn(),
        updateMany: jest.fn().mockResolvedValue({ count: 2 }),
      },
      ...prismaOverrides,
    };
    const schoolScope = {
      assertSchoolAccess: jest.fn(),
      resolveSchoolId: jest.fn((_u: unknown, id?: string) => id),
    };
    const auditLog = { log: jest.fn() };
    const service = new GroupsService(prisma as never, schoolScope as never, auditLog as never);
    return { service, prisma, auditLog };
  };

  const actor = { id: 'u1', role: 'ADMIN', schoolId: null } as never;

  it('assigns members that belong to the group school', async () => {
    const { service, prisma, auditLog } = makeService();
    prisma.member.findMany.mockResolvedValue([
      { id: 'm1', schoolId: 'school-1' },
      { id: 'm2', schoolId: 'school-1' },
    ]);

    const result = await service.assignMembers('g1', ['m1', 'm2'], actor);

    expect(result.assigned).toBe(2);
    expect(prisma.member.updateMany).toHaveBeenCalledWith({
      where: { id: { in: ['m1', 'm2'] } },
      data: { groupId: 'g1' },
    });
    expect(auditLog.log).toHaveBeenCalled();
  });

  it('refuses members from another school so collection totals stay per-school', async () => {
    const { service, prisma } = makeService();
    prisma.member.findMany.mockResolvedValue([
      { id: 'm1', schoolId: 'school-1' },
      { id: 'm2', schoolId: 'school-2' },
    ]);

    await expect(service.assignMembers('g1', ['m1', 'm2'], actor)).rejects.toThrow(
      BadRequestException,
    );
    expect(prisma.member.updateMany).not.toHaveBeenCalled();
  });

  it('refuses when a selected member no longer exists', async () => {
    const { service, prisma } = makeService();
    prisma.member.findMany.mockResolvedValue([{ id: 'm1', schoolId: 'school-1' }]);

    await expect(service.assignMembers('g1', ['m1', 'gone'], actor)).rejects.toThrow(
      NotFoundException,
    );
    expect(prisma.member.updateMany).not.toHaveBeenCalled();
  });

  describe('autoAssignBySchool', () => {
    it('creates one group per school that has none, then assigns its members', async () => {
      const { service, prisma } = makeService();
      prisma.member.findMany.mockResolvedValue([
        { id: 'm1', schoolId: 's1', school: { name: 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' } },
        { id: 'm2', schoolId: 's1', school: { name: 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' } },
      ]);
      prisma.group.findFirst.mockResolvedValue(null);
      prisma.group.create.mockResolvedValue({ id: 'new-g', name: 'กลุ่มบ้านเทอดไทย 1' });

      const result = await service.autoAssignBySchool(undefined, actor);

      expect(result.groupsCreated).toBe(1);
      expect(result.membersAssigned).toBe(2);
      // ชื่อโรงเรียนยาวมาก ต้องตัดส่วนกลุ่มเครือข่ายออกก่อนตั้งชื่อกลุ่ม
      expect(prisma.group.create).toHaveBeenCalledWith({
        data: { schoolId: 's1', code: 'G01', name: 'กลุ่มบ้านเทอดไทย 1' },
      });
    });

    it('reuses an existing group instead of creating duplicates when run twice', async () => {
      const { service, prisma } = makeService();
      prisma.member.findMany.mockResolvedValue([
        { id: 'm1', schoolId: 's1', school: { name: 'โรงเรียนบ้านกลาง' } },
      ]);
      prisma.group.findFirst.mockResolvedValue({ id: 'existing', name: 'กลุ่มเดิม' });
      prisma.member.updateMany.mockResolvedValue({ count: 1 });

      const result = await service.autoAssignBySchool(undefined, actor);

      expect(prisma.group.create).not.toHaveBeenCalled();
      expect(result.groupsCreated).toBe(0);
      expect(result.membersAssigned).toBe(1);
    });

    it('leaves resigned and deceased members out of collection groups', async () => {
      const { service, prisma } = makeService();
      prisma.member.findMany.mockResolvedValue([]);

      const result = await service.autoAssignBySchool(undefined, actor);

      expect(result.membersAssigned).toBe(0);
      expect(prisma.member.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({
            groupId: null,
            status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS, MemberStatus.SUSPENDED] },
          }),
        }),
      );
    });
  });
});
