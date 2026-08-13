import { BadRequestException, ForbiddenException } from '@nestjs/common';
import { Role } from '@prisma/client';
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
 * ทางอัปโหลด Excel สร้างรายการให้เองเมื่อสมาชิกยังไม่มีรายการของงวดนั้น
 * การลงรายคนก็ต้องทำได้เหมือนกัน ไม่ใช่เงียบไปเฉย ๆ
 */
describe('ContributionsService.payMemberForPeriod', () => {
  let service: ContributionsService;
  let prisma: any;
  let schoolScope: SchoolScopeService;

  const PERIOD = { id: 'p1', year: 2026, month: 1, isClosed: false, welfareRate: 100, serviceFee: 5 };
  const MEMBER = {
    id: 'member-1',
    memberNo: 'M0001',
    schoolId: 'school-1',
    groupId: 'group-1',
    associationMember: { firstName: 'ก', lastName: 'ข' },
  };

  beforeEach(() => {
    prisma = {
      contributionPeriod: { findUnique: jest.fn().mockResolvedValue(PERIOD) },
      member: { findUnique: jest.fn().mockResolvedValue(MEMBER) },
      memberContribution: {
        findUnique: jest.fn().mockResolvedValue(null),
        create: jest.fn().mockImplementation(({ data }: any) =>
          Promise.resolve({ id: 'new-c', receiptId: null, paidAmount: 0, ...data }),
        ),
        update: jest.fn().mockResolvedValue({ id: 'new-c' }),
      },
      receipt: {
        create: jest.fn().mockResolvedValue({ id: 'receipt-1' }),
        findUnique: jest.fn().mockResolvedValue(null),
        delete: jest.fn(),
      },
      ledgerEntry: { createMany: jest.fn().mockResolvedValue({ count: 3 }), deleteMany: jest.fn() },
      cashBook: { deleteMany: jest.fn() },
      bankAccount: { findUnique: jest.fn().mockResolvedValue(null) },
      // ผังบัญชีต้องมีจริง ไม่งั้นบล็อกลงบัญชีจะไม่ถูกรัน แล้วเทสต์ชุดนี้จะเขียวทั้งที่ลบการลงบัญชีทิ้ง
      account: {
        findFirst: jest.fn().mockImplementation(({ where }: any) =>
          Promise.resolve({ id: `acc-${where.code}`, code: where.code }),
        ),
      },
      $transaction: jest.fn().mockImplementation((fn: any) => fn(prisma)),
    };

    schoolScope = {
      assertSchoolAccess: jest.fn(),
      assertGroupLeaderCanPay: jest.fn(),
    } as unknown as SchoolScopeService;

    service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
      { generateNumber: jest.fn().mockResolvedValue('R202601-M0001') } as unknown as DocumentNumberService,
      { findDefault: jest.fn().mockResolvedValue(null) } as unknown as BankAccountsService,
      schoolScope,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(true),
        effectiveServiceFee: jest.fn((fee: number) => fee),
      } as unknown as AppSettingsService,
    );
  });

  it('สร้างรายการของงวดให้อัตโนมัติเมื่อสมาชิกยังไม่มี แล้วบันทึกชำระ', async () => {
    await service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1' });

    expect(prisma.memberContribution.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          memberId: 'member-1',
          periodId: 'p1',
          schoolId: 'school-1',
          totalAmount: 105,
        }),
      }),
    );
    expect(prisma.receipt.create).toHaveBeenCalledTimes(1);
  });

  it('ลงบัญชีคู่ผูกกับใบเสร็จและยอดต้องดุล', async () => {
    await service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1' });

    expect(prisma.ledgerEntry.createMany).toHaveBeenCalledTimes(1);
    const entries = prisma.ledgerEntry.createMany.mock.calls[0][0].data;
    expect(entries.length).toBeGreaterThanOrEqual(2);
    expect(entries.every((e: any) => e.receiptId === 'receipt-1')).toBe(true);

    const debit = entries.reduce((sum: number, e: any) => sum + Number(e.debit || 0), 0);
    const credit = entries.reduce((sum: number, e: any) => sum + Number(e.credit || 0), 0);
    expect(debit).toBe(105);
    expect(credit).toBe(105);
  });

  it('ใช้รายการเดิมถ้ามีอยู่แล้ว ไม่สร้างซ้ำ', async () => {
    prisma.memberContribution.findUnique.mockResolvedValue({
      id: 'c1', schoolId: 'school-1', memberId: 'member-1',
      welfareAmount: 100, serviceAmount: 5, totalAmount: 105, paidAmount: 0, receiptId: null,
    });

    await service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1' });

    expect(prisma.memberContribution.create).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { id: 'c1' } }),
    );
  });

  it('งวดปิดแล้วต้องบันทึกไม่ได้', async () => {
    prisma.contributionPeriod.findUnique.mockResolvedValue({ ...PERIOD, isClosed: true });

    await expect(
      service.payMemberForPeriod({ memberId: 'member-1', periodId: 'p1' }),
    ).rejects.toThrow(BadRequestException);
  });

  it('หัวหน้ากลุ่มลงชำระให้สมาชิกนอกกลุ่มตัวเองไม่ได้', async () => {
    (schoolScope.assertGroupLeaderCanPay as jest.Mock).mockRejectedValue(
      new ForbiddenException('ไม่มีสิทธิ์บันทึกการชำระสำหรับสมาชิกนอกกลุ่มของคุณ'),
    );

    await expect(
      service.payMemberForPeriod(
        { memberId: 'member-1', periodId: 'p1' },
        { id: 'u1', role: Role.GROUP_LEADER, schoolId: 'school-1', groupId: 'group-other' },
      ),
    ).rejects.toThrow(ForbiddenException);

    expect(schoolScope.assertGroupLeaderCanPay).toHaveBeenCalledWith(
      expect.objectContaining({ role: Role.GROUP_LEADER }),
      { schoolId: 'school-1', member: { groupId: 'group-1' } },
    );
    // ต้องหยุดก่อนแตะเงิน
    expect(prisma.receipt.create).not.toHaveBeenCalled();
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
  });
});
