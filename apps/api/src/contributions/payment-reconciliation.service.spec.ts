import { MemberStatus, Role } from '@prisma/client';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import { PrismaService } from '../prisma/prisma.service';
import { SchoolScopeService } from '../common/security/school-scope.service';
import { AppSettingsService } from '../common/services/app-settings.service';
import type { ParsedPaymentFile } from './payment-file.parser';

const PERIOD = { id: 'p1', year: 2026, month: 8, isClosed: false, welfareRate: 100, serviceFee: 0 };

function member(overrides: {
  memberNo: string; schoolId: string; schoolCode: string; paidAmount?: number;
}) {
  return {
    id: `id-${overrides.memberNo}`,
    memberNo: overrides.memberNo,
    schoolId: overrides.schoolId,
    school: { id: overrides.schoolId, code: overrides.schoolCode, name: `ร.ร.${overrides.schoolCode}` },
    group: { name: 'กลุ่ม 1' },
    associationMember: { firstName: 'ชื่อ', lastName: overrides.memberNo },
    contributions: [
      { id: `c-${overrides.memberNo}`, totalAmount: 100, paidAmount: overrides.paidAmount ?? 0 },
    ],
  };
}

function parsed(rows: Array<{ rowNo: number; memberNo: string; isPaid: boolean }>): ParsedPaymentFile {
  return { rows, duplicates: [] };
}

describe('PaymentReconciliationService', () => {
  let service: PaymentReconciliationService;
  let prisma: {
    contributionPeriod: { findUnique: jest.Mock };
    member: { findMany: jest.Mock };
    memberContribution: { updateMany: jest.Mock; createMany: jest.Mock };
  };
  let resolveSchoolId: jest.Mock;

  beforeEach(() => {
    prisma = {
      contributionPeriod: { findUnique: jest.fn().mockResolvedValue(PERIOD) },
      member: { findMany: jest.fn() },
      memberContribution: { updateMany: jest.fn().mockResolvedValue({ count: 0 }), createMany: jest.fn() },
    };
    resolveSchoolId = jest.fn().mockReturnValue(undefined);

    service = new PaymentReconciliationService(
      prisma as unknown as PrismaService,
      { resolveSchoolId } as unknown as SchoolScopeService,
      {
        isServiceFeeEnabled: jest.fn().mockResolvedValue(false),
        effectiveServiceFee: jest.fn((fee: number, enabled: boolean) => (enabled ? fee : 0)),
      } as unknown as AppSettingsService,
    );
  });

  it('นับ expected เฉพาะโรงเรียนที่ปรากฏในไฟล์', async () => {
    // ครั้งแรก = หาสมาชิกจากเลขในไฟล์, ครั้งที่สอง = ดึง expected
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([
        member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
        member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' }),
      ]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      fullDistrict: false,
      autoMarkArrears: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toEqual({ in: ['s1'] });
    expect(result.summary.expected).toBe(2);
    expect(result.summary.paid).toBe(1);
    expect(result.summary.missingFromFile).toBe(1);
    expect(result.missing[0]).toMatchObject({ memberNo: 'M2', reason: 'NOT_IN_FILE', amountDue: 100 });
  });

  it('fullDistrict = true โดย ADMIN ดึงสมาชิกทุกโรงเรียน', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 })]);

    await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      actor: { id: 'u1', role: Role.ADMIN },
      fullDistrict: true,
      autoMarkArrears: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toBeUndefined();
  });

  it('SCHOOL_ADMIN ส่ง fullDistrict = true มา ก็ยังถูกบังคับที่โรงเรียนตัวเอง', async () => {
    resolveSchoolId.mockReturnValue('s9');
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(),
      actor: { id: 'u2', role: Role.SCHOOL_ADMIN, schoolId: 's9' },
      fullDistrict: true,
      autoMarkArrears: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.schoolId).toEqual({ in: ['s9'] });
    expect(result.scope.fullDistrict).toBe(false);
  });

  it('อยู่ในไฟล์แต่ยังไม่ชำระ ได้เหตุผล IN_FILE_NOT_PAID', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A' })]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: false }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
      autoMarkArrears: false,
    });

    expect(result.summary.inFileNotPaid).toBe(1);
    expect(result.missing[0].reason).toBe('IN_FILE_NOT_PAID');
  });

  it('คนที่ชำระอยู่ก่อนแล้วแต่ไม่มีในไฟล์ ไม่ถือว่าขาด', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([
        member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
        member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
      ]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(['M1']),
      fullDistrict: false,
      autoMarkArrears: false,
    });

    expect(result.summary.alreadyPaid).toBe(1);
    expect(result.summary.missingFromFile).toBe(0);
    expect(result.missing).toEqual([]);
  });

  it('เลขสมาชิกในไฟล์ที่ไม่มีในระบบ เข้ากอง unknown พร้อมเลขบรรทัด', async () => {
    prisma.member.findMany.mockResolvedValueOnce([]).mockResolvedValueOnce([]);

    const result = await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 7, memberNo: 'M9999', isPaid: true }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
      autoMarkArrears: false,
    });

    expect(result.summary.unknownInFile).toBe(1);
    expect(result.unknown).toEqual([{ rowNo: 7, memberNo: 'M9999' }]);
  });

  it('ดึง expected เฉพาะสมาชิกที่ยังมีสภาพ', async () => {
    prisma.member.findMany
      .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
      .mockResolvedValueOnce([]);

    await service.reconcile({
      periodId: 'p1',
      parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
      paidNowMemberNos: new Set(),
      fullDistrict: false,
      autoMarkArrears: false,
    });

    expect(prisma.member.findMany.mock.calls[1][0].where.status).toEqual({
      in: [MemberStatus.ACTIVE, MemberStatus.ARREARS],
    });
  });

  describe('autoMarkArrears', () => {
    it('ตั้ง isArrears เฉพาะ contribution ของคนที่ขาด ไม่ใช่ทั้งงวด', async () => {
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([
          member({ memberNo: 'M1', schoolId: 's1', schoolCode: 'A', paidAmount: 100 }),
          member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' }),
        ]);
      prisma.memberContribution.updateMany.mockResolvedValue({ count: 1 });

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(['M1']),
        fullDistrict: false,
        autoMarkArrears: true,
      });

      expect(prisma.memberContribution.updateMany).toHaveBeenCalledWith({
        where: { id: { in: ['c-M2'] }, paidAmount: 0 },
        data: { isArrears: true },
      });
      expect(result.summary.markedArrears).toBe(1);
    });

    it('สร้างแถว contribution ให้คนที่ขาดแต่ยังไม่มีแถวของงวดนั้น', async () => {
      const noContribution = member({ memberNo: 'M3', schoolId: 's1', schoolCode: 'A' });
      noContribution.contributions = [];
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([noContribution]);
      prisma.memberContribution.createMany.mockResolvedValue({ count: 1 });

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(),
        fullDistrict: false,
        autoMarkArrears: true,
      });

      expect(prisma.memberContribution.createMany).toHaveBeenCalledWith({
        data: [
          {
            memberId: 'id-M3',
            periodId: 'p1',
            schoolId: 's1',
            welfareAmount: 100,
            serviceAmount: 0,
            totalAmount: 100,
            paidAmount: 0,
            isArrears: true,
          },
        ],
      });
      expect(result.summary.markedArrears).toBe(1);
    });

    it('autoMarkArrears = false ไม่แตะฐานข้อมูล', async () => {
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([member({ memberNo: 'M2', schoolId: 's1', schoolCode: 'A' })]);

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(),
        fullDistrict: false,
        autoMarkArrears: false,
      });

      expect(prisma.memberContribution.updateMany).not.toHaveBeenCalled();
      expect(prisma.memberContribution.createMany).not.toHaveBeenCalled();
      expect(result.summary.markedArrears).toBe(0);
    });
  });

  describe('buildMissingWorkbook', () => {
    const row = {
      memberId: 'id-M2', contributionId: 'c-M2', memberNo: 'M2', fullName: 'ชื่อ M2',
      schoolId: 's1', schoolCode: 'A', schoolName: 'ร.ร.A', groupName: 'กลุ่ม 1',
      amountDue: 100, reason: 'NOT_IN_FILE' as const,
    };
    const rowOutOfScope = {
      memberId: 'id-M1', contributionId: 'c-M1', memberNo: 'M1', fullName: 'ชื่อ M1',
      schoolId: 's1', schoolCode: 'A', schoolName: 'ร.ร.A', groupName: 'กลุ่ม 1',
      amountDue: 100, reason: 'NOT_IN_FILE' as const,
    };
    const rowInScope = {
      memberId: 'id-M9', contributionId: 'c-M9', memberNo: 'M9', fullName: 'ชื่อ M9',
      schoolId: 's9', schoolCode: 'B', schoolName: 'ร.ร.B', groupName: 'กลุ่ม 2',
      amountDue: 200, reason: 'IN_FILE_NOT_PAID' as const,
    };

    it('สร้างไฟล์ที่อ่านกลับได้ตามรายชื่อที่ส่งมา และไม่บังคับ schoolId เมื่อไม่มีการจำกัดขอบเขต', async () => {
      prisma.member.findMany.mockResolvedValueOnce([{ memberNo: 'M2', schoolId: 's1' }]);

      const buffer = await service.buildMissingWorkbook([row]);

      // ไม่มี actor ที่ถูกบังคับโรงเรียน -> query ต้องไม่ใส่คีย์ schoolId เลย (ไม่ใช่แค่ output ว่าง)
      expect(prisma.member.findMany).toHaveBeenCalledWith({
        where: { memberNo: { in: ['M2'] } },
        select: { memberNo: true, schoolId: true },
      });

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      expect(rows[0]).toMatchObject({ เลขสมาชิก: 'M2', เหตุผล: 'ไม่มีในไฟล์' });
    });

    it('บังคับ schoolId จาก resolveSchoolId ใน query และตัดรายชื่อนอกขอบเขตทิ้ง แม้ DB จะคืนแถวมาจริง', async () => {
      resolveSchoolId.mockReturnValue('s9');
      // จำลองฐานข้อมูลจริง: ถ้า query ถูกกรองด้วย schoolId: 's9' จะเจอแค่ M9 เท่านั้น
      prisma.member.findMany.mockResolvedValueOnce([{ memberNo: 'M9', schoolId: 's9' }]);

      const buffer = await service.buildMissingWorkbook([rowOutOfScope, rowInScope], {
        id: 'u2', role: Role.SCHOOL_ADMIN, schoolId: 's9',
      });

      // ถ้าใครลบ spread ...(forcedSchoolId ? { schoolId: forcedSchoolId } : {}) ออก
      // where จะไม่มี schoolId: 's9' อีกต่อไป และ assertion นี้จะ fail ทันที ไม่ว่า mock ด้านบนจะคืนอะไร
      expect(prisma.member.findMany).toHaveBeenCalledWith({
        where: { memberNo: { in: ['M1', 'M9'] }, schoolId: 's9' },
        select: { memberNo: true, schoolId: true },
      });

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      expect(rows).toHaveLength(1);
      expect(rows[0]).toMatchObject({ เลขสมาชิก: 'M9', โรงเรียน: 'ร.ร.B' });
    });
  });
});
