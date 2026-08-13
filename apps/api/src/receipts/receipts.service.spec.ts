import { ForbiddenException, Logger } from '@nestjs/common';
import { Prisma, ReceiptType, Role } from '@prisma/client';
import { ReceiptsService } from './receipts.service';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService } from '../common/document-number.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { CashBookService } from '../cash-book/cash-book.service';

/**
 * ใบเสร็จคือจุดที่เงินเข้าระบบ ทุกใบต้องทิ้งคู่บัญชีที่ดุลและผูกกลับมาที่ใบเสร็จได้
 * ถ้าคู่บัญชีขาดข้างใดข้างหนึ่ง งบทดลองจะเพี้ยนโดยไม่มีใครเห็นจนกว่าจะปิดปี
 */
describe('ReceiptsService.create — คู่บัญชีของใบเสร็จ', () => {
  const ACCOUNTS: Record<string, { id: string; code: string }> = {
    '101': { id: 'acc-cash', code: '101' },
    '102': { id: 'acc-bank', code: '102' },
    '401': { id: 'acc-welfare', code: '401' },
    '402': { id: 'acc-service', code: '402' },
  };

  function buildDeps(overrides: { accounts?: Record<string, any> } = {}) {
    const chart = overrides.accounts ?? ACCOUNTS;

    const prisma: any = {
      receipt: {
        create: jest.fn(async ({ data }: any) => ({
          id: 'receipt-1',
          ...data,
          amount: new Prisma.Decimal(data.amount),
          school: null,
          bankAccount: null,
        })),
      },
      ledgerEntry: { createMany: jest.fn(async () => ({ count: 2 })) },
      account: { findFirst: jest.fn(async ({ where }: any) => chart[where.code] ?? null) },
      $transaction: jest.fn(async (fn: any) => fn(prisma)),
    };

    const cashBook = { createFromReceipt: jest.fn(async () => null) };
    const schoolScope = new SchoolScopeService();

    const service = new ReceiptsService(
      prisma as unknown as PrismaService,
      {
        generateNumber: jest.fn().mockResolvedValue('R202601-0001'),
      } as unknown as DocumentNumberService,
      { log: jest.fn() } as unknown as AuditLogService,
      schoolScope,
      cashBook as unknown as CashBookService,
    );

    return { service, prisma, cashBook };
  }

  const BASE_DTO = {
    schoolId: 'school-1',
    date: '2026-01-20',
    type: ReceiptType.MEMBER_CONTRIBUTION,
    description: 'เงินสงเคราะห์ ม.ค. 2569',
    amount: 105,
  };

  function entriesOf(prisma: any) {
    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(1);
    return prisma.ledgerEntry.createMany.mock.calls[0][0].data as any[];
  }

  it('ลงคู่บัญชีที่เดบิตเท่ากับเครดิต และเท่ากับยอดบนใบเสร็จ', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    const debit = entries.reduce((s, e) => s + Number(e.debit), 0);
    const credit = entries.reduce((s, e) => s + Number(e.credit), 0);

    expect(entries).toHaveLength(2);
    expect(debit).toBe(105);
    expect(credit).toBe(105);
    expect(debit).toBe(credit);
  });

  it('ทุกแถวต้องผูก receiptId กลับมาที่ใบเสร็จ ไม่งั้นยกเลิกใบเสร็จแล้วรายการบัญชีจะค้าง', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    expect(entries.every((e) => e.receiptId === 'receipt-1')).toBe(true);
  });

  it('รับผ่านธนาคาร ต้องเดบิตบัญชีเงินฝาก (102) ไม่ใช่เงินสด (101)', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    const debitRow = entries.find((e) => Number(e.debit) > 0);
    const creditRow = entries.find((e) => Number(e.credit) > 0);
    expect(debitRow.accountId).toBe('acc-bank');
    expect(creditRow.accountId).toBe('acc-welfare');
  });

  it('รับเป็นเงินสด ต้องเดบิตบัญชีเงินสด (101)', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO });

    const entries = entriesOf(prisma);
    const debitRow = entries.find((e) => Number(e.debit) > 0);
    expect(debitRow.accountId).toBe('acc-cash');
  });

  it('รับเป็นเงินสดต้องลงสมุดเงินสดด้วย', async () => {
    const { service, cashBook } = buildDeps();

    await service.create({ ...BASE_DTO });

    expect(cashBook.createFromReceipt).toHaveBeenCalledTimes(1);
  });

  it('รับผ่านธนาคารต้องไม่ลงสมุดเงินสด ไม่งั้นเงินก้อนเดียวถูกนับสองที่', async () => {
    const { service, cashBook } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    expect(cashBook.createFromReceipt).not.toHaveBeenCalled();
  });

  it('ยอดที่มีเศษสตางค์ต้องไม่คลาดเคลื่อน และยังดุลพอดี', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, amount: 105.25, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    const debit = entries.reduce((s, e) => s + Number(e.debit), 0);
    const credit = entries.reduce((s, e) => s + Number(e.credit), 0);
    expect(debit).toBe(105.25);
    expect(credit).toBe(105.25);
    expect(debit - credit).toBe(0);
  });

  /**
   * พฤติกรรมปัจจุบัน: ผังบัญชีไม่ครบ = ออกใบเสร็จได้แต่ไม่ลงบัญชี (เขียน warn ไว้)
   * ต่างจาก ContributionsService ที่ปฏิเสธไปเลย — ตรึงพฤติกรรมไว้ก่อน
   */
  it('ไม่พบบัญชีเงินสด (101) ต้องไม่ลงบัญชีครึ่งเดียว และต้องเขียน log เตือน', async () => {
    const warn = jest.spyOn(Logger.prototype, 'warn').mockImplementation(() => undefined);
    const { service, prisma } = buildDeps({ accounts: { '401': ACCOUNTS['401'] } });

    await service.create({ ...BASE_DTO });

    expect(prisma.receipt.create).toHaveBeenCalledTimes(1);
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(String(warn.mock.calls[0][0])).toContain('101');
    warn.mockRestore();
  });

  it('รับผ่านธนาคารแต่ไม่มีบัญชี 102 ต้องไม่ลงบัญชีข้างเดียว', async () => {
    const warn = jest.spyOn(Logger.prototype, 'warn').mockImplementation(() => undefined);
    const { service, prisma } = buildDeps({
      accounts: { '101': ACCOUNTS['101'], '401': ACCOUNTS['401'] },
    });

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(String(warn.mock.calls[0][0])).toContain('102');
    warn.mockRestore();
  });

  it('ผู้ใช้ของโรงเรียนอื่นออกใบเสร็จให้โรงเรียนนี้ไม่ได้ และต้องไม่มีแถวใดถูกสร้าง', async () => {
    const { service, prisma } = buildDeps();

    await expect(
      service.create({ ...BASE_DTO, schoolId: 'school-2' }, {
        id: 'user-1',
        role: Role.FINANCE,
        schoolId: 'school-1',
      }),
    ).rejects.toThrow(ForbiddenException);

    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
  });
});

/**
 * ใบเสร็จที่ยกเลิกยังต้อง "เห็น" ในหน้ารายการ (ผู้ใช้ต้องรู้ว่าเคยออกใบนี้)
 * แต่ต้อง "ไม่นับเป็นเงิน" ในสรุปยอด — เทสต์ชุดนี้ดักที่ตัวเลขจริง ไม่ใช่แค่ where
 */
describe('ReceiptsService — ใบเสร็จที่ยกเลิกกับตัวเลขเงิน', () => {
  type Row = {
    id: string;
    schoolId: string | null;
    type: ReceiptType;
    amount: number;
    date: Date;
    voidedAt: Date | null;
  };

  const ROWS: Row[] = [
    {
      id: 'r1',
      schoolId: 'school-1',
      type: ReceiptType.MEMBER_CONTRIBUTION,
      amount: 105.25,
      date: new Date('2026-01-10'),
      voidedAt: null,
    },
    {
      id: 'r2',
      schoolId: 'school-1',
      type: ReceiptType.MEMBER_CONTRIBUTION,
      amount: 200.5,
      date: new Date('2026-01-15'),
      voidedAt: null,
    },
    {
      id: 'r3',
      schoolId: 'school-1',
      type: ReceiptType.MEMBER_CONTRIBUTION,
      amount: 5000,
      date: new Date('2026-01-20'),
      voidedAt: new Date('2026-01-21'), // ยกเลิกแล้ว — ห้ามนับเป็นเงิน
    },
    {
      id: 'r4',
      schoolId: 'school-2',
      type: ReceiptType.MEMBER_CONTRIBUTION,
      amount: 9999,
      date: new Date('2026-01-12'),
      voidedAt: null, // โรงเรียนอื่น — ห้ามรั่วเข้ามา
    },
  ];

  function matches(row: Row, where: any = {}) {
    if (where.voidedAt === null && row.voidedAt !== null) return false;
    if (where.schoolId !== undefined && row.schoolId !== where.schoolId) return false;
    if (where.type !== undefined && row.type !== where.type) return false;
    if (where.date) {
      if (where.date.gte && row.date < where.date.gte) return false;
      if (where.date.lte && row.date > where.date.lte) return false;
    }
    return true;
  }

  function buildService() {
    const wheres: any[] = [];

    const select = (where: any) => {
      wheres.push(where);
      return ROWS.filter((r) => matches(r, where));
    };

    const prisma: any = {
      receipt: {
        findMany: jest.fn(async ({ where }: any = {}) => select(where)),
        aggregate: jest.fn(async ({ where }: any = {}) => {
          const rows = select(where);
          return {
            _sum: {
              amount: rows.length
                ? new Prisma.Decimal(rows.reduce((s, r) => s + r.amount, 0).toFixed(2))
                : null,
            },
            _count: rows.length,
          };
        }),
        groupBy: jest.fn(async ({ where }: any = {}) => {
          const rows = select(where);
          const byType = new Map<ReceiptType, Row[]>();
          for (const row of rows) {
            byType.set(row.type, [...(byType.get(row.type) ?? []), row]);
          }
          return Array.from(byType.entries()).map(([type, group]) => ({
            type,
            _sum: { amount: new Prisma.Decimal(group.reduce((s, r) => s + r.amount, 0).toFixed(2)) },
            _count: group.length,
          }));
        }),
      },
    };

    const service = new ReceiptsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      {} as AuditLogService,
      new SchoolScopeService(),
      {} as CashBookService,
    );

    return { service, prisma, wheres };
  }

  it('สรุปยอดต้องไม่รวมใบที่ยกเลิก — 5,000 บาทที่ยกเลิกต้องหายไปจากยอดรวม', async () => {
    const { service } = buildService();

    const summary = await service.getSummary('school-1');

    expect(summary.total.amount).toBe(305.75);
    expect(summary.total.count).toBe(2);
  });

  it('สรุปยอดรายประเภทก็ต้องไม่รวมใบที่ยกเลิกเช่นกัน', async () => {
    const { service } = buildService();

    const summary = await service.getSummary('school-1');

    const contribution = summary.byType.find(
      (item) => item.type === ReceiptType.MEMBER_CONTRIBUTION,
    );
    expect(contribution).toMatchObject({ amount: 305.75, count: 2 });
  });

  it('สรุปยอดต้องไม่รั่วยอดของโรงเรียนอื่นเข้ามา', async () => {
    const { service, wheres } = buildService();

    const summary = await service.getSummary('school-1');

    expect(summary.total.amount).toBe(305.75);
    expect(wheres.length).toBeGreaterThan(0);
    for (const where of wheres) {
      expect(where).toMatchObject({ schoolId: 'school-1', voidedAt: null });
    }
  });

  it('สรุปยอดตามช่วงวันที่ต้องตัดใบนอกช่วงออก', async () => {
    const { service } = buildService();

    const summary = await service.getSummary(
      'school-1',
      new Date('2026-01-01'),
      new Date('2026-01-12'),
    );

    expect(summary.total.amount).toBe(105.25);
    expect(summary.total.count).toBe(1);
  });

  it('หน้ารายการต้องยังแสดงใบที่ยกเลิก เพื่อให้ผู้ใช้เห็นว่าเคยออกใบนี้', async () => {
    const { service, wheres } = buildService();

    const rows = (await service.findAll('school-1')) as unknown as Row[];

    expect(rows.map((r) => r.id)).toContain('r3');
    expect(wheres.every((w) => !('voidedAt' in (w ?? {})))).toBe(true);
  });

  it('หน้ารายการต้องกรองตามโรงเรียนที่ขอเท่านั้น', async () => {
    const { service } = buildService();

    const rows = (await service.findAll('school-1')) as unknown as Row[];

    expect(rows.map((r) => r.id).sort()).toEqual(['r1', 'r2', 'r3']);
  });
});
