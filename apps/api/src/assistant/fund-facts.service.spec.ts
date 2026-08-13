import { DeathClaimType } from '@prisma/client';
import { FundFactsService } from './fund-facts.service';
import { DeathBenefitCalculatorService } from '../death-claims/death-benefit-calculator.service';

function calculation(overrides: Partial<Record<string, unknown>> = {}) {
  return {
    payingMemberCount: 600,
    collectionRate: 100,
    grossCollected: 60000,
    fundReserve: 6000,
    netToPay: 54000,
    isFixedAmount: false,
    ...overrides,
  };
}

describe('FundFactsService', () => {
  it('รวมตัวเลขทั้งกรณีสมาชิกตายและญาติตายไว้ในชุดเดียว', async () => {
    const calculate = jest.fn().mockImplementation(({ claimType }) =>
      Promise.resolve(
        claimType === DeathClaimType.MEMBER_DEATH
          ? calculation()
          : calculation({ collectionRate: 50, grossCollected: 30000, fundReserve: 3000, netToPay: 27000 }),
      ),
    );
    const service = new FundFactsService({ calculate } as unknown as DeathBenefitCalculatorService);

    const facts = await service.snapshot();

    expect(facts).toEqual({
      payingMemberCount: 600,
      isFixedAmount: false,
      memberDeath: { rate: 100, gross: 60000, fundReserve: 6000, netToPay: 54000 },
      protectedDeath: { rate: 50, gross: 30000, fundReserve: 3000, netToPay: 27000 },
    });
    expect(calculate).toHaveBeenCalledTimes(2);
  });

  it('คืน null เมื่อดึงข้อมูลไม่ได้ แทนที่จะโยน error ให้แชตพัง', async () => {
    const calculate = jest.fn().mockRejectedValue(new Error('db down'));
    const service = new FundFactsService({ calculate } as unknown as DeathBenefitCalculatorService);

    await expect(service.snapshot()).resolves.toBeNull();
  });
});
