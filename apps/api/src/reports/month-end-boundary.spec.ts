import { ReportsService } from './reports.service';

/**
 * new Date(year, month, 0) คือ "วันสุดท้ายของเดือน เวลา 00:00:00" เมื่อใช้คู่กับ lte
 * รายการทั้งหมดที่เกิดหลังเที่ยงคืนของวันสุดท้ายจึงหลุดออกจากยอดรายเดือน
 * ผลคือผลรวมรายเดือนไม่มีทางเท่ากับยอดสรุปทั้งปี
 */
describe('ReportsService — ขอบเขตปลายเดือนต้องครอบทั้งวัน', () => {
  const RECEIPT_ON_LAST_DAY_EVENING = 500;

  function buildPrisma() {
    // จำลองใบเสร็จ 1 ใบ ลงวันสุดท้ายของเดือนตอนเย็น
    const lastDayEvening = new Date(2026, 0, 31, 18, 30, 0);
    const receipts = [{ date: lastDayEvening, amount: RECEIPT_ON_LAST_DAY_EVENING }];

    const aggregate = jest.fn(async ({ where }: any) => {
      const gte = where?.date?.gte;
      const lte = where?.date?.lte;
      const sum = receipts
        .filter((r) => (!gte || r.date >= gte) && (!lte || r.date <= lte))
        .reduce((s, r) => s + r.amount, 0);
      return { _sum: { amount: sum || null }, _count: 0 };
    });

    return {
      aggregate,
      prisma: {
        receipt: {
          aggregate,
          count: jest.fn().mockResolvedValue(0),
          groupBy: jest.fn().mockResolvedValue([]),
          findMany: jest.fn().mockResolvedValue([]),
        },
        paymentVoucher: {
          aggregate: jest.fn().mockResolvedValue({ _sum: { amount: null }, _count: 0 }),
          groupBy: jest.fn().mockResolvedValue([]),
          findMany: jest.fn().mockResolvedValue([]),
          count: jest.fn().mockResolvedValue(0),
        },
        memberContribution: {
          groupBy: jest.fn().mockResolvedValue([]),
          count: jest.fn().mockResolvedValue(0),
          aggregate: jest.fn().mockResolvedValue({ _sum: { paidAmount: null, amount: null } }),
        },
        member: { count: jest.fn().mockResolvedValue(0), groupBy: jest.fn().mockResolvedValue([]) },
        deathClaim: {
          count: jest.fn().mockResolvedValue(0),
          findMany: jest.fn().mockResolvedValue([]),
          aggregate: jest.fn().mockResolvedValue({ _sum: { netToPay: null } }),
        },
        contributionPeriod: {
          findFirst: jest.fn().mockResolvedValue({ welfareRate: 100 }),
          findMany: jest.fn().mockResolvedValue([]),
        },
        school: { findMany: jest.fn().mockResolvedValue([]) },
        bankAccount: { findMany: jest.fn().mockResolvedValue([]) },
        bankTransaction: {
          findMany: jest.fn().mockResolvedValue([]),
          aggregate: jest.fn().mockResolvedValue({ _sum: { amount: null } }),
        },
        deathBenefitPayment: {
          aggregate: jest.fn().mockResolvedValue({ _sum: { amount: null } }),
          findMany: jest.fn().mockResolvedValue([]),
        },
        ledgerEntry: {
          findMany: jest.fn().mockResolvedValue([]),
          groupBy: jest.fn().mockResolvedValue([]),
          aggregate: jest.fn().mockResolvedValue({ _sum: { debit: null, credit: null } }),
        },
      },
    };
  }

  it('ยอดของวันสุดท้ายของเดือนต้องถูกนับ ไม่ใช่หายไปเพราะตัดที่เที่ยงคืน', async () => {
    const { prisma, aggregate } = buildPrisma();
    const service = new ReportsService(
      prisma as never,
      { assertSchoolAccess: jest.fn(), resolveSchoolId: jest.fn() } as never,
      {} as never,
      { log: jest.fn() } as never,
    );

    await service.getFinanceDashboard(2026);

    // หาการเรียก aggregate ของเดือนมกราคม แล้วตรวจว่าขอบเขตปลายครอบถึงสิ้นวัน
    const januaryCall = aggregate.mock.calls
      .map((c) => c[0])
      .find((arg: any) => arg?.where?.date?.gte?.getMonth?.() === 0);

    expect(januaryCall).toBeDefined();
    const lte = januaryCall.where.date.lte as Date;
    expect(lte.getDate()).toBe(31);
    expect(lte.getHours()).toBe(23);
    expect(lte.getMinutes()).toBe(59);
  });
});
