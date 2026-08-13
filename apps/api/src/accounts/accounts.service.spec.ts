import { AccountType } from '@prisma/client';
import { AccountsService } from './accounts.service';
import { PrismaService } from '../prisma/prisma.service';
import { AuditLogService } from '../common/services/audit-log.service';

type FakeAccount = {
  id: string;
  code: string;
  name: string;
  type: AccountType;
  isActive?: boolean;
};

type FakeEntry = {
  id?: string;
  accountId: string;
  date: Date;
  description?: string;
  debit: number;
  credit: number;
  receiptId?: string | null;
  paymentId?: string | null;
  // มีไว้ให้ mock กรองตามโรงเรียนได้ ถ้าวันหนึ่ง service ขอมา (ดูเทสต์ it.failing ท้ายไฟล์)
  schoolId?: string | null;
  receiptNo?: string;
  voucherNo?: string;
};

type FakeAsset = {
  code?: string | null;
  name: string;
  originalCost: number;
  accumulatedDep?: number | null;
  status?: string;
  schoolId?: string | null;
};

/**
 * mock ที่คิดเลขจริง: กรอง entries ตาม where ที่ service ส่งมาแล้วค่อยคืน
 * ถ้า service ลืมกรองอะไรไป ตัวเลขที่ออกมาจะเพี้ยนให้เห็นทันที
 */
function buildPrisma(accounts: FakeAccount[], entries: FakeEntry[], assets: FakeAsset[] = []) {
  const rows = entries.map((e, i) => ({
    id: e.id ?? `entry-${i + 1}`,
    description: e.description ?? 'รายการ',
    receiptId: e.receiptId ?? null,
    paymentId: e.paymentId ?? null,
    ...e,
  }));

  const inRange = (row: any, where: any = {}) => {
    if (where.accountId !== undefined && row.accountId !== where.accountId) return false;
    if (where.date?.gte && row.date < where.date.gte) return false;
    if (where.date?.lte && row.date > where.date.lte) return false;
    // ยังไม่มี read path ไหนส่งเงื่อนไขโรงเรียนมา — ถ้าส่งมาเมื่อไร mock พร้อมกรองให้
    if (where.schoolId !== undefined && row.schoolId !== where.schoolId) return false;
    if (where.receipt?.schoolId !== undefined && row.schoolId !== where.receipt.schoolId) {
      return false;
    }
    return true;
  };

  const prisma: any = {
    account: {
      findMany: jest.fn(async ({ include }: any = {}) => {
        const entryWhere = include?.entries?.where ?? {};
        return accounts
          .filter((a) => a.isActive !== false)
          .map((a) => ({
            ...a,
            entries: rows.filter((r) => r.accountId === a.id && inRange(r, entryWhere)),
          }))
          .sort((a, b) => a.code.localeCompare(b.code));
      }),
      findUnique: jest.fn(async ({ where }: any) =>
        accounts.find((a) => a.id === where.id || a.code === where.code) ?? null,
      ),
      findFirst: jest.fn(async ({ where }: any) =>
        accounts.find((a) => a.code === where.code) ?? null,
      ),
    },
    ledgerEntry: {
      findMany: jest.fn(async ({ where }: any = {}) => {
        const accountOf = (id: string) => accounts.find((a) => a.id === id);
        return rows
          .filter((r) => inRange(r, where))
          .sort((a, b) => a.date.getTime() - b.date.getTime())
          .map((r) => ({
            ...r,
            account: accountOf(r.accountId),
            receipt: r.receiptId
              ? { id: r.receiptId, receiptNo: r.receiptNo, school: { name: 'โรงเรียน ก' } }
              : null,
            payment: r.paymentId
              ? { id: r.paymentId, voucherNo: r.voucherNo, school: { name: 'โรงเรียน ก' } }
              : null,
          }));
      }),
      createMany: jest.fn(async ({ data }: any) => {
        // รายการปิดบัญชีต้องกลับเข้ามาในงบทดลองรอบถัดไป ไม่งั้นทดสอบการปิดซ้ำไม่ได้จริง
        data.forEach((d: any, i: number) =>
          rows.push({ id: `closing-${rows.length + i}`, receiptId: null, paymentId: null, ...d }),
        );
        return { count: data.length };
      }),
    },
    asset: {
      findMany: jest.fn(async ({ where }: any = {}) =>
        assets
          .filter((a) => (a.status ?? 'ACTIVE') === (where.status ?? 'ACTIVE'))
          .filter((a) => where.schoolId === undefined || a.schoolId === where.schoolId),
      ),
    },
  };

  return prisma;
}

function buildService(prisma: any) {
  return new AccountsService(
    prisma as unknown as PrismaService,
    { log: jest.fn() } as unknown as AuditLogService,
  );
}

/**
 * งบทดลองคือด่านสุดท้ายที่จะจับได้ว่าคู่บัญชีขาดข้างไป
 * ถ้ามันบวกเดบิตกับเครดิตให้เท่ากันเองโดยอัตโนมัติ ความผิดพลาดจะมองไม่เห็นตลอดกาล
 */
describe('AccountsService.getTrialBalance', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-liab', code: '201', name: 'เจ้าหนี้', type: AccountType.LIABILITY },
    { id: 'a-income', code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
    { id: 'a-expense', code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์', type: AccountType.EXPENSE },
  ];

  // ชุดข้อมูลที่ดุลพอดี: รับเงิน 105.25 + 200.50 แล้วจ่ายออก 50.25
  const ENTRIES: FakeEntry[] = [
    { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 105.25, credit: 0 },
    { accountId: 'a-income', date: new Date('2026-01-10'), debit: 0, credit: 105.25 },
    { accountId: 'a-cash', date: new Date('2026-01-15'), debit: 200.5, credit: 0 },
    { accountId: 'a-income', date: new Date('2026-01-15'), debit: 0, credit: 200.5 },
    { accountId: 'a-expense', date: new Date('2026-02-05'), debit: 50.25, credit: 0 },
    { accountId: 'a-cash', date: new Date('2026-02-05'), debit: 0, credit: 50.25 },
  ];

  it('รวมเดบิตเท่ากับรวมเครดิต และรายงานว่าดุล', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const tb = await service.getTrialBalance();

    expect(tb.totals.debit).toBe(356);
    expect(tb.totals.credit).toBe(356);
    expect(tb.totals.difference).toBe(0);
    expect(tb.totals.isBalanced).toBe(true);
  });

  it('ยอดคงเหลือของสินทรัพย์/ค่าใช้จ่าย = เดบิต − เครดิต', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const tb = await service.getTrialBalance();
    const cash = tb.accounts.find((a) => a.code === '101');
    const expense = tb.accounts.find((a) => a.code === '501');

    expect(cash).toMatchObject({ debit: 305.75, credit: 50.25, balance: 255.5 });
    expect(expense).toMatchObject({ debit: 50.25, credit: 0, balance: 50.25 });
  });

  it('ยอดคงเหลือของรายได้/หนี้สิน/ทุน = เครดิต − เดบิต (ไม่ใช่ติดลบ)', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const tb = await service.getTrialBalance();
    const income = tb.accounts.find((a) => a.code === '401');

    expect(income).toMatchObject({ debit: 0, credit: 305.75, balance: 305.75 });
  });

  it('เศษสตางค์ต้องไม่ปัดหาย — 105.25 + 200.50 = 305.75 พอดี', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const tb = await service.getTrialBalance();
    const cash = tb.accounts.find((a) => a.code === '101');

    expect(cash!.debit).toBe(305.75);
    expect(cash!.balance).toBe(255.5);
  });

  /**
   * ข้อสำคัญที่สุดของไฟล์นี้: ถ้าคู่บัญชีขาดข้างไป งบทดลองต้อง "ฟ้อง"
   * ห้ามกลบให้เท่ากันเอง และต้องบอกส่วนต่างเป็นตัวเลขให้ตามหาได้
   */
  it('คู่บัญชีขาดข้างไป ต้องเห็นว่าไม่ดุลพร้อมส่วนต่าง ไม่ใช่ถูกกลบให้เท่ากัน', async () => {
    const broken: FakeEntry[] = [
      { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 105.25, credit: 0 },
      // ขาดขาเครดิตของรายการนี้ไป
      { accountId: 'a-cash', date: new Date('2026-01-15'), debit: 200.5, credit: 0 },
      { accountId: 'a-income', date: new Date('2026-01-15'), debit: 0, credit: 200.5 },
    ];
    const service = buildService(buildPrisma(ACCOUNTS, broken));

    const tb = await service.getTrialBalance();

    expect(tb.totals.debit).toBe(305.75);
    expect(tb.totals.credit).toBe(200.5);
    expect(tb.totals.isBalanced).toBe(false);
    expect(tb.totals.difference).toBe(105.25);
  });

  it('ระบุช่วงวันที่แล้ว ต้องตัดรายการนอกช่วงออกจากทั้งยอดบัญชีและยอดรวม', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const tb = await service.getTrialBalance(new Date('2026-01-01'), new Date('2026-01-31'));

    expect(tb.totals.debit).toBe(305.75);
    expect(tb.totals.credit).toBe(305.75);
    expect(tb.accounts.find((a) => a.code === '501')!.balance).toBe(0);
  });

  it('บัญชีที่ปิดใช้งานแล้วต้องไม่โผล่ในงบทดลอง', async () => {
    const withInactive = [
      ...ACCOUNTS,
      { id: 'a-old', code: '109', name: 'บัญชีเก่า', type: AccountType.ASSET, isActive: false },
    ];
    const service = buildService(buildPrisma(withInactive, ENTRIES));

    const tb = await service.getTrialBalance();

    expect(tb.accounts.map((a) => a.code)).not.toContain('109');
  });
});

/**
 * สมุดรายวันคือหน้าที่ผู้ตรวจสอบบัญชีเปิดดูก่อนอย่างอื่น
 * แต่ละรายการต้องจับกลุ่มตามเอกสารต้นทาง และแต่ละกลุ่มต้องดุลในตัวเอง
 */
describe('AccountsService.getJournal', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-income', code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
    { id: 'a-expense', code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์', type: AccountType.EXPENSE },
  ];

  const ENTRIES: FakeEntry[] = [
    {
      accountId: 'a-cash',
      date: new Date('2026-01-10'),
      debit: 105.25,
      credit: 0,
      receiptId: 'r1',
      receiptNo: 'R202601-0001',
    },
    {
      accountId: 'a-income',
      date: new Date('2026-01-10'),
      debit: 0,
      credit: 105.25,
      receiptId: 'r1',
      receiptNo: 'R202601-0001',
    },
    {
      accountId: 'a-expense',
      date: new Date('2026-02-05'),
      debit: 54000,
      credit: 0,
      paymentId: 'p1',
      voucherNo: 'PV-2026-0001',
    },
    {
      accountId: 'a-cash',
      date: new Date('2026-02-05'),
      debit: 0,
      credit: 54000,
      paymentId: 'p1',
      voucherNo: 'PV-2026-0001',
    },
  ];

  it('จับกลุ่มตามเอกสารต้นทาง — ใบเสร็จหนึ่งใบ ใบสำคัญจ่ายหนึ่งใบ = สองรายการ', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const journal = await service.getJournal();

    expect(journal).toHaveLength(2);
    expect(journal[0].transId).toBe('r1');
    expect(journal[1].transId).toBe('p1');
  });

  it('ทุกกลุ่มต้องดุลในตัวเอง เดบิตเท่ากับเครดิต', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const journal = await service.getJournal();

    for (const trans of journal) {
      expect(trans.totalDebit).toBe(trans.totalCredit);
    }
    expect(journal[0].totalDebit).toBe(105.25);
    expect(journal[1].totalDebit).toBe(54000);
  });

  it('อ้างอิงต้องเป็นเลขที่ใบเสร็จหรือเลขที่ใบสำคัญจ่าย ไม่ใช่รหัสภายใน', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const journal = await service.getJournal();

    expect(journal[0].reference).toBe('R202601-0001');
    expect(journal[1].reference).toBe('PV-2026-0001');
  });

  it('แต่ละกลุ่มต้องแสดงรหัสบัญชีของทุกขา', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const journal = await service.getJournal();

    expect(journal[0].entries.map((e: any) => e.accountCode).sort()).toEqual(['101', '401']);
    expect(journal[0].entries.find((e: any) => e.accountCode === '101').debit).toBe(105.25);
    expect(journal[0].entries.find((e: any) => e.accountCode === '401').credit).toBe(105.25);
  });

  it('รายการปรับปรุงที่ไม่ผูกเอกสาร ต้องยังขึ้นสมุดรายวัน ไม่ใช่หายไปเงียบ ๆ', async () => {
    const adjust: FakeEntry[] = [
      { id: 'adj-1', accountId: 'a-cash', date: new Date('2026-03-01'), debit: 10, credit: 0 },
      { id: 'adj-2', accountId: 'a-income', date: new Date('2026-03-01'), debit: 0, credit: 10 },
    ];
    const service = buildService(buildPrisma(ACCOUNTS, adjust));

    const journal = await service.getJournal();

    // ไม่มีเอกสารต้นทางให้จับกลุ่ม จึงแยกเป็นคนละรายการ (ใช้ id ของแถวเป็นคีย์)
    expect(journal.map((t) => t.transId)).toEqual(['adj-1', 'adj-2']);
    const debit = journal.reduce((s, t) => s + t.totalDebit, 0);
    const credit = journal.reduce((s, t) => s + t.totalCredit, 0);
    expect(debit).toBe(credit);
  });

  it('ระบุช่วงวันที่แล้ว ต้องเหลือเฉพาะเอกสารในช่วง', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const journal = await service.getJournal(new Date('2026-01-01'), new Date('2026-01-31'));

    expect(journal.map((t) => t.transId)).toEqual(['r1']);
  });
});

/**
 * บัญชีแยกประเภทต้องเดินยอดตามธรรมชาติของบัญชีนั้น
 * ถ้าเดินยอดผิดทาง บัญชีเงินสดที่จ่ายออกจะกลายเป็นยอดเพิ่ม
 */
describe('AccountsService.getLedger', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-income', code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
  ];

  const ENTRIES: FakeEntry[] = [
    { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 105.25, credit: 0 },
    { accountId: 'a-cash', date: new Date('2026-01-15'), debit: 200.5, credit: 0 },
    { accountId: 'a-cash', date: new Date('2026-02-05'), debit: 0, credit: 50.25 },
    { accountId: 'a-income', date: new Date('2026-01-10'), debit: 0, credit: 105.25 },
    { accountId: 'a-income', date: new Date('2026-01-15'), debit: 0, credit: 200.5 },
  ];

  it('บัญชีสินทรัพย์ — เดบิตเพิ่มยอด เครดิตลดยอด', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const ledger = await service.getLedger('a-cash');

    expect(ledger.map((e) => e.runningBalance)).toEqual([105.25, 305.75, 255.5]);
  });

  it('บัญชีรายได้ — เครดิตเพิ่มยอด (ไม่ใช่ติดลบ)', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const ledger = await service.getLedger('a-income');

    expect(ledger.map((e) => e.runningBalance)).toEqual([105.25, 305.75]);
  });

  it('ต้องแสดงเฉพาะรายการของบัญชีที่ขอ ไม่ปนบัญชีอื่น', async () => {
    const prisma = buildPrisma(ACCOUNTS, ENTRIES);
    const service = buildService(prisma);

    const ledger = await service.getLedger('a-cash');

    expect(ledger).toHaveLength(3);
    expect(ledger.every((e: any) => e.accountId === 'a-cash')).toBe(true);
    expect(prisma.ledgerEntry.findMany.mock.calls[0][0].where).toMatchObject({
      accountId: 'a-cash',
    });
  });

  it('ยอดปิดของบัญชีแยกประเภทต้องตรงกับยอดในงบทดลอง', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const ledger = await service.getLedger('a-cash');
    const tb = await service.getTrialBalance();

    expect(ledger[ledger.length - 1].runningBalance).toBe(
      tb.accounts.find((a) => a.code === '101')!.balance,
    );
  });
});

/**
 * งบดุลต้องปิดได้: สินทรัพย์ (รวมสินทรัพย์ถาวรตามราคาตามบัญชี) = หนี้สิน + ทุน
 * ถ้าไม่ปิด ต้องบอกส่วนต่างออกมา ไม่ใช่รายงานว่า "ดุล" ทุกครั้ง
 */
describe('AccountsService.getBalanceSheet', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-liab', code: '201', name: 'เจ้าหนี้', type: AccountType.LIABILITY },
    { id: 'a-equity', code: '310', name: 'ทุนสะสม', type: AccountType.EQUITY },
  ];

  const ENTRIES: FakeEntry[] = [
    { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 1000, credit: 0, schoolId: 'school-1' },
    { accountId: 'a-liab', date: new Date('2026-01-10'), debit: 0, credit: 300, schoolId: 'school-1' },
    { accountId: 'a-equity', date: new Date('2026-01-10'), debit: 0, credit: 700, schoolId: 'school-1' },
  ];

  const ASSETS: FakeAsset[] = [
    {
      code: 'FA-001',
      name: 'ตู้เอกสาร',
      originalCost: 50000,
      accumulatedDep: 20000,
      schoolId: 'school-1',
    },
  ];

  it('ไม่มีสินทรัพย์ถาวร — สินทรัพย์ต้องเท่ากับหนี้สินบวกทุน และรายงานว่าดุล', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const sheet = await service.getBalanceSheet();

    expect(sheet.totals.assets).toBe(1000);
    expect(sheet.totals.liabilities).toBe(300);
    expect(sheet.totals.equity).toBe(700);
    expect(sheet.totals.liabilitiesAndEquity).toBe(1000);
    expect(sheet.isBalanced).toBe(true);
    expect(sheet.difference).toBe(0);
  });

  it('สินทรัพย์ถาวรต้องคิดราคาตามบัญชี = ราคาทุน − ค่าเสื่อมสะสม', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES, ASSETS));

    const sheet = await service.getBalanceSheet();

    expect(sheet.fixedAssets[0]).toMatchObject({
      originalCost: 50000,
      accumulatedDep: 20000,
      balance: 30000,
    });
    expect(sheet.totals.fixedAssetsNet).toBe(30000);
    expect(sheet.totals.assets).toBe(31000);
  });

  it('สินทรัพย์ถาวรที่ตัดค่าเสื่อมเกินราคาทุน ต้องไม่กลายเป็นยอดติดลบ', async () => {
    const overDepreciated: FakeAsset[] = [
      { code: 'FA-002', name: 'คอมพิวเตอร์', originalCost: 20000, accumulatedDep: 25000 },
    ];
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES, overDepreciated));

    const sheet = await service.getBalanceSheet();

    expect(sheet.fixedAssets[0].balance).toBe(0);
    expect(sheet.totals.fixedAssetsNet).toBe(0);
  });

  it('สินทรัพย์ถาวรที่จำหน่ายออกแล้วต้องไม่นับ', async () => {
    const disposed: FakeAsset[] = [
      { code: 'FA-003', name: 'รถยนต์', originalCost: 400000, status: 'DISPOSED' },
    ];
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES, disposed));

    const sheet = await service.getBalanceSheet();

    expect(sheet.fixedAssets).toHaveLength(0);
    expect(sheet.totals.assets).toBe(1000);
  });

  it('งบไม่ปิด ต้องรายงานว่าไม่ดุลพร้อมส่วนต่าง ไม่ใช่บอกว่าดุล', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES, ASSETS));

    const sheet = await service.getBalanceSheet();

    // สินทรัพย์ 31,000 แต่หนี้สิน+ทุนมีแค่ 1,000 เพราะยังไม่ได้ลงทุนของสินทรัพย์ถาวร
    expect(sheet.isBalanced).toBe(false);
    expect(sheet.difference).toBe(30000);
  });

  it('แนบผลตรวจงบทดลองมาด้วยเสมอ เพื่อให้ตามหาต้นตอความไม่ดุลได้', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const sheet = await service.getBalanceSheet();

    expect(sheet.trialBalanceCheck).toMatchObject({ debit: 1000, credit: 1000, isBalanced: true });
  });

  /**
   * งบดุลเป็นยอด "ทั้งสมาคม" โดยเจตนา — ห้ามแก้กลับให้กรองรายโรงเรียน
   *
   * เหตุผล: เงินของกองทุนฌาปนกิจเป็นก้อนเดียวทั้งเขต (บัญชีธนาคารชุดเดียว) และ
   * LedgerEntry ไม่มีคอลัมน์ schoolId เลย ยอดสินทรัพย์/หนี้สิน/ทุนจึงกรองรายโรงเรียนไม่ได้จริง
   * เดิม getBalanceSheet รับ schoolId ไปกรองเฉพาะ "สินทรัพย์ถาวร" ส่วนที่เหลือไม่กรอง
   * ทำให้ SCHOOL_ADMIN เปิดงบดุลแล้วนึกว่าเห็นเฉพาะโรงเรียนตัวเอง ทั้งที่เป็นยอดทั้งสมาคม
   * ตอนนี้จึงตัดพารามิเตอร์ schoolId ทิ้ง ให้ทุกส่วนของงบอยู่บนขอบเขตเดียวกัน (ทั้งสมาคม)
   *
   * ถ้าวันหนึ่งต้องการงบดุลรายโรงเรียนจริง ต้องเพิ่มคอลัมน์ schoolId ใน LedgerEntry
   * แล้วออกแบบใหม่ทั้งชุด ไม่ใช่แค่ใส่พารามิเตอร์กลับเข้ามา
   */
  it('งบดุลเป็นยอดทั้งสมาคมเสมอ ไม่ขึ้นกับโรงเรียนของผู้เรียก', async () => {
    const mixed: FakeEntry[] = [
      ...ENTRIES,
      {
        accountId: 'a-cash',
        date: new Date('2026-01-11'),
        debit: 5000,
        credit: 0,
        schoolId: 'school-2',
      },
    ];
    const prisma = buildPrisma(ACCOUNTS, mixed, ASSETS);
    const service = buildService(prisma);

    const sheet = await service.getBalanceSheet();

    // 1,000 (school-1) + 5,000 (school-2) + สินทรัพย์ถาวร 30,000 ของ school-1 = 36,000
    expect(sheet.totals.assets).toBe(36000);
    // ห้ามมี read path ไหนส่งเงื่อนไขโรงเรียนไปที่ ledger หรือสินทรัพย์ถาวร
    const entryWheres = prisma.account.findMany.mock.calls.map(
      (c: any[]) => c[0]?.include?.entries?.where ?? {},
    );
    for (const w of entryWheres) {
      expect(w).not.toHaveProperty('schoolId');
      expect(w).not.toHaveProperty('receipt');
    }
    for (const call of prisma.asset.findMany.mock.calls) {
      expect(call[0]?.where ?? {}).not.toHaveProperty('schoolId');
    }
  });
});

/**
 * งบรายได้-ค่าใช้จ่ายเป็นตัวเลขที่เข้าที่ประชุมใหญ่
 */
describe('AccountsService.getProfitAndLoss', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-income', code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
    { id: 'a-fee', code: '402', name: 'รายได้ค่าบำรุง', type: AccountType.INCOME },
    { id: 'a-expense', code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์', type: AccountType.EXPENSE },
  ];

  const ENTRIES: FakeEntry[] = [
    { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 105.25, credit: 0 },
    { accountId: 'a-income', date: new Date('2026-01-10'), debit: 0, credit: 105.25 },
    { accountId: 'a-cash', date: new Date('2026-01-15'), debit: 200.5, credit: 0 },
    { accountId: 'a-fee', date: new Date('2026-01-15'), debit: 0, credit: 200.5 },
    { accountId: 'a-expense', date: new Date('2026-02-05'), debit: 100, credit: 0 },
    { accountId: 'a-cash', date: new Date('2026-02-05'), debit: 0, credit: 100 },
  ];

  const start = new Date('2026-01-01');
  const end = new Date('2026-12-31');

  it('กำไรสุทธิ = รายได้รวม − ค่าใช้จ่ายรวม และเศษสตางค์ต้องไม่หาย', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const pl = await service.getProfitAndLoss(start, end);

    expect(pl.totals.income).toBe(305.75);
    expect(pl.totals.expenses).toBe(100);
    expect(pl.totals.netProfit).toBe(205.75);
  });

  it('แสดงเฉพาะบัญชีรายได้และค่าใช้จ่าย ไม่ปนบัญชีสินทรัพย์', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const pl = await service.getProfitAndLoss(start, end);

    expect(pl.income.map((i) => i.code).sort()).toEqual(['401', '402']);
    expect(pl.expenses.map((e) => e.code)).toEqual(['501']);
  });

  it('ค่าใช้จ่ายมากกว่ารายได้ ต้องออกมาเป็นขาดทุน (ติดลบ) ไม่ใช่ 0', async () => {
    const heavyExpense: FakeEntry[] = [
      { accountId: 'a-income', date: new Date('2026-01-10'), debit: 0, credit: 100 },
      { accountId: 'a-cash', date: new Date('2026-01-10'), debit: 100, credit: 0 },
      { accountId: 'a-expense', date: new Date('2026-02-05'), debit: 350.5, credit: 0 },
      { accountId: 'a-cash', date: new Date('2026-02-05'), debit: 0, credit: 350.5 },
    ];
    const service = buildService(buildPrisma(ACCOUNTS, heavyExpense));

    const pl = await service.getProfitAndLoss(start, end);

    expect(pl.totals.netProfit).toBe(-250.5);
  });

  it('รายการนอกช่วงงวดต้องไม่ถูกนับ', async () => {
    const service = buildService(buildPrisma(ACCOUNTS, ENTRIES));

    const pl = await service.getProfitAndLoss(new Date('2026-01-01'), new Date('2026-01-31'));

    expect(pl.totals.expenses).toBe(0);
    expect(pl.totals.netProfit).toBe(305.75);
  });
});

/**
 * การปิดบัญชีประจำปีเขียนรายการลง LedgerEntry จริง ๆ ผิดแล้วแก้ยาก
 * เงื่อนไขที่ต้องเป็นจริง: รายการปิดต้องดุล และบัญชีสรุปผลได้เสีย (399) ต้องถูกล้างเป็นศูนย์
 */
describe('AccountsService.closeAccountingYear', () => {
  const ACCOUNTS: FakeAccount[] = [
    { id: 'a-cash', code: '101', name: 'เงินสด', type: AccountType.ASSET },
    { id: 'a-income', code: '401', name: 'รายได้เงินสงเคราะห์', type: AccountType.INCOME },
    { id: 'a-fee', code: '402', name: 'รายได้ค่าบำรุง', type: AccountType.INCOME },
    { id: 'a-expense', code: '501', name: 'ค่าใช้จ่ายเงินสงเคราะห์', type: AccountType.EXPENSE },
    { id: 'a-summary', code: '399', name: 'สรุปผลได้เสีย', type: AccountType.EQUITY },
    { id: 'a-retained', code: '310', name: 'ทุนสะสม', type: AccountType.EQUITY },
  ];

  // ปี 2569: รายได้ 10,000 ค่าใช้จ่าย 4,000 → กำไร 6,000
  const PROFIT_YEAR: FakeEntry[] = [
    { accountId: 'a-cash', date: new Date('2026-03-01'), debit: 10000, credit: 0 },
    { accountId: 'a-income', date: new Date('2026-03-01'), debit: 0, credit: 10000 },
    { accountId: 'a-expense', date: new Date('2026-06-01'), debit: 4000, credit: 0 },
    { accountId: 'a-cash', date: new Date('2026-06-01'), debit: 0, credit: 4000 },
  ];

  function totals(entries: any[]) {
    return {
      debit: entries.reduce((s, e) => s + Number(e.debit), 0),
      credit: entries.reduce((s, e) => s + Number(e.credit), 0),
    };
  }

  function movementOf(entries: any[], accountId: string) {
    return entries
      .filter((e) => e.accountId === accountId)
      .reduce((s, e) => s + Number(e.credit) - Number(e.debit), 0);
  }

  it('รายการปิดบัญชีทั้งชุดต้องดุล', async () => {
    const prisma = buildPrisma(ACCOUNTS, PROFIT_YEAR);
    const service = buildService(prisma);

    await service.closeAccountingYear(2026);

    const created = prisma.ledgerEntry.createMany.mock.calls[0][0].data;
    const { debit, credit } = totals(created);
    expect(debit).toBe(credit);
    expect(debit).toBe(20000); // ปิดรายได้ 10,000 + ปิดค่าใช้จ่าย 4,000 + โอนกำไร 6,000
  });

  it('กำไรต้องถูกโอนเข้าทุนสะสม และบัญชีสรุปผลได้เสียต้องถูกล้างเป็นศูนย์', async () => {
    const prisma = buildPrisma(ACCOUNTS, PROFIT_YEAR);
    const service = buildService(prisma);

    const result = await service.closeAccountingYear(2026);
    const created = prisma.ledgerEntry.createMany.mock.calls[0][0].data;

    expect(result.netProfit).toBe(6000);
    expect(movementOf(created, 'a-retained')).toBe(6000); // เครดิตทุนสะสม
    expect(movementOf(created, 'a-summary')).toBe(0); // 399 ปิดเป็นศูนย์
  });

  it('บัญชีรายได้และค่าใช้จ่ายต้องถูกล้างจนยอดเป็นศูนย์', async () => {
    const prisma = buildPrisma(ACCOUNTS, PROFIT_YEAR);
    const service = buildService(prisma);

    await service.closeAccountingYear(2026);
    const pl = await service.getProfitAndLoss(new Date(2026, 0, 1), new Date(2027, 0, 1));

    expect(pl.totals.income).toBe(0);
    expect(pl.totals.expenses).toBe(0);
    expect(pl.totals.netProfit).toBe(0);
  });

  it('ปิดปีที่ขาดทุน ต้องหักออกจากทุนสะสม ไม่ใช่บวกเพิ่ม', async () => {
    const lossYear: FakeEntry[] = [
      { accountId: 'a-cash', date: new Date('2026-03-01'), debit: 4000, credit: 0 },
      { accountId: 'a-income', date: new Date('2026-03-01'), debit: 0, credit: 4000 },
      { accountId: 'a-expense', date: new Date('2026-06-01'), debit: 10000, credit: 0 },
      { accountId: 'a-cash', date: new Date('2026-06-01'), debit: 0, credit: 10000 },
    ];
    const prisma = buildPrisma(ACCOUNTS, lossYear);
    const service = buildService(prisma);

    const result = await service.closeAccountingYear(2026);
    const created = prisma.ledgerEntry.createMany.mock.calls[0][0].data;

    expect(result.netProfit).toBe(-6000);
    expect(movementOf(created, 'a-retained')).toBe(-6000); // เดบิตทุนสะสม
    expect(movementOf(created, 'a-summary')).toBe(0);
    const { debit, credit } = totals(created);
    expect(debit).toBe(credit);
  });

  it('ปิดปีเดิมซ้ำ ต้องไม่สร้างรายการปิดซ้ำ เพราะบัญชีถูกล้างไปแล้ว', async () => {
    const prisma = buildPrisma(ACCOUNTS, PROFIT_YEAR);
    const service = buildService(prisma);

    await service.closeAccountingYear(2026);
    const second = await service.closeAccountingYear(2026);

    expect(second.closingEntriesCreated).toBe(0);
    expect(second.netProfit).toBe(0);
    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(1);
  });

  it('ไม่มีบัญชี 399 หรือ 310 ต้องปฏิเสธ ไม่ใช่ปิดครึ่งเดียวแล้วทิ้งรายการค้าง', async () => {
    const withoutSummary = ACCOUNTS.filter((a) => a.code !== '399');
    const prisma = buildPrisma(withoutSummary, PROFIT_YEAR);
    const service = buildService(prisma);

    await expect(service.closeAccountingYear(2026)).rejects.toThrow(/399/);
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
  });

  it('ปีที่ไม่มีรายการเลย ต้องไม่เขียนอะไรลงบัญชี', async () => {
    const prisma = buildPrisma(ACCOUNTS, []);
    const service = buildService(prisma);

    const result = await service.closeAccountingYear(2026);

    expect(result.closingEntriesCreated).toBe(0);
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
  });

  /**
   * เดิม closeAccountingYear ปิดเฉพาะบัญชีที่ยอด > 0 (`if (acc && inc.amount > 0)`)
   * บัญชีรายได้ที่ยอดติดลบ (เช่น กลับรายการมากกว่ารายได้ที่รับจริง) จึงถูกข้าม
   * แต่ตัวเลข netProfit ที่โอนเข้าทุนสะสมกลับรวมยอดติดลบนั้นไว้แล้ว
   * ผลคือบัญชี 399 เหลือยอดค้างข้ามปี และบัญชีรายได้ตัวนั้นไม่เคยถูกล้าง
   */
  it('บัญชีรายได้ที่ยอดติดลบต้องถูกล้างด้วย ไม่งั้น 399 เหลือยอดค้างข้ามปี', async () => {
    const withNegativeIncome: FakeEntry[] = [
      ...PROFIT_YEAR,
      // กลับรายการค่าบำรุงที่เก็บเกิน ทำให้บัญชี 402 มียอดติดลบ 2,000
      { accountId: 'a-fee', date: new Date('2026-08-01'), debit: 2000, credit: 0 },
      { accountId: 'a-cash', date: new Date('2026-08-01'), debit: 0, credit: 2000 },
    ];
    const prisma = buildPrisma(ACCOUNTS, withNegativeIncome);
    const service = buildService(prisma);

    await service.closeAccountingYear(2026);
    const created = prisma.ledgerEntry.createMany.mock.calls[0][0].data;

    expect(movementOf(created, 'a-summary')).toBe(0);
    expect(movementOf(created, 'a-fee')).toBe(2000);
  });
});
