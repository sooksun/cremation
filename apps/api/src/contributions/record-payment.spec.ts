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
      receipt: { create: jest.fn().mockResolvedValue({ id: 'receipt-1' }) },
      ledgerEntry: { createMany: jest.fn().mockResolvedValue({ count: 3 }) },
      bankAccount: { findUnique: jest.fn().mockResolvedValue({ id: 'bank-1' }) },
      account: {
        findFirst: jest.fn().mockImplementation(({ where }: any) =>
          Promise.resolve({ id: `acc-${where.code}`, code: where.code }),
        ),
      },
    };

    service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
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
});
