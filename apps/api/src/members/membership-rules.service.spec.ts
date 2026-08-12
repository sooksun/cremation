import {
  MembershipClass,
  MembershipEndReason,
  MemberStatus,
  ProtectedRelationship,
} from '@prisma/client';
import { MembershipRulesService } from './membership-rules.service';
import { PrismaService } from '../prisma/prisma.service';
import {
  APPLICATION_DEADLINE_DAYS,
  resolveMembershipClass,
  parseProtectedRelationship,
} from './membership.constants';

describe('membership constants', () => {
  it('maps REG/PERM and salary deduction to ORDINARY', () => {
    expect(resolveMembershipClass({ memberTypeCode: 'REG' })).toBe(MembershipClass.ORDINARY);
    expect(resolveMembershipClass({ memberTypeCode: 'PERM' })).toBe(MembershipClass.ORDINARY);
    expect(resolveMembershipClass({ memberTypeCode: 'STF', salaryDeduction: true })).toBe(
      MembershipClass.ORDINARY,
    );
  });

  it('maps STF/RET to CONTRIBUTORY by default', () => {
    expect(resolveMembershipClass({ memberTypeCode: 'STF' })).toBe(MembershipClass.CONTRIBUTORY);
    expect(resolveMembershipClass({ memberTypeCode: 'RET' })).toBe(MembershipClass.CONTRIBUTORY);
  });

  it('parses Thai relationship labels', () => {
    expect(parseProtectedRelationship('คู่สมรส')).toBe('SPOUSE');
    expect(parseProtectedRelationship('บิดา')).toBe('PARENT');
    expect(parseProtectedRelationship('บุตร')).toBe('CHILD');
    expect(parseProtectedRelationship('เพื่อน')).toBeNull();
  });
});

describe('MembershipRulesService', () => {
  let service: MembershipRulesService;
  let prisma: {
    protectedPerson: { updateMany: jest.Mock };
    member: { update: jest.Mock };
    contributionPeriod: { findUnique: jest.Mock };
    memberContribution: { findMany: jest.Mock; update: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      protectedPerson: { updateMany: jest.fn().mockResolvedValue({ count: 1 }) },
      member: { update: jest.fn().mockResolvedValue({}) },
      contributionPeriod: { findUnique: jest.fn().mockResolvedValue({ id: 'p1' }) },
      memberContribution: {
        findMany: jest.fn().mockResolvedValue([]),
        update: jest.fn().mockResolvedValue({}),
      },
    };
    service = new MembershipRulesService(prisma as unknown as PrismaService);
  });

  it('sets application deadline 30 days from join date', () => {
    const joinDate = new Date('2026-01-01');
    const fields = service.buildCreateMembershipFields({
      joinDate,
      memberTypeCode: 'REG',
    });
    const expected = new Date(joinDate);
    expected.setDate(expected.getDate() + APPLICATION_DEADLINE_DAYS);
    expect(fields.applicationDeadline?.toISOString()).toBe(expected.toISOString());
    expect(fields.membershipClass).toBe(MembershipClass.ORDINARY);
  });

  it('builds protected persons from spouse and blood relatives', () => {
    const persons = service.buildProtectedPersonsFromForm({
      maritalStatus: 'married',
      spouseName: 'นางสมศรี ใจดี',
      bloodRelatives: [
        { name: 'นายสมชาย พ่อ', relationship: 'บิดา' },
        { name: 'ด.ช.สมหวัง', relationship: 'บุตร' },
      ],
    });
    expect(persons).toHaveLength(3);
    expect(persons[0]).toMatchObject({
      fullName: 'นางสมศรี ใจดี',
      relationship: ProtectedRelationship.SPOUSE,
    });
  });

  it('deactivates protected persons on status side effects', async () => {
    await service.applyStatusSideEffects('m1', MemberStatus.DECEASED);
    expect(prisma.protectedPerson.updateMany).toHaveBeenCalledWith(
      expect.objectContaining({
        where: { memberId: 'm1', isActive: true },
      }),
    );
  });

  it('terminates contributory member after 3 arrears periods post-notice', async () => {
    prisma.memberContribution.findMany.mockResolvedValue([
      {
        id: 'c1',
        member: {
          id: 'm1',
          membershipClass: MembershipClass.CONTRIBUTORY,
          status: MemberStatus.ARREARS,
          arrearsNoticeSentAt: new Date('2026-01-01'),
          consecutiveArrearsPeriods: 2,
          associationMember: { memberType: { code: 'STF' } },
        },
      },
    ]);

    const result = await service.processArrearsAfterNotice('p1');
    expect(result.terminated).toBe(1);
    expect(prisma.memberContribution.update).toHaveBeenCalled();
    expect(prisma.member.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          membershipEndReason: MembershipEndReason.ARREARS_TERMINATED,
        }),
      }),
    );
  });

  it('skips contributions that already received arrears notice for the period', async () => {
    prisma.memberContribution.findMany.mockResolvedValue([]);

    const result = await service.processArrearsAfterNotice('p1');
    expect(result).toEqual({ noticeSent: 0, terminated: 0 });
    expect(prisma.member.update).not.toHaveBeenCalled();
  });

  describe('getStatusChangeExtras', () => {
    it('sets RETIRED reason for RET member resigning with date (art.9.1.3)', () => {
      const extras = service.getStatusChangeExtras(MemberStatus.RESIGNED, 'RET', '2026-05-01');
      expect(extras.membershipEndReason).toBe(MembershipEndReason.RETIRED);
      expect(extras.resignDate).toEqual(new Date('2026-05-01'));
    });

    it('sets RESIGNED reason for non-RET member resigning with date', () => {
      const extras = service.getStatusChangeExtras(MemberStatus.RESIGNED, 'STF', '2026-05-01');
      expect(extras.membershipEndReason).toBe(MembershipEndReason.RESIGNED);
      expect(extras.resignDate).toEqual(new Date('2026-05-01'));
    });

    it('sets DECEASED reason with deathDate', () => {
      const extras = service.getStatusChangeExtras(MemberStatus.DECEASED, 'ORD', '2026-05-01');
      expect(extras.membershipEndReason).toBe(MembershipEndReason.DECEASED);
      expect(extras.deathDate).toEqual(new Date('2026-05-01'));
    });

    it('lets an explicit TRANSFERRED reason override the inferred RESIGNED', () => {
      const extras = service.getStatusChangeExtras(
        MemberStatus.RESIGNED,
        'REG',
        '2026-05-01',
        MembershipEndReason.TRANSFERRED,
      );
      expect(extras.membershipEndReason).toBe(MembershipEndReason.TRANSFERRED);
      expect(extras.resignDate).toEqual(new Date('2026-05-01'));
    });

    it('keeps DECEASED reason even when a different reason is passed explicitly', () => {
      const extras = service.getStatusChangeExtras(
        MemberStatus.DECEASED,
        'REG',
        '2026-05-01',
        MembershipEndReason.TRANSFERRED,
      );
      expect(extras.membershipEndReason).toBe(MembershipEndReason.DECEASED);
    });

    it('clears end-of-membership fields when restoring a member to ACTIVE', () => {
      const extras = service.getStatusChangeExtras(MemberStatus.ACTIVE, 'REG');
      expect(extras).toEqual({
        resignDate: null,
        deathDate: null,
        membershipEndReason: null,
      });
    });
  });
});