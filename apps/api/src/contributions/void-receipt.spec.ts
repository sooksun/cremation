import { ContributionsService } from './contributions.service';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { DocumentNumberService } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AppSettingsService } from '../common/services/app-settings.service';

/**
 * เลขที่ใบเสร็จห้ามถูกนำกลับมาใช้ซ้ำ
 *
 * เดิมการยกเลิกการชำระลบแถวใบเสร็จทิ้ง เลขที่ของเดือนนั้นจึงว่างกลับมา
 * แล้วการชำระครั้งถัดไปได้เลขที่เดิมไปออกให้คนละคนคนละยอด
 * ใบเสร็จจึงต้องถูกทำเครื่องหมายยกเลิก (voidedAt) ไม่ใช่ลบทิ้ง
 * ส่วนรายการบัญชีกับสมุดเงินสดของใบที่ยกเลิกต้องหายไป เพราะไม่ใช่เงินจริงแล้ว
 */
function buildHarness(options?: { auditLog?: { log: jest.Mock } }) {
  const receipts = new Map<string, any>();
  const ledger: any[] = [];
  const cashBook: any[] = [];
  let seq = 0;
  let receiptNoSeq = 0;

  const contribution: any = {
    id: 'c1',
    schoolId: 'school-1',
    memberId: 'member-1',
    welfareAmount: 100,
    serviceAmount: 5,
    totalAmount: 105,
    paidAmount: 0,
    paidDate: null,
    receiptId: null,
    isArrears: false,
    period: { id: 'p1', isClosed: false, year: 2026, month: 1 },
    member: { groupId: null, memberNo: 'M0001', associationMember: { firstName: 'ก', lastName: 'ข' } },
  };

  const prisma: any = {
    memberContribution: {
      findUnique: jest.fn(async () => ({ ...contribution })),
      update: jest.fn(async ({ data }: any) => {
        Object.assign(contribution, data);
        return { ...contribution };
      }),
    },
    contributionPeriod: { findUnique: jest.fn() },
    receipt: {
      create: jest.fn(async ({ data }: any) => {
        const id = `receipt-${++seq}`;
        const row = { id, voidedAt: null, voidReason: null, ...data };
        receipts.set(id, row);
        return { ...row };
      }),
      findUnique: jest.fn(async ({ where }: any) => {
        const row = receipts.get(where.id);
        if (!row) return null;
        return {
          ...row,
          // ความสัมพันธ์ 1:1 — ใบเสร็จเป็นของรายการนี้ก็ต่อเมื่อรายการยังชี้กลับมาที่ใบนี้
          memberContribution: contribution.receiptId === row.id ? { id: contribution.id } : null,
        };
      }),
      update: jest.fn(async ({ where, data }: any) => {
        const row = receipts.get(where.id);
        if (!row) throw new Error(`receipt ${where.id} not found`);
        Object.assign(row, data);
        return { ...row };
      }),
      delete: jest.fn(async ({ where }: any) => {
        receipts.delete(where.id);
        return { id: where.id };
      }),
    },
    ledgerEntry: {
      createMany: jest.fn(async ({ data }: any) => {
        ledger.push(...data);
        return { count: data.length };
      }),
      deleteMany: jest.fn(async ({ where }: any) => {
        const before = ledger.length;
        for (let i = ledger.length - 1; i >= 0; i--) {
          if (ledger[i].receiptId === where.receiptId) ledger.splice(i, 1);
        }
        return { count: before - ledger.length };
      }),
    },
    cashBook: {
      deleteMany: jest.fn(async ({ where }: any) => {
        const before = cashBook.length;
        for (let i = cashBook.length - 1; i >= 0; i--) {
          if (cashBook[i].receiptId === where.receiptId) cashBook.splice(i, 1);
        }
        return { count: before - cashBook.length };
      }),
    },
    bankAccount: { findUnique: jest.fn(async () => ({ id: 'bank-1' })) },
    account: {
      findFirst: jest.fn(async ({ where }: any) => ({ id: `acc-${where.code}`, code: where.code })),
    },
    $transaction: jest.fn(async (fn: any) => fn(prisma)),
  };

  const auditLog = options?.auditLog ?? { log: jest.fn() };

  const service = new ContributionsService(
    prisma as unknown as PrismaService,
    {} as MembersService,
    { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
    {
      // เลียนแบบเลขที่วิ่งไปข้างหน้าเสมอ ไม่ย้อนกลับมาใช้เลขเดิม
      generateNumber: jest.fn(async () => `R202601-M${String(++receiptNoSeq).padStart(4, '0')}`),
    } as unknown as DocumentNumberService,
    { findDefault: jest.fn().mockResolvedValue({ id: 'bank-1' }) } as unknown as BankAccountsService,
    { assertSchoolAccess: jest.fn(), assertGroupLeaderCanPay: jest.fn() } as unknown as SchoolScopeService,
    auditLog as unknown as AuditLogService,
    {
      isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
      effectiveServiceFee: jest.fn((fee: number) => fee),
    } as unknown as AppSettingsService,
  );

  return { service, prisma, receipts, ledger, cashBook, contribution, auditLog };
}

describe('F1 — ยกเลิกการชำระต้องยกเลิกใบเสร็จ ไม่ใช่ลบแถวทิ้ง', () => {
  it('ใบเสร็จยังอยู่ในระบบและถูกทำเครื่องหมายยกเลิก', async () => {
    const { service, prisma, receipts } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    const [receiptId] = Array.from(receipts.keys());

    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' });

    expect(prisma.receipt.delete).not.toHaveBeenCalled();
    expect(receipts.size).toBe(1);
    expect(receipts.get(receiptId).voidedAt).toBeInstanceOf(Date);
    expect(receipts.get(receiptId).voidReason).toEqual(expect.any(String));
  });

  it('รายการบัญชีและสมุดเงินสดของใบที่ยกเลิกต้องหายไป เพราะไม่ใช่เงินจริงแล้ว', async () => {
    const { service, prisma, ledger, contribution } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    expect(ledger).toHaveLength(3);

    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' });

    expect(ledger).toHaveLength(0);
    expect(prisma.cashBook.deleteMany).toHaveBeenCalled();
    expect(contribution.receiptId).toBeNull();
    expect(contribution.isArrears).toBe(true);
  });

  it('ชำระใหม่หลังยกเลิก ต้องได้ใบเสร็จเลขใหม่ ไม่ใช่เลขเดิมของใบที่ยกเลิก', async () => {
    const { service, receipts } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' });
    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-21' });

    const rows = Array.from(receipts.values());
    expect(rows).toHaveLength(2);

    const voided = rows.filter((r) => r.voidedAt);
    const active = rows.filter((r) => !r.voidedAt);
    expect(voided).toHaveLength(1);
    expect(active).toHaveLength(1);
    expect(active[0].receiptNo).not.toBe(voided[0].receiptNo);
  });
});

describe('F2 — การยกเลิกต้องทิ้งร่องรอยว่ายกเลิกใบเสร็จใบไหน', () => {
  it('บันทึก audit log พร้อมเลขที่ใบเสร็จและยอดที่ถูกยกเลิก', async () => {
    const auditLog = { log: jest.fn() };
    const { service, receipts } = buildHarness({ auditLog });
    const actor = { id: 'u1', role: 'ADMIN', schoolId: 'school-1' } as any;

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' }, actor);
    const [receipt] = Array.from(receipts.values());

    auditLog.log.mockClear();
    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' }, actor);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({
        metadata: expect.objectContaining({
          voidedReceiptNo: receipt.receiptNo,
          voidedAmount: 105,
        }),
      }),
    );
  });

  it('ทางลงชำระรายคน (payMemberForPeriod) ก็ต้องทิ้งร่องรอยเดียวกัน', async () => {
    const auditLog = { log: jest.fn() };
    const { service, prisma, receipts } = buildHarness({ auditLog });
    prisma.contributionPeriod.findUnique.mockResolvedValue({
      id: 'p1', year: 2026, month: 1, isClosed: false, welfareRate: 100, serviceFee: 5,
    });
    prisma.member = {
      findUnique: jest.fn(async () => ({
        id: 'member-1', memberNo: 'M0001', schoolId: 'school-1', groupId: null,
        associationMember: { firstName: 'ก', lastName: 'ข' },
      })),
    };
    const actor = { id: 'u1', role: 'ADMIN', schoolId: 'school-1' } as any;

    await service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1', amount: 105 }, actor);
    const [receipt] = Array.from(receipts.values());

    auditLog.log.mockClear();
    await service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1', amount: 0 }, actor);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({
        metadata: expect.objectContaining({
          voidedReceiptNo: receipt.receiptNo,
          voidedAmount: 105,
        }),
      }),
    );
  });
});

describe('F3 — แก้ยอดชำระ ใบเสร็จและบัญชีต้องตามยอดใหม่', () => {
  it('ยอดเปลี่ยน ต้องยกเลิกใบเดิมและออกใบใหม่ตามยอดใหม่', async () => {
    const { service, receipts, contribution } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    const [oldReceiptId] = Array.from(receipts.keys());

    await service.recordPayment('c1', { amount: 50, paidDate: '2026-01-20' });

    expect(receipts.size).toBe(2);
    expect(receipts.get(oldReceiptId).voidedAt).toBeInstanceOf(Date);

    const active = Array.from(receipts.values()).filter((r) => !r.voidedAt);
    expect(active).toHaveLength(1);
    expect(Number(active[0].amount)).toBe(50);
    expect(contribution.receiptId).toBe(active[0].id);
    expect(Number(contribution.paidAmount)).toBe(50);
  });

  it('บัญชีต้องเหลือเฉพาะรายการของใบใหม่และดุลที่ยอดใหม่', async () => {
    const { service, receipts, ledger } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    await service.recordPayment('c1', { amount: 50, paidDate: '2026-01-20' });

    const active = Array.from(receipts.values()).filter((r) => !r.voidedAt);
    expect(ledger.every((e) => e.receiptId === active[0].id)).toBe(true);

    const debit = ledger.reduce((sum, e) => sum + Number(e.debit || 0), 0);
    const credit = ledger.reduce((sum, e) => sum + Number(e.credit || 0), 0);
    expect(debit).toBe(50);
    expect(credit).toBe(50);
  });

  /**
   * ยอดที่รับจริงไม่เท่ากับยอดที่เรียกเก็บ (105 = สงเคราะห์ 100 + ค่าบริการ 5)
   * ด้านเครดิตต้องกระจายจากยอดที่รับจริง ไม่ใช่ยอดที่เรียกเก็บ ไม่งั้นเดบิตกับเครดิตไม่ดุล
   *
   * ยอดที่เกิน 105 ไม่มีในชุดนี้ เพราะ I3 ปฏิเสธตั้งแต่ก่อนถึงการลงบัญชี
   * (เทสต์การปฏิเสธอยู่ที่ record-payment.spec.ts)
   */
  it.each([
    [105, { welfare: 100, service: 5 }],
    [50, { welfare: 50, service: 0 }],
    [102, { welfare: 100, service: 2 }],
  ])('รับจริง %d บาท ต้องลงบัญชีดุลและกระจายเงินสงเคราะห์ก่อนค่าบริการ', async (amount, expected) => {
    const { service, ledger } = buildHarness();

    await service.recordPayment('c1', { amount, paidDate: '2026-01-20' });

    const debit = ledger.reduce((sum, e) => sum + Number(e.debit || 0), 0);
    const credit = ledger.reduce((sum, e) => sum + Number(e.credit || 0), 0);
    expect(debit).toBe(amount);
    expect(credit).toBe(amount);

    const welfare = ledger
      .filter((e) => e.accountId === 'acc-401')
      .reduce((sum, e) => sum + Number(e.credit || 0), 0);
    const serviceFee = ledger
      .filter((e) => e.accountId === 'acc-402')
      .reduce((sum, e) => sum + Number(e.credit || 0), 0);
    expect(welfare).toBe(expected.welfare);
    expect(serviceFee).toBe(expected.service);
  });

  it('ยอดเท่าเดิม ต้องใช้ใบเสร็จเดิมต่อ ไม่ออกใบที่สองให้เงินก้อนเดียว', async () => {
    const { service, prisma, receipts } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    prisma.receipt.create.mockClear();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-25' });

    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(receipts.size).toBe(1);
    expect(Array.from(receipts.values())[0].voidedAt).toBeNull();
  });

  it('audit log ของการแก้ยอดต้องบอกว่ายกเลิกใบไหนไป', async () => {
    const auditLog = { log: jest.fn() };
    const { service, receipts } = buildHarness({ auditLog });
    const actor = { id: 'u1', role: 'ADMIN', schoolId: 'school-1' } as any;

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' }, actor);
    const oldReceiptNo = Array.from(receipts.values())[0].receiptNo;

    auditLog.log.mockClear();
    await service.recordPayment('c1', { amount: 50, paidDate: '2026-01-20' }, actor);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({
        metadata: expect.objectContaining({
          voidedReceiptNo: oldReceiptNo,
          voidedAmount: 105,
        }),
      }),
    );
  });
});
