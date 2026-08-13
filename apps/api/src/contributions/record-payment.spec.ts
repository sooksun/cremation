import { BadRequestException, Logger } from '@nestjs/common';
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
 * การลงชำระเงินมี 3 ทาง (อัปโหลด Excel / ตาราง 12 เดือน / หน้างวดรายคน)
 * ทั้งสามต้องทิ้งร่องรอยทางบัญชีเหมือนกัน ไม่งั้นเงินที่ลงจากบางหน้าจะหายจากรายงาน
 */
describe('ContributionsService.recordPayment — ต้องออกใบเสร็จและลงบัญชีเหมือนทางอื่น', () => {
  let service: ContributionsService;
  let prisma: any;
  let membershipRules: { resetArrearsTracking: jest.Mock };

  const CONTRIBUTION = {
    id: 'c1',
    schoolId: 'school-1',
    memberId: 'member-1',
    welfareAmount: 100,
    serviceAmount: 5,
    totalAmount: 105,
    paidAmount: 0,
    receiptId: null,
    period: { id: 'p1', isClosed: false, year: 2026, month: 1 },
    member: { groupId: null, memberNo: 'M0001', associationMember: { firstName: 'ก', lastName: 'ข' } },
  };

  beforeEach(() => {
    prisma = {
      memberContribution: {
        findUnique: jest.fn().mockResolvedValue(CONTRIBUTION),
        update: jest.fn().mockResolvedValue({ id: 'c1' }),
      },
      contributionPeriod: { findUnique: jest.fn() },
      receipt: {
        create: jest.fn().mockResolvedValue({ id: 'receipt-1' }),
        findUnique: jest.fn().mockResolvedValue(null),
        delete: jest.fn(),
      },
      ledgerEntry: { createMany: jest.fn().mockResolvedValue({ count: 3 }), deleteMany: jest.fn() },
      cashBook: { deleteMany: jest.fn() },
      bankAccount: { findUnique: jest.fn().mockResolvedValue({ id: 'bank-1' }) },
      account: {
        findFirst: jest.fn().mockImplementation(({ where }: any) =>
          Promise.resolve({ id: `acc-${where.code}`, code: where.code }),
        ),
      },
      $transaction: jest.fn().mockImplementation((fn: any) => fn(prisma)),
    };

    membershipRules = { resetArrearsTracking: jest.fn() };

    service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      membershipRules as unknown as MembershipRulesService,
      { generateNumber: jest.fn().mockResolvedValue('R202601-M0001') } as unknown as DocumentNumberService,
      { findDefault: jest.fn().mockResolvedValue({ id: 'bank-1' }) } as unknown as BankAccountsService,
      { assertSchoolAccess: jest.fn(), assertGroupLeaderCanPay: jest.fn() } as unknown as SchoolScopeService,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
        effectiveServiceFee: jest.fn((fee: number) => fee),
      } as unknown as AppSettingsService,
    );
  });

  it('ออกใบเสร็จและผูกกับรายการเมื่อบันทึกชำระ', async () => {
    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(prisma.receipt.create).toHaveBeenCalledTimes(1);
    expect(prisma.memberContribution.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ paidAmount: 105, receiptId: 'receipt-1', isArrears: false }),
      }),
    );
  });

  it('ลงรายการบัญชีแยกประเภทคู่กับใบเสร็จ', async () => {
    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(1);
  });

  it('ไม่ออกใบเสร็จซ้ำถ้ารายการมีใบเสร็จอยู่แล้ว', async () => {
    prisma.memberContribution.findUnique.mockResolvedValue({ ...CONTRIBUTION, receiptId: 'existing' });

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(prisma.receipt.create).not.toHaveBeenCalled();
  });

  it('ยกเลิกการชำระแล้วต้องกลับไปเป็นค้างชำระ เหมือนทาง batch', async () => {
    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' });

    expect(prisma.memberContribution.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ paidAmount: 0, paidDate: null, receiptId: null, isArrears: true }),
      }),
    );
    expect(prisma.receipt.create).not.toHaveBeenCalled();
  });

  it('ไม่ระบุวันที่ชำระสำหรับงวดย้อนหลัง ให้ลงเป็นสิ้นเดือนของงวดนั้น ไม่ใช่วันนี้', async () => {
    await service.recordPayment('c1', { amount: 105 } as never);

    const receiptDate: Date = prisma.receipt.create.mock.calls[0][0].data.date;
    expect(receiptDate.getFullYear()).toBe(2026);
    expect(receiptDate.getMonth()).toBe(0); // มกราคม
  });

  it('ผังบัญชีไม่ครบ ต้องปฏิเสธ ไม่ใช่ออกใบเสร็จแล้วข้ามการลงบัญชีเงียบ ๆ', async () => {
    prisma.account.findFirst.mockResolvedValue(null);

    await expect(
      service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' }),
    ).rejects.toThrow(BadRequestException);

    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });

  it('ยอดติดลบต้องถูกปฏิเสธ ไม่ใช่ออกใบเสร็จติดลบ', async () => {
    await expect(
      service.recordPayment('c1', { amount: -500, paidDate: '2026-01-20' }),
    ).rejects.toThrow(BadRequestException);

    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });

  it('ยอดที่ไม่ใช่ตัวเลข (NaN) ต้องถูกปฏิเสธ ไม่ใช่ไหลไปเข้าทางยกเลิกการชำระ', async () => {
    await expect(
      service.recordPayment('c1', { amount: Number('1,050'), paidDate: '2026-01-20' }),
    ).rejects.toThrow(BadRequestException);

    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });

  /**
   * I2: รับไม่ครบยอดเรียกเก็บ = ยังค้างอยู่
   * ถ้าล้างธงค้างชำระตามยอดที่รับมาเท่าไรก็ได้ สมาชิกจะขึ้นว่า "ชำระแล้ว"
   * และหลุดจากรายงานค้างชำระ ทั้งที่ยอดรวมของงวดยังขาดอยู่
   */
  it('รับไม่ครบยอดที่เรียกเก็บ ต้องยังคงเป็นค้างชำระ', async () => {
    await service.recordPayment('c1', { amount: 50, paidDate: '2026-01-20' });

    expect(prisma.memberContribution.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ paidAmount: 50, isArrears: true }),
      }),
    );
  });

  it('รับไม่ครบยอดที่เรียกเก็บ ต้องไม่ล้างการนับเดือนค้างชำระของสมาชิก', async () => {
    await service.recordPayment('c1', { amount: 50, paidDate: '2026-01-20' });

    expect(membershipRules.resetArrearsTracking).not.toHaveBeenCalled();
  });

  it('รับครบยอดที่เรียกเก็บ ยังต้องล้างการนับเดือนค้างชำระเหมือนเดิม', async () => {
    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(membershipRules.resetArrearsTracking).toHaveBeenCalledWith('member-1');
  });

  /**
   * I3: รับเกินยอดเรียกเก็บ ส่วนเกินจะถูกลงเป็นรายได้เงินสงเคราะห์ทั้งก้อนโดยไม่มีเพดาน
   * พิมพ์ 2000 แทน 105 จึงออกใบเสร็จ 2,000 บาทและบัญชียังดุล — ต้องปฏิเสธตั้งแต่แรก
   */
  it('รับเกินยอดที่เรียกเก็บต้องถูกปฏิเสธ ไม่ใช่ลงส่วนเกินเป็นรายได้เงินสงเคราะห์', async () => {
    await expect(
      service.recordPayment('c1', { amount: 2000, paidDate: '2026-01-20' }),
    ).rejects.toThrow(BadRequestException);

    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });

  it('ข้อความปฏิเสธยอดเกินต้องบอกทั้งยอดที่รับและยอดที่เรียกเก็บ', async () => {
    await expect(
      service.recordPayment('c1', { amount: 2000, paidDate: '2026-01-20' }),
    ).rejects.toThrow(/2,000\.00.*105\.00/);
  });
});

/**
 * I5: การหาบัญชีธนาคารเริ่มต้นเคยถูกห่อด้วย catch {} เปล่า ๆ
 * ถ้าพัง ใบเสร็จจะออกโดยไม่มีบัญชีธนาคารผูกอยู่ และไม่มีใครรู้เลยว่าทำไม
 * พฤติกรรมยังเหมือนเดิม (คืน undefined ออกใบเสร็จต่อได้) แต่ต้องมีร่องรอยใน log
 */
describe('ContributionsService — หาบัญชีธนาคารเริ่มต้นไม่สำเร็จ ต้องไม่เงียบ', () => {
  function buildService(findDefault: jest.Mock) {
    const prisma: any = {
      memberContribution: {
        findUnique: jest.fn().mockResolvedValue({
          id: 'c1',
          schoolId: 'school-1',
          memberId: 'member-1',
          welfareAmount: 100,
          serviceAmount: 5,
          totalAmount: 105,
          paidAmount: 0,
          receiptId: null,
          period: { id: 'p1', isClosed: false, year: 2026, month: 1 },
          member: { groupId: null, memberNo: 'M0001', associationMember: { firstName: 'ก', lastName: 'ข' } },
        }),
        update: jest.fn().mockResolvedValue({ id: 'c1' }),
      },
      receipt: { create: jest.fn().mockResolvedValue({ id: 'receipt-1' }), findUnique: jest.fn() },
      ledgerEntry: { createMany: jest.fn().mockResolvedValue({ count: 3 }) },
      bankAccount: { findUnique: jest.fn() },
      account: {
        findFirst: jest.fn().mockImplementation(({ where }: any) =>
          Promise.resolve({ id: `acc-${where.code}`, code: where.code }),
        ),
      },
      $transaction: jest.fn().mockImplementation((fn: any) => fn(prisma)),
    };

    const service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
      { generateNumber: jest.fn().mockResolvedValue('R202601-M0001') } as unknown as DocumentNumberService,
      { findDefault } as unknown as BankAccountsService,
      { assertSchoolAccess: jest.fn(), assertGroupLeaderCanPay: jest.fn() } as unknown as SchoolScopeService,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
        effectiveServiceFee: jest.fn((fee: number) => fee),
      } as unknown as AppSettingsService,
    );

    return { service, prisma };
  }

  let logError: jest.SpyInstance;

  beforeEach(() => {
    logError = jest.spyOn(Logger.prototype, 'error').mockImplementation(() => undefined);
  });

  afterEach(() => {
    logError.mockRestore();
  });

  it('findDefault ที่ throw ต้องไม่ทำให้การบันทึกล้ม แต่ต้องถูกเขียนลง log', async () => {
    const findDefault = jest.fn().mockRejectedValue(new Error('bank lookup exploded'));
    const { service, prisma } = buildService(findDefault);

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    // พฤติกรรมเดิม: ยังออกใบเสร็จได้ เพียงแต่ไม่ผูกบัญชีธนาคาร
    expect(prisma.receipt.create).toHaveBeenCalledTimes(1);
    expect(prisma.receipt.create.mock.calls[0][0].data.bankAccountId).toBeUndefined();

    // ต้องมีร่องรอยว่าทำไมใบเสร็จถึงไม่มีบัญชีธนาคาร
    expect(logError).toHaveBeenCalledTimes(1);
    expect(String(logError.mock.calls[0][0])).toContain('bank lookup exploded');
  });

  it('การค้นหาที่สำเร็จต้องไม่เขียน log ผิดพลาด และยังผูกบัญชีธนาคารเหมือนเดิม', async () => {
    const findDefault = jest.fn().mockResolvedValue({ id: 'bank-1' });
    const { service, prisma } = buildService(findDefault);
    prisma.bankAccount.findUnique.mockResolvedValue({ id: 'bank-1' });

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(prisma.receipt.create.mock.calls[0][0].data.bankAccountId).toBe('bank-1');
    expect(logError).not.toHaveBeenCalled();
  });
});

/**
 * C1: ถ้ายกเลิกการชำระแล้วปล่อยใบเสร็จกับรายการบัญชีค้างไว้ เงินที่ยกเลิกจะอยู่ในรายงานตลอดไป
 * แล้วการกดชำระซ้ำจะออกใบเสร็จใบที่สอง กลายเป็น 210 บาทจากการจ่ายจริง 105 บาท
 *
 * ใบเสร็จที่ยกเลิกจึงคงแถวไว้แต่ทำเครื่องหมาย voidedAt (กันเลขที่ถูกออกซ้ำ)
 * ส่วนรายการบัญชีของใบนั้นต้องหายไป — รายละเอียดการยกเลิกอยู่ที่ void-receipt.spec.ts
 */
describe('ContributionsService.recordPayment — ชำระ → ยกเลิก → ชำระใหม่', () => {
  function buildStatefulPrisma() {
    const receipts = new Map<string, any>();
    const ledger: any[] = [];
    let seq = 0;

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
          receipts.set(id, { id, ...data });
          return { id, ...data };
        }),
        findUnique: jest.fn(async ({ where }: any) => {
          const row = receipts.get(where.id);
          if (!row) return null;
          return {
            id: row.id,
            type: row.type,
            amount: row.amount,
            voidedAt: row.voidedAt ?? null,
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
      cashBook: { deleteMany: jest.fn(async () => ({ count: 0 })) },
      bankAccount: { findUnique: jest.fn(async () => ({ id: 'bank-1' })) },
      account: {
        findFirst: jest.fn(async ({ where }: any) => ({ id: `acc-${where.code}`, code: where.code })),
      },
      $transaction: jest.fn(async (fn: any) => fn(prisma)),
    };

    return { prisma, receipts, ledger, contribution };
  }

  it('ต้องเหลือใบเสร็จที่ใช้ได้ใบเดียวและรายการบัญชีชุดเดียวที่ดุล', async () => {
    const { prisma, receipts, ledger, contribution } = buildStatefulPrisma();

    const service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
      {
        generateNumber: jest.fn().mockResolvedValue('R202601-M0001'),
      } as unknown as DocumentNumberService,
      { findDefault: jest.fn().mockResolvedValue({ id: 'bank-1' }) } as unknown as BankAccountsService,
      { assertSchoolAccess: jest.fn(), assertGroupLeaderCanPay: jest.fn() } as unknown as SchoolScopeService,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
        effectiveServiceFee: jest.fn((fee: number) => fee),
      } as unknown as AppSettingsService,
    );

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });
    await service.recordPayment('c1', { amount: 0, paidDate: '2026-01-20' });

    // ยกเลิกแล้วต้องไม่เหลือใบเสร็จที่ใช้ได้หรือรายการบัญชีค้างอยู่ในระบบ
    const usable = () => Array.from(receipts.values()).filter((r) => !r.voidedAt);
    expect(usable()).toHaveLength(0);
    expect(ledger).toHaveLength(0);
    expect(contribution.receiptId).toBeNull();
    expect(contribution.isArrears).toBe(true);

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(usable()).toHaveLength(1);
    const receiptId = usable()[0].id;
    expect(contribution.receiptId).toBe(receiptId);
    expect(Number(receipts.get(receiptId).amount)).toBe(105);

    expect(ledger).toHaveLength(3);
    expect(ledger.every((entry) => entry.receiptId === receiptId)).toBe(true);
    const debit = ledger.reduce((sum, entry) => sum + Number(entry.debit || 0), 0);
    const credit = ledger.reduce((sum, entry) => sum + Number(entry.credit || 0), 0);
    expect(debit).toBe(105);
    expect(credit).toBe(105);
  });
});
