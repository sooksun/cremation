import { BadRequestException } from '@nestjs/common';
import { Role, MemberStatus } from '@prisma/client';
import { MembersService } from './members.service';

describe('MembersService guards', () => {
  const deceasedMember = {
    id: 'member-1',
    memberNo: 'M001',
    schoolId: 'school-1',
    associationMemberId: 'am-1',
    status: MemberStatus.DECEASED,
    school: { id: 'school-1', name: 'School' },
    group: null,
    associationMember: { memberType: { code: 'STF' } },
    beneficiaries: [],
    protectedPersons: [],
    contributions: [],
    deathClaims: [],
  };

  const prisma = {
    member: {
      findUnique: jest.fn().mockResolvedValue(deceasedMember),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    associationMember: {
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    school: {
      findUnique: jest.fn(),
    },
    memberType: {
      findUnique: jest.fn(),
    },
  };
  const schoolScope = {
    assertSchoolAccess: jest.fn(),
    assertMemberSelfAccess: jest.fn(),
  };
  const auditLog = { log: jest.fn() };

  const service = new MembersService(
    prisma as never,
    {} as never,
    {} as never,
    {} as never,
    schoolScope as never,
    auditLog as never,
  );

  beforeEach(() => jest.clearAllMocks());

  describe('locked record after death (PRD gap #11)', () => {
    const financeActor = { id: 'u1', role: Role.FINANCE, schoolId: 'school-1' } as never;

    it('blocks non-admin update of a deceased member', async () => {
      prisma.member.findUnique.mockResolvedValue(deceasedMember);
      await expect(service.update('member-1', {}, financeActor)).rejects.toThrow(
        BadRequestException,
      );
      expect(prisma.member.update).not.toHaveBeenCalled();
    });

    it('blocks non-admin status change of a deceased member', async () => {
      prisma.member.findUnique.mockResolvedValue(deceasedMember);
      await expect(
        service.changeStatus('member-1', MemberStatus.ACTIVE, undefined, financeActor),
      ).rejects.toThrow(BadRequestException);
      expect(prisma.member.update).not.toHaveBeenCalled();
    });

    it('allows admin to correct a deceased member', async () => {
      prisma.member.findUnique.mockResolvedValue(deceasedMember);
      prisma.member.update.mockResolvedValue(deceasedMember);
      const adminActor = { id: 'u2', role: Role.ADMIN } as never;
      await expect(service.update('member-1', {}, adminActor)).resolves.toBeDefined();
      expect(prisma.member.update).toHaveBeenCalled();
    });
  });

  describe('duplicate registration guard (PRD gap #10)', () => {
    const actor = { id: 'u1', role: Role.ADMIN } as never;
    const dto = {
      schoolId: 'school-1',
      memberTypeId: 'mt-1',
      firstName: 'A',
      lastName: 'B',
      idCardNo: '1234567890123',
      joinDate: '2026-01-01',
    } as never;

    it('rejects a new registration when the ID card belongs to a resigned former member', async () => {
      prisma.associationMember.findFirst.mockResolvedValue({
        id: 'am-9',
        cremationMember: { memberNo: 'M099', status: MemberStatus.RESIGNED },
      });
      await expect(service.create(dto, actor)).rejects.toThrow(/ลาออก/);
    });

    it('points to the working recovery path (edit the existing member) instead of the dead-end associationMemberId retry', async () => {
      prisma.associationMember.findFirst.mockResolvedValue({
        id: 'am-9',
        cremationMember: { memberNo: 'M099', status: MemberStatus.RESIGNED },
      });

      let message = '';
      try {
        await service.create(dto, actor);
      } catch (err: any) {
        message = err.message;
      }

      expect(message).toContain('M099');
      expect(message).toContain('แก้ไขสมาชิก');
      expect(message).not.toContain('ผูกกับสมาชิกสมาคมเดิม');
    });

    it('rejects a new registration when the ID card already exists in the association registry', async () => {
      prisma.associationMember.findFirst.mockResolvedValue({
        id: 'am-9',
        cremationMember: null,
      });
      await expect(service.create(dto, actor)).rejects.toThrow(/มีอยู่ในทะเบียน/);
    });

    it('scopes the duplicate ID-card check to the target school (no cross-tenant leak)', async () => {
      prisma.associationMember.findFirst.mockResolvedValue(null);
      await service.create(dto, actor).catch(() => {});
      expect(prisma.associationMember.findFirst).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ schoolId: 'school-1', idCardNo: '1234567890123' }),
        }),
      );
    });
  });

  describe('importCsv respects the locked-record guard (security fix)', () => {
    const financeActor = { id: 'u1', role: Role.FINANCE, schoolId: 'school-1' } as never;
    const csvRow = {
      memberNo: 'M001',
      firstName: 'A',
      lastName: 'B',
      schoolCode: 'SCH1',
      memberTypeCode: 'STF',
      status: 'ACTIVE',
    } as never;

    it('does not update a deceased member via CSV import for a non-admin actor', async () => {
      prisma.school.findUnique.mockResolvedValue({ id: 'school-1', code: 'SCH1' });
      prisma.memberType.findUnique.mockResolvedValue({ id: 'mt-1', code: 'STF' });
      prisma.member.findFirst.mockResolvedValue(deceasedMember);

      const result = await service.importCsv([csvRow], financeActor);

      expect(prisma.associationMember.update).not.toHaveBeenCalled();
      expect(prisma.member.update).not.toHaveBeenCalled();
      expect(result.skipped).toBe(1);
      expect(result.errors[0]).toContain('ล็อก');
    });
  });
});
