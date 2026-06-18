import { ForbiddenException, NotFoundException } from '@nestjs/common';
import { Role } from '@prisma/client';
import { SchoolScopeService } from './school-scope.service';
import { MembersService } from '../../members/members.service';
import { DeathClaimsService } from '../../death-claims/death-claims.service';

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
});