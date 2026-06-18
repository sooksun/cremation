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
    memberContribution: { findMany: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      protectedPerson: { updateMany: jest.fn().mockResolvedValue({ count: 1 }) },
      member: { update: jest.fn().mockResolvedValue({}) },
      contributionPeriod: { findUnique: jest.fn().mockResolvedValue({ id: 'p1' }) },
      memberContribution: { findMany: jest.fn().mockResolvedValue([]) },
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
    expect(prisma.member.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          membershipEndReason: MembershipEndReason.ARREARS_TERMINATED,
        }),
      }),
    );
  });
});