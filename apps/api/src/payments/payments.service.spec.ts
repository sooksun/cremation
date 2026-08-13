import { ForbiddenException, Logger } from '@nestjs/common';
import { PaymentType, Prisma, Role } from '@prisma/client';
import { PaymentsService } from './payments.service';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService } from '../common/document-number.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { CashBookService } from '../cash-book/cash-book.service';

/**
 * ใบสำคัญจ่ายคือจุดที่เงินออกจากระบบ (เงินสงเคราะห์ศพเป็นก้อนใหญ่ที่สุด)
 * ทิศทางคู่บัญชีต้องกลับด้านกับใบเสร็จ: เดบิตค่าใช้จ่าย เครดิตเงินสด/เงินฝาก
 * ถ้ากลับด้านผิด เงินที่จ่ายออกจะไปเพิ่มยอดเงินคงเหลือแทนที่จะลด
 */
describe('PaymentsService.create — คู่บัญชีของใบสำคัญจ่าย', () => {
  const ACCOUNTS: Record<string, { id: string; code: string }> = {
    '101': { id: 'acc-cash', code: '101' },
    '102': { id: 'acc-bank', code: '102' },
    '501': { id: 'acc-death-expense', code: '501' },
  };

  function buildDeps(overrides: { accounts?: Record<string, any> } = {}) {
    const chart = overrides.accounts ?? ACCOUNTS;

    const prisma: any = {
      paymentVoucher: {
        create: jest.fn(async ({ data }: any) => ({
          id: 'payment-1',
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

    const cashBook = { createFromPayment: jest.fn(async () => null) };

    const service = new PaymentsService(
      prisma as unknown as PrismaService,
      {
        generateNumber: jest.fn().mockResolvedValue('PV-2026-0001'),
      } as unknown as DocumentNumberService,
      { log: jest.fn() } as unknown as AuditLogService,
      new SchoolScopeService(),
      cashBook as unknown as CashBookService,
    );

    return { service, prisma, cashBook };
  }

  const BASE_DTO = {
    schoolId: 'school-1',
    date: '2026-02-05',
    type: PaymentType.DEATH_BENEFIT,
    description: 'จ่ายเงินสงเคราะห์ศพ',
    amount: 54000,
  };

  function entriesOf(prisma: any) {
    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(1);
    return prisma.ledgerEntry.createMany.mock.calls[0][0].data as any[];
  }

  it('ลงคู่บัญชีที่เดบิตเท่ากับเครดิต และเท่ากับยอดบนใบสำคัญจ่าย', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    const debit = entries.reduce((s, e) => s + Number(e.debit), 0);
    const credit = entries.reduce((s, e) => s + Number(e.credit), 0);

    expect(entries).toHaveLength(2);
    expect(debit).toBe(54000);
    expect(credit).toBe(54000);
    expect(debit).toBe(credit);
  });

  it('ทุกแถวต้องผูก paymentId กลับมาที่ใบสำคัญจ่าย', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    expect(entries.every((e) => e.paymentId === 'payment-1')).toBe(true);
  });

  it('จ่ายผ่านธนาคาร ต้องเดบิตค่าใช้จ่าย (501) และเครดิตเงินฝาก (102)', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    const entries = entriesOf(prisma);
    const debitRow = entries.find((e) => Number(e.debit) > 0);
    const creditRow = entries.find((e) => Number(e.credit) > 0);
    expect(debitRow.accountId).toBe('acc-death-expense');
    expect(creditRow.accountId).toBe('acc-bank');
  });

  it('จ่ายเป็นเงินสด ต้องเครดิตบัญชีเงินสด (101) ไม่ใช่เงินฝาก', async () => {
    const { service, prisma } = buildDeps();

    await service.create({ ...BASE_DTO });

    const entries = entriesOf(prisma);
    const creditRow = entries.find((e) => Number(e.credit) > 0);
    expect(creditRow.accountId).toBe('acc-cash');
  });

  it('จ่ายเป็นเงินสดต้องลงสมุดเงินสดด้วย', async () => {
    const { service, cashBook } = buildDeps();

    await service.create({ ...BASE_DTO });

    expect(cashBook.createFromPayment).toHaveBeenCalledTimes(1);
  });

  it('จ่ายผ่านธนาคารต้องไม่ลงสมุดเงินสด ไม่งั้นเงินก้อนเดียวถูกหักสองที่', async () => {
    const { service, cashBook } = buildDeps();

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    expect(cashBook.createFromPayment).not.toHaveBeenCalled();
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

  it('ไม่พบบัญชีค่าใช้จ่าย (501) ต้องไม่ลงบัญชีข้างเดียว และต้องเขียน log เตือน', async () => {
    const warn = jest.spyOn(Logger.prototype, 'warn').mockImplementation(() => undefined);
    const { service, prisma } = buildDeps({ accounts: { '101': ACCOUNTS['101'] } });

    await service.create({ ...BASE_DTO });

    expect(prisma.paymentVoucher.create).toHaveBeenCalledTimes(1);
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(String(warn.mock.calls[0][0])).toContain('501');
    warn.mockRestore();
  });

  it('จ่ายผ่านธนาคารแต่ไม่มีบัญชี 102 ต้องไม่ลงบัญชีข้างเดียว', async () => {
    const warn = jest.spyOn(Logger.prototype, 'warn').mockImplementation(() => undefined);
    const { service, prisma } = buildDeps({
      accounts: { '101': ACCOUNTS['101'], '501': ACCOUNTS['501'] },
    });

    await service.create({ ...BASE_DTO, bankAccountId: 'bank-1' });

    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(String(warn.mock.calls[0][0])).toContain('102');
    warn.mockRestore();
  });

  it('ผู้ใช้ของโรงเรียนอื่นออกใบสำคัญจ่ายให้โรงเรียนนี้ไม่ได้ และต้องไม่มีแถวใดถูกสร้าง', async () => {
    const { service, prisma } = buildDeps();

    await expect(
      service.create({ ...BASE_DTO, schoolId: 'school-2' }, {
        id: 'user-1',
        role: Role.FINANCE,
        schoolId: 'school-1',
      }),
    ).rejects.toThrow(ForbiddenException);

    expect(prisma.paymentVoucher.create).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
  });
});

/**
 * สรุปยอดจ่ายเป็นตัวเลขที่ขึ้นรายงานคณะกรรมการ ต้องไม่รั่วยอดของโรงเรียนอื่นเข้ามา
 */
describe('PaymentsService — สรุปยอดจ่ายและการจำกัดตามโรงเรียน', () => {
  type Row = {
    id: string;
    schoolId: string | null;
    type: PaymentType;
    amount: number;
    date: Date;
  };

  const ROWS: Row[] = [
    {
      id: 'p1',
      schoolId: 'school-1',
      type: PaymentType.DEATH_BENEFIT,
      amount: 54000,
      date: new Date('2026-02-05'),
    },
    {
      id: 'p2',
      schoolId: 'school-1',
      type: PaymentType.OPERATING_EXPENSE,
      amount: 105.25,
      date: new Date('2026-02-10'),
    },
    {
      id: 'p3',
      schoolId: 'school-1',
      type: PaymentType.OPERATING_EXPENSE,
      amount: 200.5,
      date: new Date('2026-02-25'),
    },
    {
      id: 'p4',
      schoolId: 'school-2',
      type: PaymentType.DEATH_BENEFIT,
      amount: 90000,
      date: new Date('2026-02-06'),
    },
  ];

  function matches(row: Row, where: any = {}) {
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
      paymentVoucher: {
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
          const byType = new Map<PaymentType, Row[]>();
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

    const service = new PaymentsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      {} as AuditLogService,
      new SchoolScopeService(),
      {} as CashBookService,
    );

    return { service, wheres };
  }

  it('สรุปยอดจ่ายต้องนับเฉพาะโรงเรียนที่ขอ — 90,000 ของอีกโรงเรียนต้องไม่เข้ามา', async () => {
    const { service, wheres } = buildService();

    const summary = await service.getSummary('school-1');

    expect(summary.total.amount).toBe(54305.75);
    expect(summary.total.count).toBe(3);
    for (const where of wheres) {
      expect(where).toMatchObject({ schoolId: 'school-1' });
    }
  });

  it('ยอดค่าใช้จ่ายดำเนินงานที่มีเศษสตางค์ต้องรวมได้ตรง', async () => {
    const { service } = buildService();

    const summary = await service.getSummary('school-1');

    const operating = summary.byType.find((item) => item.type === PaymentType.OPERATING_EXPENSE);
    expect(operating).toMatchObject({ amount: 305.75, count: 2 });
  });

  it('สรุปยอดตามช่วงวันที่ต้องตัดใบนอกช่วงออก', async () => {
    const { service } = buildService();

    const summary = await service.getSummary(
      'school-1',
      new Date('2026-02-01'),
      new Date('2026-02-11'),
    );

    expect(summary.total.amount).toBe(54105.25);
    expect(summary.total.count).toBe(2);
  });

  it('หน้ารายการต้องกรองตามโรงเรียนที่ขอเท่านั้น', async () => {
    const { service } = buildService();

    const rows = (await service.findAll('school-1')) as unknown as Row[];

    expect(rows.map((r) => r.id).sort()).toEqual(['p1', 'p2', 'p3']);
  });

  it('กรองตามประเภทแล้วยังต้องอยู่ในโรงเรียนเดิม', async () => {
    const { service } = buildService();

    const rows = (await service.findAll(
      'school-1',
      PaymentType.DEATH_BENEFIT,
    )) as unknown as Row[];

    expect(rows.map((r) => r.id)).toEqual(['p1']);
  });
});
