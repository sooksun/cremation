import { AssetsService } from './assets.service';

/**
 * ค่าเสื่อมราคาแบบเส้นตรงต้องหยุดเมื่อตัดครบฐานที่คิดค่าเสื่อม (ต้นทุน - ราคาซาก)
 * ถ้าไม่หยุด ค่าเสื่อมสะสมจะทะลุต้นทุน มูลค่าตามบัญชีติดลบ และงบการเงิน
 * จะมีค่าใช้จ่ายค่าเสื่อมของสินทรัพย์ที่ตัดครบไปแล้ว
 */
describe('AssetsService.recordDepreciation', () => {
  const ASSET = {
    id: 'asset-1',
    name: 'รถตู้สมาคม',
    originalCost: 100000,
    salvageValue: 10000,
    usefulLifeYears: 5,
    accumulatedDep: 0,
    schoolId: null,
  };

  function build(assetOverrides: Partial<typeof ASSET> = {}) {
    const asset = { ...ASSET, ...assetOverrides };
    const created: any[] = [];
    const prisma: any = {
      asset: {
        findUnique: jest.fn(async () => asset),
        update: jest.fn(async ({ data }: any) => ({ ...asset, ...data, school: null })),
      },
      ledgerEntry: {
        findFirst: jest.fn(async () => null),
        createMany: jest.fn(async ({ data }: any) => { created.push(...data); return { count: data.length }; }),
      },
      account: {
        findFirst: jest.fn(async ({ where }: any) =>
          where.code === '503' ? { id: 'acc-exp' } : { id: 'acc-accum' },
        ),
      },
    };
    const service = new AssetsService(prisma as never, {} as never, { log: jest.fn() } as never);
    return { service, prisma, created, asset };
  }

  it('ปีแรกตัดค่าเสื่อมเต็มจำนวนตามอายุการใช้งาน', async () => {
    const { service, prisma } = build();

    await service.recordDepreciation('asset-1', { year: 2026 } as never);

    expect(prisma.asset.update).toHaveBeenCalledWith(
      expect.objectContaining({ data: { accumulatedDep: 18000 } }),
    );
  });

  it('ปีสุดท้ายตัดเท่าที่เหลือ ไม่เกินฐานที่คิดค่าเสื่อม', async () => {
    // ตัดไปแล้ว 4 ปี = 72,000 เหลือ 18,000 พอดี
    const { service, prisma } = build({ accumulatedDep: 80000 });

    await service.recordDepreciation('asset-1', { year: 2026 } as never);

    // เหลือให้ตัดแค่ 10,000 ไม่ใช่ 18,000
    expect(prisma.asset.update).toHaveBeenCalledWith(
      expect.objectContaining({ data: { accumulatedDep: 90000 } }),
    );
  });

  it('สินทรัพย์ที่ตัดครบแล้วต้องไม่ตัดเพิ่มและไม่ลงบัญชี', async () => {
    const { service, prisma, created } = build({ accumulatedDep: 90000 });

    const result = await service.recordDepreciation('asset-1', { year: 2026 } as never);

    expect(prisma.asset.update).not.toHaveBeenCalled();
    expect(created).toHaveLength(0);
    expect(result.message).toContain('ครบ');
  });

  it('ยอดที่ระบุเองก็ต้องไม่ทะลุฐานที่คิดค่าเสื่อม', async () => {
    const { service, prisma, created } = build({ accumulatedDep: 85000 });

    await service.recordDepreciation('asset-1', { year: 2026, amount: 50000 } as never);

    expect(prisma.asset.update).toHaveBeenCalledWith(
      expect.objectContaining({ data: { accumulatedDep: 90000 } }),
    );
    // รายการบัญชีต้องเท่ากับยอดที่ตัดจริง ไม่ใช่ยอดที่ขอมา
    expect(created.map((e) => Number(e.debit) + Number(e.credit))).toEqual([5000, 5000]);
  });

  /**
   * เดิมถ้าไม่พบบัญชี 503/152 จะข้ามการลงบัญชีแต่ยังอัปเดตยอดสะสม แล้วตอบว่าสำเร็จ
   * ยอดบนสินทรัพย์จึงไม่ตรงกับสมุดบัญชี และตัวกันบันทึกซ้ำที่ตรวจจากรายการบัญชี
   * ก็ใช้ไม่ได้ กดซ้ำกี่ครั้งยอดก็บวกเพิ่มเรื่อย ๆ
   */
  it('ไม่มีบัญชีค่าเสื่อมในผังบัญชี ต้องปฏิเสธ ไม่ใช่อัปเดตยอดเงียบ ๆ', async () => {
    const { service, prisma } = build();
    prisma.account.findFirst = jest.fn(async () => null);

    await expect(service.recordDepreciation('asset-1', { year: 2026 } as never)).rejects.toThrow(
      /ยังไม่มีบัญชี/,
    );
    expect(prisma.asset.update).not.toHaveBeenCalled();
  });

  it('มูลค่าตามบัญชีหลังตัดครบต้องเท่ากับราคาซาก ไม่ใช่ศูนย์', async () => {
    const { service } = build({ accumulatedDep: 80000 });

    const result = await service.recordDepreciation('asset-1', { year: 2026 } as never);

    expect(result.bookValue).toBe(10000);
  });
});
