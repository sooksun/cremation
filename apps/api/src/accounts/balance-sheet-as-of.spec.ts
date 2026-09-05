import { AccountsService } from './accounts.service';

/**
 * งบดุลรับพารามิเตอร์ "ณ วันที่" มาโดยตลอด แต่ getTrialBalance กรองวันที่ต่อเมื่อมี
 * ครบทั้งสองขอบเขต ตัวกรองจึงถูกทิ้งเงียบ ๆ ทุกครั้ง ผลคือ:
 *   - งบดุลย้อนหลังแสดงยอด ณ ปัจจุบันเสมอ
 *   - งบแสดงการเปลี่ยนแปลงส่วนทุนได้ส่วนทุนต้นงวด = ปลายงวด เสมอ
 */
describe('AccountsService.getTrialBalance — ตัวกรองวันที่', () => {
  function buildService() {
    const findMany = jest.fn().mockResolvedValue([]);
    const prisma = { account: { findMany } } as never;
    const service = new AccountsService(prisma, { log: jest.fn() } as never);
    return { service, findMany };
  }

  it('กรองด้วยขอบเขตปลายอย่างเดียวได้ (กรณีที่งบดุลเรียกใช้)', async () => {
    const { service, findMany } = buildService();
    const asOf = new Date('2026-06-30T23:59:59Z');

    await service.getTrialBalance(undefined, asOf);

    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        include: { entries: { where: { date: { lte: asOf } } } },
      }),
    );
  });

  it('กรองด้วยขอบเขตต้นอย่างเดียวได้', async () => {
    const { service, findMany } = buildService();
    const from = new Date('2026-01-01T00:00:00Z');

    await service.getTrialBalance(from, undefined);

    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        include: { entries: { where: { date: { gte: from } } } },
      }),
    );
  });

  it('ไม่ส่งขอบเขตเลย = ไม่กรอง (ยอดสะสมทั้งหมด)', async () => {
    const { service, findMany } = buildService();

    await service.getTrialBalance();

    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({ include: { entries: { where: {} } } }),
    );
  });

  it('งบดุลส่ง asOfDate ลงไปเป็นขอบเขตปลายจริง', async () => {
    const { service, findMany } = buildService();
    const asOf = new Date('2026-03-31T23:59:59Z');
    (service as unknown as { prisma: { asset: unknown } }).prisma = {
      account: { findMany },
      asset: { findMany: jest.fn().mockResolvedValue([]) },
    } as never;

    await service.getBalanceSheet(asOf);

    expect(findMany).toHaveBeenCalledWith(
      expect.objectContaining({
        include: { entries: { where: { date: { lte: asOf } } } },
      }),
    );
  });
});
