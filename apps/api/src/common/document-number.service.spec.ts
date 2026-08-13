import { DocumentNumberService, DocumentType } from './document-number.service';
import { PrismaService } from '../prisma/prisma.service';

/**
 * ตัวสร้างเลขที่ใบเสร็จต้องนับใบเสร็จที่ถูกยกเลิกด้วยเสมอ
 * ถ้ากรอง voidedAt: null ออกไป เลขที่ของใบที่ยกเลิกจะว่างกลับมา
 * แล้วถูกออกซ้ำให้เงินคนละก้อน — ซึ่งคือบั๊กที่การยกเลิกแบบลบแถวเคยทำไว้
 */
describe('DocumentNumberService — เลขที่ใบเสร็จ', () => {
  function buildPrisma(rows: Array<{ receiptNo: string; voidedAt: Date | null }>): any {
    return {
      receipt: {
        findFirst: jest.fn(async ({ where, orderBy }: any) => {
          let matched = rows.filter((r) => r.receiptNo.startsWith(where.receiptNo.startsWith));
          // ถ้า implementation เผลอกรองใบที่ยกเลิกทิ้ง mock จะสะท้อนผลนั้นออกมา
          if (where.voidedAt !== undefined) {
            matched = matched.filter((r) =>
              where.voidedAt === null ? r.voidedAt === null : r.voidedAt !== null,
            );
          }
          const sorted = [...matched].sort((a, b) =>
            orderBy?.receiptNo === 'desc'
              ? b.receiptNo.localeCompare(a.receiptNo)
              : a.receiptNo.localeCompare(b.receiptNo),
          );
          return sorted[0] ?? null;
        }),
      },
      $transaction: jest.fn(async (fn: any) => fn(buildPrisma(rows))),
    } as any;
  }

  function buildService(rows: Array<{ receiptNo: string; voidedAt: Date | null }>) {
    const prisma = buildPrisma(rows);
    return new DocumentNumberService(prisma as unknown as PrismaService);
  }

  it('ยังไม่มีใบเสร็จของเดือนนี้ ให้เริ่มที่ 0001', async () => {
    jest.useFakeTimers().setSystemTime(new Date(2026, 0, 15));
    try {
      const service = buildService([]);
      await expect(service.generateNumber(DocumentType.RECEIPT)).resolves.toBe('R202601-M0001');
    } finally {
      jest.useRealTimers();
    }
  });

  it('เลขที่ของใบเสร็จที่ถูกยกเลิกต้องไม่ถูกนำกลับมาออกซ้ำ', async () => {
    jest.useFakeTimers().setSystemTime(new Date(2026, 0, 15));
    try {
      const service = buildService([
        { receiptNo: 'R202601-M0001', voidedAt: null },
        { receiptNo: 'R202601-M0002', voidedAt: null },
        { receiptNo: 'R202601-M0003', voidedAt: new Date() },
      ]);

      await expect(service.generateNumber(DocumentType.RECEIPT)).resolves.toBe('R202601-M0004');
    } finally {
      jest.useRealTimers();
    }
  });

  it('isDuplicate ต้องถือว่าเลขที่ของใบที่ยกเลิกแล้วยังถูกใช้ไปแล้ว', async () => {
    const prisma = {
      receipt: {
        findFirst: jest.fn(async ({ where }: any) => {
          if (where.voidedAt !== undefined) return null; // implementation ที่กรองใบยกเลิกออกจะตกที่นี่
          return where.receiptNo === 'R202601-M0003' ? { id: 'r3' } : null;
        }),
      },
    } as any;
    const service = new DocumentNumberService(prisma as unknown as PrismaService);

    await expect(service.isDuplicate(DocumentType.RECEIPT, 'R202601-M0003')).resolves.toBe(true);
  });
});
