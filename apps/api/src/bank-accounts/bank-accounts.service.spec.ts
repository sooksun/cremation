import { BadRequestException, NotFoundException } from '@nestjs/common';
import { BankTransactionType, Prisma } from '@prisma/client';
import { BankAccountsService } from './bank-accounts.service';
import { PrismaService } from '../prisma/prisma.service';
import { DocumentNumberService } from '../common/document-number.service';
import { AuditLogService } from '../common/services/audit-log.service';

/**
 * ยอดคงเหลือธนาคารคือตัวเลขที่กรรมการใช้ตัดสินใจจ่ายเงินสงเคราะห์
 * มีสามแหล่งที่ไหลเข้ามา (ใบเสร็จ / ใบสำคัญจ่าย / ธุรกรรมที่คีย์เอง)
 * แต่ละแหล่งมีเงื่อนไข "ไม่นับ" ของตัวเอง — ใบเสร็จที่ยกเลิก และธุรกรรมที่ลบแบบ soft-delete
 * เทสต์ชุดนี้จึงคิดเลขจริงจากชุดข้อมูลเล็ก ๆ ไม่ใช่ดูแค่ where
 */
describe('BankAccountsService — ยอดคงเหลือและรายการเดินบัญชี', () => {
  const BANK = 'bank-1';
  const OTHER_BANK = 'bank-2';

  const RECEIPTS = [
    {
      id: 'r1',
      bankAccountId: BANK,
      receiptNo: 'R202601-0001',
      description: null,
      date: new Date('2026-01-10'),
      amount: 105.25,
      voidedAt: null,
      school: { name: 'โรงเรียน ก' },
    },
    {
      id: 'r2',
      bankAccountId: BANK,
      receiptNo: 'R202601-0002',
      description: null,
      date: new Date('2026-01-15'),
      amount: 200.5,
      voidedAt: null,
      school: { name: 'โรงเรียน ก' },
    },
    {
      id: 'r3',
      bankAccountId: BANK,
      receiptNo: 'R202601-0003',
      description: null,
      date: new Date('2026-01-16'),
      amount: 5000,
      voidedAt: new Date('2026-01-17'), // ยกเลิกแล้ว — ไม่ใช่เงินจริง
      school: { name: 'โรงเรียน ก' },
    },
    {
      id: 'r9',
      bankAccountId: OTHER_BANK,
      receiptNo: 'R202601-0009',
      description: null,
      date: new Date('2026-01-11'),
      amount: 7777,
      voidedAt: null, // คนละบัญชีธนาคาร
      school: { name: 'โรงเรียน ข' },
    },
  ];

  const PAYMENTS = [
    {
      id: 'p1',
      bankAccountId: BANK,
      voucherNo: 'PV-2026-0001',
      description: null,
      date: new Date('2026-01-18'),
      amount: 50.25,
      school: { name: 'โรงเรียน ก' },
    },
  ];

  const TXNS = [
    {
      id: 't1',
      bankAccountId: BANK,
      transactionNo: 'BT-2026-0001',
      description: null,
      date: new Date('2026-01-12'),
      type: BankTransactionType.DEPOSIT,
      amount: 1000,
      deletedAt: null,
    },
    {
      id: 't2',
      bankAccountId: BANK,
      transactionNo: 'BT-2026-0002',
      description: null,
      date: new Date('2026-01-13'),
      type: BankTransactionType.DEPOSIT,
      amount: 300,
      deletedAt: new Date('2026-01-14'), // ลบแล้ว — ห้ามนับ
    },
    {
      id: 't3',
      bankAccountId: BANK,
      transactionNo: 'BT-2026-0003',
      description: null,
      date: new Date('2026-01-20'),
      type: BankTransactionType.WITHDRAWAL,
      amount: 100,
      deletedAt: null,
    },
    {
      id: 't4',
      bankAccountId: BANK,
      transactionNo: 'BT-2026-0004',
      description: null,
      date: new Date('2026-01-21'),
      type: BankTransactionType.WITHDRAWAL,
      amount: 700,
      deletedAt: new Date('2026-01-22'), // ลบแล้ว — ห้ามนับ
    },
  ];

  function matches(row: any, where: any = {}) {
    for (const [key, cond] of Object.entries(where)) {
      if (key === 'date') {
        const range = cond as any;
        if (range?.gte && row.date < range.gte) return false;
        if (range?.lte && row.date > range.lte) return false;
        continue;
      }
      if (cond === null) {
        if (row[key] !== null && row[key] !== undefined) return false;
        continue;
      }
      if (row[key] !== cond) return false;
    }
    return true;
  }

  function sum(rows: any[]) {
    return rows.length
      ? new Prisma.Decimal(rows.reduce((s, r) => s + r.amount, 0).toFixed(2))
      : null;
  }

  function buildService() {
    const prisma: any = {
      bankAccount: {
        findUnique: jest.fn(async () => ({ id: BANK, isActive: true, isDefault: true })),
      },
      receipt: {
        findMany: jest.fn(async ({ where }: any) => RECEIPTS.filter((r) => matches(r, where))),
        aggregate: jest.fn(async ({ where }: any) => ({
          _sum: { amount: sum(RECEIPTS.filter((r) => matches(r, where))) },
        })),
      },
      paymentVoucher: {
        findMany: jest.fn(async ({ where }: any) => PAYMENTS.filter((p) => matches(p, where))),
        aggregate: jest.fn(async ({ where }: any) => ({
          _sum: { amount: sum(PAYMENTS.filter((p) => matches(p, where))) },
        })),
      },
      bankTransaction: {
        findMany: jest.fn(async ({ where }: any) => TXNS.filter((t) => matches(t, where))),
        aggregate: jest.fn(async ({ where }: any) => ({
          _sum: { amount: sum(TXNS.filter((t) => matches(t, where))) },
        })),
      },
    };

    const service = new BankAccountsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      {} as AuditLogService,
    );

    return { service, prisma };
  }

  it('ยอดคงเหลือ = รับ − จ่าย โดยไม่นับใบเสร็จที่ยกเลิกและธุรกรรมที่ลบแล้ว', async () => {
    const { service } = buildService();

    const balance = await service.getBalance(BANK);

    // รับ: 105.25 + 200.50 (ใบ 5,000 ยกเลิก) + ฝากเอง 1,000 (ที่ลบ 300 ไม่นับ)
    expect(balance.totalDeposits).toBe(1305.75);
    // จ่าย: ใบสำคัญจ่าย 50.25 + ถอนเอง 100 (ที่ลบ 700 ไม่นับ)
    expect(balance.totalWithdrawals).toBe(150.25);
    expect(balance.balance).toBe(1155.5);
  });

  it('ใบเสร็จที่ยกเลิก 5,000 บาทต้องไม่โผล่ในรายการเดินบัญชี', async () => {
    const { service } = buildService();

    const rows = await service.getTransactions(BANK);

    expect(rows.map((r) => r.id)).not.toContain('r3');
    expect(rows.map((r) => r.id)).toEqual(['r1', 't1', 'r2', 'p1', 't3']);
  });

  it('ทิศทางเงินต้องถูก: ใบเสร็จเป็นบวก ใบสำคัญจ่ายและการถอนเป็นลบ', async () => {
    const { service } = buildService();

    const rows = await service.getTransactions(BANK);
    const byId = Object.fromEntries(rows.map((r) => [r.id, r]));

    expect(byId['r1'].amount).toBe(105.25);
    expect(byId['t1'].amount).toBe(1000);
    expect(byId['p1'].amount).toBe(-50.25);
    expect(byId['t3'].amount).toBe(-100);
  });

  it('ยอดสะสมต้องไล่ตามลำดับวันที่ และปิดท้ายเท่ากับยอดคงเหลือ', async () => {
    const { service } = buildService();

    const rows = await service.getTransactions(BANK);
    const balance = await service.getBalance(BANK);

    expect(rows.map((r) => r.balance)).toEqual([105.25, 1105.25, 1305.75, 1255.5, 1155.5]);
    expect(rows[rows.length - 1].balance).toBe(balance.balance);
  });

  it('รายการเดินบัญชีต้องไม่รั่วรายการของบัญชีธนาคารอื่นเข้ามา', async () => {
    const { service } = buildService();

    const rows = await service.getTransactions(BANK);

    expect(rows.map((r) => r.id)).not.toContain('r9');
  });

  it('กรองช่วงวันที่แล้ว ต้องเหลือเฉพาะรายการในช่วง', async () => {
    const { service } = buildService();

    const rows = await service.getTransactions(
      BANK,
      new Date('2026-01-10'),
      new Date('2026-01-15'),
    );

    expect(rows.map((r) => r.id)).toEqual(['r1', 't1', 'r2']);
    expect(rows[rows.length - 1].balance).toBe(1305.75);
  });

  it('บัญชีธนาคารที่ไม่มีอยู่จริง ต้องแจ้งไม่พบ ไม่ใช่คืนยอด 0', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.findUnique.mockResolvedValue(null);

    await expect(service.getBalance('ghost')).rejects.toThrow(NotFoundException);
  });
});

/**
 * บัญชีหลัก (isDefault) คือปลายทางที่ใบเสร็จอัตโนมัติจะถูกผูกไปให้
 * ถ้ามีบัญชีหลักพร้อมกันสองใบ หรือปิดบัญชีหลักทิ้งโดยยังมีบัญชีอื่นอยู่
 * ใบเสร็จรอบถัดไปจะไปเข้าบัญชีที่ไม่ได้ตั้งใจ
 */
describe('BankAccountsService — บัญชีหลักและการปิดบัญชี', () => {
  function buildService() {
    const prisma: any = {
      bankAccount: {
        findUnique: jest.fn(async () => ({
          id: 'bank-1',
          isActive: true,
          isDefault: true,
          bankName: 'ธนาคารกรุงไทย',
          accountNo: '123-4-56789-0',
        })),
        findFirst: jest.fn(async () => null),
        findMany: jest.fn(async () => []),
        create: jest.fn(async ({ data }: any) => ({ id: 'bank-new', ...data })),
        update: jest.fn(async ({ where, data }: any) => ({ id: where.id, ...data })),
        updateMany: jest.fn(async () => ({ count: 1 })),
        count: jest.fn(async () => 0),
      },
      $transaction: jest.fn(async (ops: any) => Promise.all(ops)),
    };

    const service = new BankAccountsService(
      prisma as unknown as PrismaService,
      {} as DocumentNumberService,
      { log: jest.fn() } as unknown as AuditLogService,
    );

    return { service, prisma };
  }

  it('สร้างบัญชีใหม่เป็นบัญชีหลัก ต้องล้าง default เดิมใน transaction เดียวกัน', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.findUnique.mockResolvedValue(null); // เลขบัญชียังไม่ซ้ำ

    await service.create({
      bankName: 'ธนาคารออมสิน',
      accountNo: '999-9-99999-9',
      accountName: 'สมาคมฌาปนกิจ',
      isDefault: true,
    } as never);

    expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(prisma.bankAccount.updateMany).toHaveBeenCalledWith({
      where: { isDefault: true },
      data: { isDefault: false },
    });
  });

  it('สร้างบัญชีธรรมดา ต้องไม่ไปล้าง default ของบัญชีอื่น', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.findUnique.mockResolvedValue(null);

    await service.create({
      bankName: 'ธนาคารออมสิน',
      accountNo: '999-9-99999-9',
      accountName: 'สมาคมฌาปนกิจ',
    } as never);

    expect(prisma.bankAccount.updateMany).not.toHaveBeenCalled();
  });

  it('เลขบัญชีซ้ำต้องถูกปฏิเสธ ไม่ใช่สร้างบัญชีคู่แฝด', async () => {
    const { service, prisma } = buildService();

    await expect(
      service.create({
        bankName: 'ธนาคารกรุงไทย',
        accountNo: '123-4-56789-0',
        accountName: 'สมาคมฌาปนกิจ',
      } as never),
    ).rejects.toThrow(BadRequestException);

    expect(prisma.bankAccount.create).not.toHaveBeenCalled();
  });

  it('เปลี่ยนบัญชีหลัก ต้องล้าง default เดิมและตั้งใหม่ใน transaction เดียวกัน', async () => {
    const { service, prisma } = buildService();

    await service.setDefault('bank-2');

    expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    expect(prisma.bankAccount.updateMany).toHaveBeenCalledWith({
      where: { isDefault: true },
      data: { isDefault: false },
    });
    expect(prisma.bankAccount.update).toHaveBeenCalledWith({
      where: { id: 'bank-2' },
      data: { isDefault: true, isActive: true },
    });
  });

  it('ปิดบัญชีหลักทั้งที่ยังมีบัญชีอื่นอยู่ ต้องถูกปฏิเสธ', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.count.mockResolvedValue(2);

    await expect(service.remove('bank-1')).rejects.toThrow(BadRequestException);

    expect(prisma.bankAccount.update).not.toHaveBeenCalled();
  });

  it('ปิดบัญชีหลักใบสุดท้ายได้ และต้องล้างธง default ไปด้วย', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.count.mockResolvedValue(0);

    await service.remove('bank-1');

    expect(prisma.bankAccount.update).toHaveBeenCalledWith({
      where: { id: 'bank-1' },
      data: { isActive: false, isDefault: false },
    });
  });
});

/**
 * ธุรกรรมที่คีย์เองเข้าไปกระทบยอดคงเหลือโดยตรง การลบจึงต้องเป็น soft-delete
 * (ข้อบังคับสมาคม ข้อ 30 — เก็บหลักฐาน 10 ปี) และแถวที่ลบแล้วต้องหายจากทุก read path
 */
describe('BankAccountsService — ธุรกรรมที่คีย์เอง', () => {
  function buildService() {
    const prisma: any = {
      bankAccount: {
        findUnique: jest.fn(async () => ({ id: 'bank-1', isActive: true })),
      },
      bankTransaction: {
        findMany: jest.fn(async () => []),
        findFirst: jest.fn(async () => ({
          id: 'txn-1',
          bankAccountId: 'bank-1',
          transactionNo: 'BT-2026-0001',
          type: BankTransactionType.DEPOSIT,
          amount: new Prisma.Decimal('105.25'),
          deletedAt: null,
        })),
        create: jest.fn(async ({ data }: any) => ({
          id: 'txn-1',
          ...data,
          amount: new Prisma.Decimal(data.amount),
        })),
        delete: jest.fn(async () => ({ id: 'txn-1' })),
        deleteMany: jest.fn(async () => ({ count: 1 })),
        update: jest.fn(async ({ where, data }: any) => ({
          id: where.id,
          transactionNo: 'BT-2026-0001',
          bankAccountId: 'bank-1',
          type: data.type ?? BankTransactionType.DEPOSIT,
          amount: new Prisma.Decimal(data.amount ?? '105.25'),
          ...data,
        })),
      },
    };

    const service = new BankAccountsService(
      prisma as unknown as PrismaService,
      {
        generateNumber: jest.fn().mockResolvedValue('BT-2026-0001'),
      } as unknown as DocumentNumberService,
      { log: jest.fn() } as unknown as AuditLogService,
    );

    return { service, prisma };
  }

  it('ลบธุรกรรมต้องเป็น soft-delete เท่านั้น ห้ามลบแถวทิ้ง', async () => {
    const { service, prisma } = buildService();

    await service.removeManualTransaction('txn-1');

    expect(prisma.bankTransaction.update).toHaveBeenCalledTimes(1);
    const data = prisma.bankTransaction.update.mock.calls[0][0].data;
    expect(data.deletedAt).toBeInstanceOf(Date);
    expect(prisma.bankTransaction.delete).not.toHaveBeenCalled();
    expect(prisma.bankTransaction.deleteMany).not.toHaveBeenCalled();
  });

  it('ธุรกรรมที่ลบไปแล้ว ต้องลบซ้ำไม่ได้ (มองไม่เห็นแล้ว)', async () => {
    const { service, prisma } = buildService();
    prisma.bankTransaction.findFirst.mockResolvedValue(null);

    await expect(service.removeManualTransaction('txn-1')).rejects.toThrow(NotFoundException);
    expect(prisma.bankTransaction.update).not.toHaveBeenCalled();
  });

  it('แก้ธุรกรรมที่ลบไปแล้วไม่ได้ ไม่งั้นยอดที่ลบทิ้งจะกลับมาเงียบ ๆ', async () => {
    const { service, prisma } = buildService();
    prisma.bankTransaction.findFirst.mockResolvedValue(null);

    await expect(
      service.updateManualTransaction('txn-1', { amount: 999 }),
    ).rejects.toThrow(NotFoundException);
    expect(prisma.bankTransaction.update).not.toHaveBeenCalled();
  });

  it('รายการธุรกรรมต้องกรองแถวที่ลบแล้วออกเสมอ', async () => {
    const { service, prisma } = buildService();

    await service.listManualTransactions('bank-1');
    await service.listManualTransactions();

    for (const call of prisma.bankTransaction.findMany.mock.calls) {
      expect(call[0].where).toMatchObject({ deletedAt: null });
    }
    expect(prisma.bankTransaction.findMany.mock.calls[0][0].where).toMatchObject({
      bankAccountId: 'bank-1',
    });
  });

  it('สร้างธุรกรรมต้องออกเลขที่เอกสารจาก DocumentNumberService และผูกกับบัญชีที่มีอยู่จริง', async () => {
    const { service, prisma } = buildService();

    const txn = await service.createManualTransaction({
      bankAccountId: 'bank-1',
      date: '2026-01-12',
      type: BankTransactionType.DEPOSIT,
      amount: 105.25,
    } as never);

    expect(prisma.bankAccount.findUnique).toHaveBeenCalled();
    expect(prisma.bankTransaction.create.mock.calls[0][0].data.transactionNo).toBe('BT-2026-0001');
    expect(Number(txn.amount)).toBe(105.25);
  });

  it('สร้างธุรกรรมกับบัญชีธนาคารที่ไม่มีอยู่จริง ต้องถูกปฏิเสธก่อนคีย์เข้าไป', async () => {
    const { service, prisma } = buildService();
    prisma.bankAccount.findUnique.mockResolvedValue(null);

    await expect(
      service.createManualTransaction({
        bankAccountId: 'ghost',
        date: '2026-01-12',
        type: BankTransactionType.DEPOSIT,
        amount: 105.25,
      } as never),
    ).rejects.toThrow(NotFoundException);

    expect(prisma.bankTransaction.create).not.toHaveBeenCalled();
  });
});
