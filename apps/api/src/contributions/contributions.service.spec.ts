import { BadRequestException, NotFoundException } from '@nestjs/common';
import { Role } from '@prisma/client';
import { ContributionsService } from './contributions.service';
import { parsePaymentFile } from './payment-file.parser';
import { buildWorkbookBuffer } from './payment-workbook';
import { PrismaService } from '../prisma/prisma.service';
import { MembersService } from '../members/members.service';
import { MembershipRulesService } from '../members/membership-rules.service';
import { DocumentNumberService } from '../common/document-number.service';
import { BankAccountsService } from '../bank-accounts/bank-accounts.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AuditLogService } from '../common/services/audit-log.service';
import { AppSettingsService } from '../common/services/app-settings.service';

describe('ContributionsService', () => {
  let service: ContributionsService;
  let prisma: {
    memberContribution: { findUnique: jest.Mock; update: jest.Mock };
    contributionPeriod: { findUnique: jest.Mock };
  };

  beforeEach(() => {
    prisma = {
      memberContribution: {
        findUnique: jest.fn(),
        update: jest.fn(),
      },
      contributionPeriod: {
        findUnique: jest.fn(),
      },
    };

    const schoolScope = {
      assertSchoolAccess: jest.fn(),
      assertGroupLeaderCanPay: jest.fn(),
    } as unknown as SchoolScopeService;

    service = new ContributionsService(
      prisma as unknown as PrismaService,
      {} as MembersService,
      { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
      {} as DocumentNumberService,
      {} as BankAccountsService,
      schoolScope,
      { log: jest.fn() } as unknown as AuditLogService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(false),
        effectiveServiceFee: jest.fn((_fee: number, enabled: boolean) => (enabled ? _fee : 0)),
      } as unknown as AppSettingsService,
    );
  });

  describe('recordPayment', () => {
    it('throws NotFoundException when contribution does not exist', async () => {
      prisma.memberContribution.findUnique.mockResolvedValue(null);

      await expect(
        service.recordPayment('missing', {
          amount: 100,
          paidDate: '2026-01-15',
        }),
      ).rejects.toThrow(NotFoundException);
    });

    it('throws BadRequestException when period is closed', async () => {
      prisma.memberContribution.findUnique.mockResolvedValue({
        id: 'c1',
        schoolId: 'school-1',
        period: { isClosed: true, year: 2026, month: 1 },
        member: { groupId: 'group-1' },
      });

      await expect(
        service.recordPayment('c1', {
          amount: 100,
          paidDate: '2026-01-15',
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('updatePeriod', () => {
    it('throws BadRequestException when trying to update a closed period', async () => {
      prisma.contributionPeriod.findUnique.mockResolvedValue({
        id: 'p1',
        isClosed: true,
        year: 2026,
        month: 1,
      });

      await expect(
        service.updatePeriod('p1', { welfareRate: 25 }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});

const OPEN_PERIOD = {
  id: 'p1',
  year: 2026,
  month: 8,
  isClosed: false,
  welfareRate: 100,
  serviceFee: 0,
};

type UploadPrismaMock = {
  contributionPeriod: { findUnique: jest.Mock };
  member: { findFirst: jest.Mock; findMany: jest.Mock };
  memberContribution: { update: jest.Mock; create: jest.Mock };
  receipt: { create: jest.Mock; update: jest.Mock; delete: jest.Mock };
  ledgerEntry: { createMany: jest.Mock; deleteMany: jest.Mock };
  account: { findFirst: jest.Mock };
};

function buildService(resolveSchoolId = jest.fn().mockReturnValue(undefined)) {
  const prisma: UploadPrismaMock = {
    contributionPeriod: { findUnique: jest.fn().mockResolvedValue(OPEN_PERIOD) },
    member: { findFirst: jest.fn(), findMany: jest.fn().mockResolvedValue([]) },
    memberContribution: { update: jest.fn(), create: jest.fn() },
    receipt: { create: jest.fn(), update: jest.fn(), delete: jest.fn() },
    ledgerEntry: { createMany: jest.fn(), deleteMany: jest.fn() },
    account: { findFirst: jest.fn().mockResolvedValue(null) },
  };

  const service = new ContributionsService(
    prisma as unknown as PrismaService,
    {} as MembersService,
    { resetArrearsTracking: jest.fn() } as unknown as MembershipRulesService,
    { generateNumber: jest.fn().mockResolvedValue('R202608-M0001') } as unknown as DocumentNumberService,
    { findDefault: jest.fn().mockResolvedValue(null) } as unknown as BankAccountsService,
    {
      assertSchoolAccess: jest.fn(),
      assertGroupLeaderCanPay: jest.fn(),
      resolveSchoolId,
    } as unknown as SchoolScopeService,
    { log: jest.fn() } as unknown as AuditLogService,
    {
      isServiceFeeEnabled: jest.fn().mockResolvedValue(false),
      effectiveServiceFee: jest.fn((fee: number, enabled: boolean) => (enabled ? fee : 0)),
    } as unknown as AppSettingsService,
  );

  return { service, prisma, resolveSchoolId };
}

describe('ContributionsService.processPaymentUpload', () => {
  function memberWith(contribution: Record<string, unknown> | null) {
    return {
      id: 'm1',
      memberNo: 'M0001',
      schoolId: 's1',
      associationMember: { firstName: 'สมชาย', lastName: 'ใจดี' },
      contributions: contribution ? [contribution] : [],
    };
  }

  it('แถวที่บอกว่ายังไม่ชำระ ห้ามล้างการชำระของคนที่จ่ายไปแล้ว ใบเสร็จและบัญชีต้องอยู่ครบ', async () => {
    const { service, prisma } = buildService();
    prisma.member.findFirst.mockResolvedValue(
      memberWith({
        id: 'c1',
        totalAmount: 100,
        welfareAmount: 100,
        serviceAmount: 0,
        paidAmount: 100,
        paidDate: new Date('2026-08-05'),
        receiptId: 'r1',
      }),
    );

    const result = await service.processPaymentUpload(2026, 8, [
      { เลขสมาชิก: 'M0001', สถานะ: 'ยังไม่ชำระ' },
    ]);

    // ไม่มีการเขียนทับ contribution แปลว่า paidAmount / paidDate / receiptId เดิมยังอยู่
    expect(prisma.memberContribution.update).not.toHaveBeenCalled();
    // ใบเสร็จและรายการบัญชีที่ออกไปแล้วต้องไม่ถูกแตะเลย
    expect(prisma.receipt.delete).not.toHaveBeenCalled();
    expect(prisma.receipt.update).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.deleteMany).not.toHaveBeenCalled();
    expect(prisma.ledgerEntry.createMany).not.toHaveBeenCalled();

    expect(result.alreadyPaid).toBe(1);
    expect(result.failed).toBe(0);
    expect(result.errors).toEqual([]);
  });

  it('แถวที่ยังไม่ชำระของคนที่ยังไม่จ่าย ยังบันทึกเป็นยังไม่ชำระเหมือนเดิม', async () => {
    const { service, prisma } = buildService();
    prisma.member.findFirst.mockResolvedValue(
      memberWith({
        id: 'c1',
        totalAmount: 100,
        welfareAmount: 100,
        serviceAmount: 0,
        paidAmount: 0,
        paidDate: null,
        receiptId: null,
      }),
    );

    const result = await service.processPaymentUpload(2026, 8, [
      { เลขสมาชิก: 'M0001', สถานะ: 'ยังไม่ชำระ' },
    ]);

    expect(prisma.memberContribution.update).toHaveBeenCalledWith({
      where: { id: 'c1' },
      data: { paidAmount: 0, paidDate: null, receiptId: null, isArrears: false },
    });
    expect(result.success).toBe(1);
    expect(result.alreadyPaid).toBe(0);
  });
});

describe('ContributionsService.generatePaymentTemplate', () => {
  it('ตัดรายชื่อตามโรงเรียนของผู้เรียกที่ถูกบังคับขอบเขต', async () => {
    const resolveSchoolId = jest.fn().mockReturnValue('s9');
    const { service, prisma } = buildService(resolveSchoolId);

    await service.generatePaymentTemplate(2026, 8, {
      id: 'u2',
      role: Role.SCHOOL_ADMIN,
      schoolId: 's9',
    });

    expect(resolveSchoolId).toHaveBeenCalled();
    expect(prisma.member.findMany.mock.calls[0][0].where).toMatchObject({ schoolId: 's9' });
  });

  it('ADMIN ที่เข้าถึงได้ทุกโรงเรียน ไม่ถูกใส่ตัวกรอง schoolId', async () => {
    const resolveSchoolId = jest.fn().mockReturnValue(undefined);
    const { service, prisma } = buildService(resolveSchoolId);

    await service.generatePaymentTemplate(2026, 8, { id: 'u1', role: Role.ADMIN });

    expect(prisma.member.findMany.mock.calls[0][0].where.schoolId).toBeUndefined();
  });

  it('ไฟล์ที่สร้างจาก template อ่านกลับด้วย parsePaymentFile ได้ครบ (ปิดลูป ดาวน์โหลด→อัปโหลด)', async () => {
    const { service, prisma } = buildService();
    prisma.member.findMany.mockResolvedValue([
      {
        memberNo: 'M0001',
        salaryDeduction: true,
        school: { code: 'SCH_001', name: 'ร.ร.ทดสอบ' },
        associationMember: {
          firstName: 'สมชาย',
          lastName: 'ใจดี',
          memberType: { name: 'สามัญ' },
        },
        contributions: [{ id: 'c1', totalAmount: 120, paidAmount: 120 }],
      },
      {
        memberNo: 'M0002',
        salaryDeduction: false,
        school: { code: 'SCH_001', name: 'ร.ร.ทดสอบ' },
        associationMember: {
          firstName: 'สมหญิง',
          lastName: 'ใจงาม',
          memberType: { name: 'สามัญ' },
        },
        contributions: [],
      },
    ]);

    const template = await service.generatePaymentTemplate(2026, 8);
    const parsed = parsePaymentFile(buildWorkbookBuffer('รายชื่อเก็บเงิน', template.members));

    expect(parsed.rows).toEqual([
      { rowNo: 2, memberNo: 'M0001', isPaid: true, amount: 120 },
      { rowNo: 3, memberNo: 'M0002', isPaid: false, amount: 100 },
    ]);
  });
});