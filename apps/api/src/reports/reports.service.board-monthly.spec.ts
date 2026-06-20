import { ReportsService } from './reports.service';
import { PrismaService } from '../prisma/prisma.service';

describe('ReportsService.getBoardMonthlyReport', () => {
  let service: ReportsService;
  let prisma: {
    member: { count: jest.Mock };
    receipt: { aggregate: jest.Mock };
    paymentVoucher: { aggregate: jest.Mock };
    deathClaim: { findMany: jest.Mock; count: jest.Mock };
    memberContribution: { aggregate: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      member: {
        count: jest
          .fn()
          .mockResolvedValueOnce(100)
          .mockResolvedValueOnce(90)
          .mockResolvedValueOnce(2)
          .mockResolvedValueOnce(1)
          .mockResolvedValueOnce(0)
          .mockResolvedValueOnce(5),
      },
      receipt: { aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 50000 }, _count: 10 }) },
      paymentVoucher: { aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 20000 }, _count: 3 }) },
      deathClaim: {
        findMany: jest.fn().mockResolvedValue([
          {
            id: 'c1',
            claimNo: 'DC-001',
            reportedDate: new Date('2024-06-05'),
            netToPay: 9000,
            associationSupport: 1000,
            status: 'PAID',
            member: { memberNo: 'M001', associationMember: { firstName: 'A', lastName: 'B' } },
            school: { name: 'โรงเรียน A' },
            payment: { id: 'p1' },
            approvedAt: new Date(),
            approverName: 'Admin',
            approvedBy: { fullName: 'Admin' },
          },
        ]),
        count: jest.fn().mockResolvedValueOnce(0).mockResolvedValueOnce(0),
      },
      memberContribution: {
        aggregate: jest.fn().mockResolvedValue({
          _sum: { totalAmount: 10000, paidAmount: 8000 },
          _count: 50,
        }),
      },
    };
    service = new ReportsService(
      prisma as unknown as PrismaService,
      {} as never,
    );
  });

  it('aggregates monthly board report sections', async () => {
    const result = await service.getBoardMonthlyReport(2024, 6);

    expect(result.period).toEqual({ year: 2024, month: 6, label: '6/2567' });
    expect(result.members.total).toBe(100);
    expect(result.members.active).toBe(90);
    expect(result.finance.receipts).toBe(50000);
    expect(result.finance.net).toBe(30000);
    expect(result.deathClaims.count).toBe(1);
    expect(result.deathClaims.fundReserve).toBe(1000);
    expect(result.contributions.collectionRate).toBe(0.8);
    expect(result.deathClaims.items[0].claimNo).toBe('DC-001');
  });
});
