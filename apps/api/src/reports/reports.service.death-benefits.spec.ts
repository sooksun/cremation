import { ReportsService } from './reports.service';

describe('ReportsService.getDeathBenefitReport', () => {
  const prisma = {
    deathClaim: { findMany: jest.fn() },
  };
  const auditLog = { log: jest.fn() };

  const service = new ReportsService(prisma as never, {} as never, {} as never, auditLog as never);
  const adminActor = { id: 'u1', role: 'ADMIN' } as never;

  beforeEach(() => jest.clearAllMocks());

  const baseClaim = {
    reportedDate: new Date('2026-01-05'),
    status: 'PAID',
    collectedAmount: 0,
    collectionDeadline: new Date('2026-01-01'),
    documentDeadline: new Date('2026-01-01'),
    documentsComplete: true,
    member: { id: 'm1', memberNo: 'M001', associationMember: { firstName: 'A', lastName: 'B' } },
    school: { name: 'School A' },
    payment: null,
  };

  it('reconciles gross - fee = netToPay for a legacy (collection-based) claim', async () => {
    prisma.deathClaim.findMany.mockResolvedValue([
      {
        ...baseClaim,
        id: 'c1',
        claimNo: 'DC-001',
        isFixedBenefit: false,
        totalContribution: 10000,
        associationSupport: 1000,
        otherDeductions: 200,
        netToPay: 8800,
      },
    ]);

    const result = await service.getDeathBenefitReport({ year: 2026 }, undefined, adminActor);

    expect(result.claims[0].grossAmount - result.claims[0].feeDeduction).toBe(8800);
    expect(result.summary.grossTotal - result.summary.feeTotal).toBe(8800);
  });

  it('reconciles gross - fee = netToPay for a committee fixed-benefit claim', async () => {
    prisma.deathClaim.findMany.mockResolvedValue([
      {
        ...baseClaim,
        id: 'c2',
        claimNo: 'DC-002',
        isFixedBenefit: true,
        totalContribution: 5000,
        associationSupport: 500,
        otherDeductions: 500,
        fixedBenefitAmount: 20000,
        netToPay: 19500,
      },
    ]);

    const result = await service.getDeathBenefitReport({ year: 2026 }, undefined, adminActor);

    expect(result.claims[0].grossAmount - result.claims[0].feeDeduction).toBe(19500);
    expect(result.summary.grossTotal - result.summary.feeTotal).toBe(19500);
  });

  it('reconciles gross - fee = netToPay per claim across a mixed legacy + fixed batch', async () => {
    prisma.deathClaim.findMany.mockResolvedValue([
      {
        ...baseClaim,
        id: 'c1',
        claimNo: 'DC-001',
        isFixedBenefit: false,
        totalContribution: 10000,
        associationSupport: 1000,
        otherDeductions: 200,
        netToPay: 8800,
      },
      {
        ...baseClaim,
        id: 'c2',
        claimNo: 'DC-002',
        isFixedBenefit: true,
        totalContribution: 5000,
        associationSupport: 500,
        otherDeductions: 500,
        fixedBenefitAmount: 20000,
        netToPay: 19500,
      },
    ]);

    const result = await service.getDeathBenefitReport({ year: 2026 }, undefined, adminActor);

    expect(result.summary.grossTotal - result.summary.feeTotal).toBe(8800 + 19500);
  });

  it('does not write a REPORT_GENERATE audit log when the underlying query fails', async () => {
    prisma.deathClaim.findMany.mockRejectedValue(new Error('db unavailable'));

    await expect(
      service.getDeathBenefitReport({ year: 2026 }, undefined, adminActor),
    ).rejects.toThrow('db unavailable');

    expect(auditLog.log).not.toHaveBeenCalled();
  });

  it('writes a REPORT_GENERATE audit log after a successful fetch', async () => {
    prisma.deathClaim.findMany.mockResolvedValue([]);

    await service.getDeathBenefitReport({ year: 2026 }, undefined, adminActor);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({ action: 'REPORT_GENERATE', entityId: 'death-benefits' }),
    );
  });
});
