import { BadRequestException, NotFoundException } from '@nestjs/common';
import { ContributionsService } from './contributions.service';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { DocumentNumberService } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AppSettingsService } from '../common/services/app-settings.service';

describe('ContributionsService', () => {
  let service: ContributionsService;
  let prisma: {
    memberContribution: { findUnique: jest.Mock; update: jest.Mock };
    contributionPeriod: { findUnique: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      memberContribution: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
      contributionPeriod: {
        findUnique: jest.fn(),
      },
    };

    const schoolScope = {
      assertSchoolAccess: jest.fn(),
      assertGroupLeaderCanPay: jest.fn(),
    } as unknown as SchoolScopeService;

    service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
      {} as DocumentNumberService,
      {} as BankAccountsService,
      schoolScope,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(false),
        effectiveServiceFee: jest.fn((_fee: number, enabled: boolean) => (enabled ? _fee : 0)),
      } as unknown as AppSettingsService,
    );
  });

  describe('recordPayment', () => {
    it('throws NotFoundException when contribution does not exist', async () => {
      prisma.memberContribution.findUnique.mockResolvedValue(null);

      await expect(
        service.recordPayment('missing', {
          amount: 100,
          paidDate: '2026-01-15',
        }),
      ).rejects.toThrow(NotFoundException);
    });

    it('throws BadRequestException when period is closed', async () => {
      prisma.memberContribution.findUnique.mockResolvedValue({
        id: 'c1',
        schoolId: 'school-1',
        period: { isClosed: true, year: 2026, month: 1 },
        member: { groupId: 'group-1' },
      });

      await expect(
        service.recordPayment('c1', {
          amount: 100,
          paidDate: '2026-01-15',
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('updatePeriod', () => {
    it('throws BadRequestException when trying to update a closed period', async () => {
      prisma.contributionPeriod.findUnique.mockResolvedValue({
        id: 'p1',
        isClosed: true,
        year: 2026,
        month: 1,
      });

      await expect(
        service.updatePeriod('p1', { welfareRate: 25 }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});