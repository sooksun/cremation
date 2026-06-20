import { DeathClaimType, MemberStatus } from '@prisma/client';
import { DeathBenefitCalculatorService } from './death-benefit-calculator.service';
import { PrismaService } from '../prisma/prisma.service';

describe('DeathBenefitCalculatorService', () => {
  let service: DeathBenefitCalculatorService;
  let prisma: {
    member: { count: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      member: { count: jest.fn().mockResolvedValue(100) },
    };
    service = new DeathBenefitCalculatorService(prisma as unknown as PrismaService);
  });

  it('calculates member death per regulation: 100 baht × 90% payout, 10% fund', async () => {
    const result = await service.calculate({
      claimType: DeathClaimType.MEMBER_DEATH,
      otherDeductions: 0,
    });

    expect(result).toMatchObject({
      claimType: DeathClaimType.MEMBER_DEATH,
      payingMemberCount: 100,
      collectionRate: 100,
      grossCollected: 10000,
      payoutRatio: 0.9,
      fundReserve: 1000,
      otherDeductions: 0,
      netToPay: 9000,
    });
  });

  it('calculates protected death at 50 baht per member', async () => {
    prisma.member.count.mockResolvedValue(80);

    const result = await service.calculate({
      claimType: DeathClaimType.PROTECTED_DEATH,
    });

    expect(result.collectionRate).toBe(50);
    expect(result.grossCollected).toBe(4000);
    expect(result.fundReserve).toBe(400);
    expect(result.netToPay).toBe(3600);
  });

  it('excludes deceased member from paying count', async () => {
    prisma.member.count.mockResolvedValue(99);

    await service.calculate({
      claimType: DeathClaimType.MEMBER_DEATH,
      excludeMemberId: 'deceased-id',
    });

    expect(prisma.member.count).toHaveBeenCalledWith({
      where: {
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
        id: { not: 'deceased-id' },
      },
    });
  });

  it('counts ARREARS members as paying members', async () => {
    await service.calculate({ claimType: DeathClaimType.MEMBER_DEATH });

    expect(prisma.member.count).toHaveBeenCalledWith({
      where: {
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
      },
    });
  });

  it('subtracts other deductions from net payout', async () => {
    const result = await service.calculate({
      claimType: DeathClaimType.MEMBER_DEATH,
      otherDeductions: 500,
    });

    expect(result.netToPay).toBe(8500);
  });

  it('exposes legacy field aliases', async () => {
    const result = await service.calculate({ claimType: DeathClaimType.MEMBER_DEATH });

    expect(result.activeMemberCount).toBe(result.payingMemberCount);
    expect(result.welfareRate).toBe(result.collectionRate);
    expect(result.totalContribution).toBe(result.grossCollected);
    expect(result.associationSupport).toBe(result.fundReserve);
  });
});