import { ReportsService } from './reports.service';

/**
 * I6: หน้าแดชบอร์ดผู้บริหารนับ "สมาชิกค้างชำระ" ด้วยเงื่อนไขคู่ (isArrears + paidAmount = 0)
 * ตั้งแต่การชำระไม่ครบยอดถูกบังคับให้คง isArrears = true (I2) ตัวเลขนี้จะต่ำกว่าความจริง
 * เพราะคนที่จ่ายมาบางส่วนแต่ยังค้างไม่ถูกนับ — ต้องนับจาก isArrears อย่างเดียว
 */
describe('ReportsService.getExecutiveDashboard — จำนวนค้างชำระต้องนับคนจ่ายไม่ครบด้วย', () => {
  function buildService() {
    const contributionCount = jest.fn().mockResolvedValue(7);
    const prisma = {
      member: {
        groupBy: jest.fn().mockResolvedValue([]),
        count: jest.fn().mockResolvedValue(0),
      },
      school: { findMany: jest.fn().mockResolvedValue([]) },
      deathClaim: {
        findMany: jest.fn().mockResolvedValue([]),
        count: jest.fn().mockResolvedValue(0),
        aggregate: jest.fn().mockResolvedValue({ _sum: { netToPay: null } }),
      },
      receipt: { aggregate: jest.fn().mockResolvedValue({ _sum: { amount: null }, _count: 0 }) },
      paymentVoucher: { aggregate: jest.fn().mockResolvedValue({ _sum: { amount: null }, _count: 0 }) },
      memberContribution: { count: contributionCount },
    };

    const service = new ReportsService(
      prisma as never,
      { assertSchoolAccess: jest.fn() } as never,
      {} as never,
      { log: jest.fn() } as never,
    );

    return { service, contributionCount };
  }

  it('นับค้างชำระจาก isArrears อย่างเดียว ไม่กรอง paidAmount = 0 ทิ้งคนที่จ่ายไม่ครบ', async () => {
    const { service, contributionCount } = buildService();

    await service.getExecutiveDashboard();

    expect(contributionCount).toHaveBeenCalledWith({ where: { isArrears: true } });
  });

  it('ยังคงจำกัดขอบเขตตามโรงเรียนเมื่อระบุ', async () => {
    const { service, contributionCount } = buildService();

    await service.getExecutiveDashboard('s1');

    expect(contributionCount).toHaveBeenCalledWith({ where: { schoolId: 's1', isArrears: true } });
  });
});
