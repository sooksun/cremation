import { DashboardsService } from './dashboards.service';

describe('DashboardsService finance', () => {
  const d = (y: number, m: number) => new Date(y, m - 1, 15);

  const makeService = (over: Record<string, unknown> = {}) => {
    const prisma = {
      receipt: {
        groupBy: jest.fn().mockResolvedValue([]),
        aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 0 } }),
      },
      paymentVoucher: {
        groupBy: jest.fn().mockResolvedValue([]),
        aggregate: jest.fn().mockResolvedValue({ _sum: { amount: 0 } }),
      },
      contributionPeriod: { findMany: jest.fn().mockResolvedValue([]) },
      bankAccount: { findMany: jest.fn().mockResolvedValue([]) },
      memberContribution: {
        aggregate: jest.fn(),
        count: jest.fn(),
        groupBy: jest.fn().mockResolvedValue([]),
      },
      member: { findMany: jest.fn().mockResolvedValue([]) },
      ...over,
    };
    const schoolScope = { resolveSchoolId: jest.fn((_u: unknown, id?: string) => id) };
    return {
      service: new DashboardsService(prisma as never, schoolScope as never),
      prisma,
    };
  };

  const actor = { id: 'u1', role: 'ADMIN', schoolId: null } as never;

  it('carries the accumulated balance forward month by month', async () => {
    const { service, prisma } = makeService();
    prisma.receipt.groupBy.mockResolvedValue([
      { date: d(2026, 1), _sum: { amount: 1000 } },
      { date: d(2026, 3), _sum: { amount: 500 } },
    ]);
    prisma.paymentVoucher.groupBy.mockResolvedValue([
      { date: d(2026, 2), _sum: { amount: 300 } },
    ]);

    const res = await service.getFinanceDashboard(2026, undefined, actor);
    const byMonth = Object.fromEntries(res.monthly.map((m) => [m.month, m]));

    expect(byMonth[1].accumulated).toBe(1000);
    expect(byMonth[2].accumulated).toBe(700); // 1000 - 300
    expect(byMonth[3].accumulated).toBe(1200); // 700 + 500
    expect(byMonth[12].accumulated).toBe(1200); // เดือนที่ไม่มีรายการต้องคงยอดเดิม
    expect(res.summary.closingBalance).toBe(1200);
  });

  it('starts from the balance carried in from previous years', async () => {
    const { service, prisma } = makeService();
    prisma.receipt.aggregate.mockResolvedValue({ _sum: { amount: 5000 } });
    prisma.paymentVoucher.aggregate.mockResolvedValue({ _sum: { amount: 2000 } });
    prisma.receipt.groupBy.mockResolvedValue([{ date: d(2026, 1), _sum: { amount: 100 } }]);

    const res = await service.getFinanceDashboard(2026, undefined, actor);

    expect(res.openingBalance).toBe(3000);
    expect(res.monthly[0].accumulated).toBe(3100);
    expect(res.summary.closingBalance).toBe(3100);
  });

  it('reports zeros rather than failing when nothing has been recorded yet', async () => {
    const { service } = makeService();
    const res = await service.getFinanceDashboard(2026, undefined, actor);

    expect(res.summary).toEqual({
      totalInflow: 0,
      totalOutflow: 0,
      net: 0,
      closingBalance: 0,
    });
    expect(res.monthly).toHaveLength(12);
    expect(res.topOutstandingMembers).toEqual([]);
  });

  it('ranks members by what they still owe and drops those fully paid', async () => {
    const { service, prisma } = makeService();
    prisma.memberContribution.groupBy.mockResolvedValue([
      { memberId: 'm1', _count: 3, _sum: { totalAmount: 300, paidAmount: 100 } },
      { memberId: 'm2', _count: 3, _sum: { totalAmount: 300, paidAmount: 300 } },
      { memberId: 'm3', _count: 3, _sum: { totalAmount: 300, paidAmount: 0 } },
    ]);
    prisma.member.findMany.mockResolvedValue([
      { id: 'm1', memberNo: 'M001', school: { name: 'ร.ร. ก' }, group: null, associationMember: { firstName: 'ก', lastName: 'ข' } },
      { id: 'm3', memberNo: 'M003', school: { name: 'ร.ร. ค' }, group: { name: 'กลุ่ม 1' }, associationMember: { firstName: 'ค', lastName: 'ง' } },
    ]);

    const res = await service.getFinanceDashboard(2026, undefined, actor);

    expect(res.topOutstandingMembers.map((m) => m.memberId)).toEqual(['m3', 'm1']);
    expect(res.topOutstandingMembers[0].outstanding).toBe(300);
    expect(res.topOutstandingMembers[1].outstanding).toBe(200);
  });

  it('computes what each period still has outstanding', async () => {
    const { service, prisma } = makeService();
    prisma.contributionPeriod.findMany.mockResolvedValue([
      { id: 'p1', year: 2026, month: 6, welfareRate: 200, serviceFee: 0, isClosed: false },
    ]);
    prisma.memberContribution.aggregate.mockResolvedValue({
      _sum: { totalAmount: 1000, paidAmount: 400 },
      _count: 5,
    });
    prisma.memberContribution.count.mockResolvedValue(3);

    const res = await service.getFinanceDashboard(2026, undefined, actor);

    expect(res.periodStatus[0]).toMatchObject({
      month: 6,
      due: 1000,
      paid: 400,
      outstanding: 600,
      unpaidMembers: 3,
    });
  });
});
