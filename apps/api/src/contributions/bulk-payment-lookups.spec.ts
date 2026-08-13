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
 * I4: settleContribution เคยหาผังบัญชี (4 findFirst) และบัญชีธนาคารเริ่มต้น (2 query)
 * ใหม่ทุกครั้งที่ออกใบเสร็จ พอถูกเรียกในลูปของการอัปโหลด/ลงชำระทีละหลายคน
 * ไฟล์ 620 แถวจึงยิงคำสั่งเดิมซ้ำ 620 รอบ (~3,700 query ต่อหนึ่ง request)
 *
 * ผังบัญชีกับบัญชีธนาคารต้องถูกหามาครั้งเดียวต่อหนึ่งรอบงาน แล้วส่งต่อเข้าไปในลูป
 * โดยที่ผลทางบัญชีและด่านตรวจ (ผังบัญชีไม่ครบต้อง throw ก่อนเขียนอะไร) ต้องเหมือนเดิมทุกอย่าง
 */

const ACCOUNT_CODES = ['101', '102', '401', '402'];

function contributionRow(id: string) {
  return {
    id,
    schoolId: 'school-1',
    memberId: `member-${id}`,
    welfareAmount: 100,
    serviceAmount: 5,
    totalAmount: 105,
    paidAmount: 0,
    paidDate: null,
    receiptId: null,
    period: { id: 'p1', isClosed: false, year: 2026, month: 1 },
    member: {
      id: `member-${id}`,
      groupId: null,
      memberNo: id.toUpperCase(),
      associationMember: { firstName: 'ก', lastName: 'ข' },
    },
  };
}

function buildHarness() {
  let seq = 0;

  const prisma: any = {
    contributionPeriod: {
      findUnique: jest.fn().mockResolvedValue({
        id: 'p1',
        year: 2026,
        month: 1,
        isClosed: false,
        welfareRate: 100,
        serviceFee: 5,
      }),
    },
    memberContribution: {
      findUnique: jest.fn(async ({ where }: any) => contributionRow(where.id)),
      update: jest.fn(async ({ where }: any) => ({ id: where.id })),
      create: jest.fn(async ({ data }: any) => ({ ...contributionRow('c-new'), ...data })),
    },
    member: {
      findFirst: jest.fn(async ({ where }: any) => ({
        id: `member-${where.memberNo}`,
        memberNo: where.memberNo,
        schoolId: 'school-1',
        associationMember: { firstName: 'ก', lastName: 'ข' },
        contributions: [contributionRow(`c-${where.memberNo}`)],
      })),
    },
    receipt: {
      create: jest.fn(async ({ data }: any) => ({ id: `receipt-${++seq}`, ...data })),
      findUnique: jest.fn().mockResolvedValue(null),
    },
    ledgerEntry: { createMany: jest.fn().mockResolvedValue({ count: 3 }) },
    bankAccount: { findUnique: jest.fn().mockResolvedValue({ id: 'bank-1' }) },
    account: {
      findFirst: jest.fn(async ({ where }: any) => ({ id: `acc-${where.code}`, code: where.code })),
    },
    $transaction: jest.fn(async (fn: any) => fn(prisma)),
  };

  const findDefault = jest.fn().mockResolvedValue({ id: 'bank-1' });

  const service = new ContributionsService(
    prisma as unknown as PrismaService,
    {} as MembersService,
    { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
    {
      generateNumber: jest.fn().mockImplementation(async () => `R202601-M000${++seq}`),
    } as unknown as DocumentNumberService,
    { findDefault } as unknown as BankAccountsService,
    {
      assertSchoolAccess: jest.fn(),
      assertGroupLeaderCanPay: jest.fn(),
      resolveSchoolId: jest.fn().mockReturnValue(undefined),
    } as unknown as SchoolScopeService,
    { log: jest.fn() } as unknown as AuditLogService,
    {
      isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
      effectiveServiceFee: jest.fn((fee: number) => fee),
    } as unknown as AppSettingsService,
  );

  return { service, prisma, findDefault };
}

describe('ContributionsService.batchRecordPayments — หาผังบัญชีครั้งเดียวต่อรอบ', () => {
  const PAYMENTS = [
    { contributionId: 'c1', amount: 105, paidDate: '2026-01-20' },
    { contributionId: 'c2', amount: 105, paidDate: '2026-01-20' },
    { contributionId: 'c3', amount: 105, paidDate: '2026-01-20' },
  ];

  it('ลงชำระ 3 รายการ ต้องหาผังบัญชีรอบเดียว ไม่ใช่รายการละรอบ', async () => {
    const { service, prisma, findDefault } = buildHarness();

    const result = await service.batchRecordPayments(PAYMENTS);

    expect(result.success).toBe(3);
    // 4 รหัสบัญชี × 1 รอบ ไม่ใช่ 4 × 3
    expect(prisma.account.findFirst).toHaveBeenCalledTimes(ACCOUNT_CODES.length);
    expect(findDefault).toHaveBeenCalledTimes(1);
    expect(prisma.bankAccount.findUnique).toHaveBeenCalledTimes(1);
  });

  it('ยังออกใบเสร็จและลงบัญชีครบทุกรายการเหมือนเดิม', async () => {
    const { service, prisma } = buildHarness();

    await service.batchRecordPayments(PAYMENTS);

    expect(prisma.receipt.create).toHaveBeenCalledTimes(3);
    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(3);
    // บัญชีธนาคารเริ่มต้นที่หามารอบเดียว ต้องถูกใช้กับทุกใบเสร็จ
    for (const call of prisma.receipt.create.mock.calls) {
      expect(call[0].data.bankAccountId).toBe('bank-1');
    }
  });

  it('ผังบัญชีไม่ครบ ยังต้องล้มทุกรายการโดยไม่เขียนอะไรลงฐานข้อมูล', async () => {
    const { service, prisma } = buildHarness();
    prisma.account.findFirst.mockResolvedValue(null);

    const result = await service.batchRecordPayments(PAYMENTS);

    expect(result.success).toBe(0);
    expect(result.failed).toBe(3);
    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });
});

describe('ContributionsService.processPaymentUpload — หาผังบัญชีครั้งเดียวต่อไฟล์', () => {
  const ROWS = [
    { เลขสมาชิก: 'M0001', สถานะ: 'ชำระแล้ว', ยอดที่ต้องชำระ: 105 },
    { เลขสมาชิก: 'M0002', สถานะ: 'ชำระแล้ว', ยอดที่ต้องชำระ: 105 },
    { เลขสมาชิก: 'M0003', สถานะ: 'ชำระแล้ว', ยอดที่ต้องชำระ: 105 },
  ];

  it('อัปโหลด 3 แถว ต้องหาผังบัญชีรอบเดียว ไม่ใช่แถวละรอบ', async () => {
    const { service, prisma, findDefault } = buildHarness();

    const result = await service.processPaymentUpload(2026, 1, ROWS);

    expect(result.success).toBe(3);
    expect(prisma.account.findFirst).toHaveBeenCalledTimes(ACCOUNT_CODES.length);
    expect(findDefault).toHaveBeenCalledTimes(1);
    expect(prisma.bankAccount.findUnique).toHaveBeenCalledTimes(1);
    expect(prisma.receipt.create).toHaveBeenCalledTimes(3);
  });

  it('ผังบัญชีไม่ครบ ทุกแถวต้องล้มโดยไม่ออกใบเสร็จ', async () => {
    const { service, prisma } = buildHarness();
    prisma.account.findFirst.mockResolvedValue(null);

    const result = await service.processPaymentUpload(2026, 1, ROWS);

    expect(result.success).toBe(0);
    expect(result.failed).toBe(3);
    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();
  });
});

describe('ContributionsService.recordPayment — ทางลงชำระรายคนยังหาผังบัญชีเองเหมือนเดิม', () => {
  it('ไม่ได้รับผังบัญชีมาจากผู้เรียก ต้องหาเองครบทุกรหัส', async () => {
    const { service, prisma, findDefault } = buildHarness();

    await service.recordPayment('c1', { amount: 105, paidDate: '2026-01-20' });

    expect(prisma.account.findFirst).toHaveBeenCalledTimes(ACCOUNT_CODES.length);
    expect(findDefault).toHaveBeenCalledTimes(1);
    expect(prisma.receipt.create).toHaveBeenCalledTimes(1);
  });
});
