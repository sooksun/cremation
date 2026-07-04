import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { Role } from '@prisma/client';
import { SchoolScopeService } from './school-scope.service';
import { MembersService } from '../../members/members.service';
import { DeathClaimsService } from '../../death-claims/death-claims.service';
import { GroupsService } from '../../groups/groups.service';
import { ReceiptsService } from '../../receipts/receipts.service';
import { PaymentsService } from '../../payments/payments.service';

describe('School scope on ID routes', () => {
  const schoolA = 'school-a';
  const schoolB = 'school-b';
  const memberId = 'member-1';
  const claimId = 'claim-1';

  const schoolScope = new SchoolScopeService();

  const scopedUser = {
    id: 'user-1',
    role: Role.FINANCE,
    schoolId: schoolA,
  };

  describe('MembersService.findById', () => {
    const prisma = {
      member: {
        findUnique: jest.fn(),
      },
    };

    const membersService = new MembersService(
      prisma as never,
      {} as never,
      {} as never,
      {} as never,
      schoolScope,
      { log: jest.fn() } as never,
    );

    beforeEach(() => {
      prisma.member.findUnique.mockResolvedValue({
        id: memberId,
        schoolId: schoolB,
        associationMember: null,
        school: null,
        group: null,
        beneficiaries: [],
        protectedPersons: [],
        contributions: [],
        deathClaims: [],
      });
    });

    it('allows ADMIN to read any school member', async () => {
      await expect(
        membersService.findById(memberId, { id: 'admin', role: Role.ADMIN }),
      ).resolves.toBeDefined();
    });

    it('denies school-scoped user reading another school member', async () => {
      await expect(membersService.findById(memberId, scopedUser)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('allows school-scoped user reading own school member', async () => {
      prisma.member.findUnique.mockResolvedValue({
        id: memberId,
        schoolId: schoolA,
        associationMember: null,
        school: null,
        group: null,
        beneficiaries: [],
        protectedPersons: [],
        contributions: [],
        deathClaims: [],
      });

      await expect(membersService.findById(memberId, scopedUser)).resolves.toBeDefined();
    });

    it('allows a member account to read its linked member only', async () => {
      prisma.member.findUnique.mockResolvedValue({
        id: memberId,
        schoolId: schoolA,
        associationMember: null,
        school: null,
        group: null,
        beneficiaries: [],
        protectedPersons: [],
        contributions: [],
        deathClaims: [],
      });
      const memberUser = {
        id: 'member-user',
        role: Role.MEMBER,
        schoolId: schoolA,
        memberId,
      };

      await expect(membersService.findById(memberId, memberUser)).resolves.toBeDefined();
      await expect(
        membersService.findById('another-member', memberUser),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('DeathClaimsService.findById', () => {
    const prisma = {
      deathClaim: {
        findUnique: jest.fn(),
      },
    };

    const deathClaimsService = new DeathClaimsService(
      prisma as never,
      {} as never,
      {} as never,
      schoolScope,
      {} as never,
      {} as never,
    );

    beforeEach(() => {
      prisma.deathClaim.findUnique.mockResolvedValue({
        id: claimId,
        schoolId: schoolB,
        member: { associationMember: null },
        school: { name: 'Other' },
      });
    });

    it('denies school-scoped user reading another school claim', async () => {
      await expect(deathClaimsService.findById(claimId, scopedUser)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('allows school-scoped user reading own school claim', async () => {
      prisma.deathClaim.findUnique.mockResolvedValue({
        id: claimId,
        schoolId: schoolA,
        member: { associationMember: null },
        school: { name: 'Mine' },
      });

      await expect(deathClaimsService.findById(claimId, scopedUser)).resolves.toBeDefined();
    });

    it('throws NotFound when claim does not exist', async () => {
      prisma.deathClaim.findUnique.mockResolvedValue(null);
      await expect(deathClaimsService.findById('missing', scopedUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('DeathClaimsService.getStats', () => {
    const prisma = {
      deathClaim: {
        count: jest.fn().mockResolvedValue(0),
        groupBy: jest.fn().mockResolvedValue([]),
        aggregate: jest.fn().mockResolvedValue({ _sum: {} }),
      },
      deathBenefitPayment: {
        aggregate: jest.fn().mockResolvedValue({ _sum: {} }),
      },
    };

    const deathClaimsService = new DeathClaimsService(
      prisma as never,
      {} as never,
      {} as never,
      schoolScope,
      {} as never,
      {} as never,
    );

    it('scopes stats to user school for non-ADMIN', async () => {
      await deathClaimsService.getStats(undefined, scopedUser);

      expect(prisma.deathClaim.count).toHaveBeenCalledWith(
        expect.objectContaining({ where: expect.objectContaining({ schoolId: schoolA }) }),
      );
    });
  });

  describe('GroupsService.findById', () => {
    const prisma = {
      group: {
        findUnique: jest.fn(),
      },
    };

    const groupsService = new GroupsService(prisma as never, schoolScope, { log: jest.fn() } as never);

    beforeEach(() => {
      prisma.group.findUnique.mockResolvedValue({
        id: 'group-1',
        schoolId: schoolB,
        school: null,
        leader: null,
        members: [],
      });
    });

    it('denies school-scoped user reading another school group', async () => {
      await expect(groupsService.findById('group-1', scopedUser)).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('allows school-scoped user reading own school group', async () => {
      prisma.group.findUnique.mockResolvedValue({
        id: 'group-1',
        schoolId: schoolA,
        school: null,
        leader: null,
        members: [],
      });

      await expect(groupsService.findById('group-1', scopedUser)).resolves.toBeDefined();
    });
  });

  describe('ReceiptsService.findById', () => {
    const prisma = {
      receipt: {
        findUnique: jest.fn(),
      },
    };

    const receiptsService = new ReceiptsService(
      prisma as never,
      {} as never,
      {} as never,
      schoolScope,
      {} as never,
    );

    beforeEach(() => {
      prisma.receipt.findUnique.mockResolvedValue({
        id: 'receipt-1',
        schoolId: schoolB,
        school: null,
        bankAccount: null,
        ledgerEntries: [],
        memberContribution: null,
      });
    });

    it('denies school-scoped user reading another school receipt', async () => {
      await expect(receiptsService.findById('receipt-1', scopedUser)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('PaymentsService.findById', () => {
    const prisma = {
      paymentVoucher: {
        findUnique: jest.fn(),
      },
    };

    const paymentsService = new PaymentsService(
      prisma as never,
      {} as never,
      {} as never,
      schoolScope,
      {} as never,
    );

    beforeEach(() => {
      prisma.paymentVoucher.findUnique.mockResolvedValue({
        id: 'payment-1',
        schoolId: schoolB,
        school: null,
        bankAccount: null,
        ledgerEntries: [],
        deathBenefit: null,
      });
    });

    it('denies school-scoped user reading another school payment', async () => {
      await expect(paymentsService.findById('payment-1', scopedUser)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('MembersService.importCsv', () => {
    const prisma = {
      school: {
        findUnique: jest.fn(),
      },
      memberType: {
        findUnique: jest.fn(),
      },
      group: {
        findFirst: jest.fn(),
      },
      member: {
        findFirst: jest.fn(),
        create: jest.fn(),
      },
      associationMember: {
        create: jest.fn(),
        update: jest.fn(),
      },
    };

    const membersService = new MembersService(
      prisma as never,
      {} as never,
      {} as never,
      {} as never,
      schoolScope,
      { log: jest.fn() } as never,
    );

    beforeEach(() => {
      prisma.school.findUnique.mockResolvedValue({ id: schoolB, code: 'SCH_B' });
      prisma.memberType.findUnique.mockResolvedValue({ id: 'type-1', code: 'T1' });
      prisma.member.findFirst.mockResolvedValue(null);
      prisma.associationMember.create.mockResolvedValue({ id: 'am-1' });
      prisma.member.create.mockResolvedValue({ id: 'member-1' });
    });

    it('skips rows outside the actor school', async () => {
      const result = await membersService.importCsv(
        [
          {
            memberNo: 'M00001',
            firstName: 'A',
            lastName: 'B',
            schoolCode: 'SCH_B',
            memberTypeCode: 'T1',
          },
        ],
        scopedUser,
      );

      expect(result.skipped).toBe(1);
      expect(result.errors[0]).toContain('ไม่มีสิทธิ์นำเข้า');
      expect(prisma.associationMember.create).not.toHaveBeenCalled();
    });
  });
});
