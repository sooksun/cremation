import { BadRequestException } from '@nestjs/common';
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
        // กันชนกับการอัปโหลดงวดเดียวกันพร้อมกัน (unique memberId+periodId) ไม่ให้กลายเป็น 500
        skipDuplicates: true,
      });
      expect(result.summary.markedArrears).toBe(1);
    });

    it('แถวที่ชนกับของที่มีอยู่แล้วถูกข้าม markedArrears นับเฉพาะที่เขียนได้จริง', async () => {
      const first = member({ memberNo: 'M3', schoolId: 's1', schoolCode: 'A' });
      first.contributions = [];
      const second = member({ memberNo: 'M4', schoolId: 's1', schoolCode: 'A' });
      second.contributions = [];
      prisma.member.findMany
        .mockResolvedValueOnce([{ id: 'id-M1', memberNo: 'M1', schoolId: 's1' }])
        .mockResolvedValueOnce([first, second]);
      // เจ้าหน้าที่อีกคนเพิ่งสร้างแถวของ M4 ไปแล้ว -> Prisma ข้ามแถวนั้นและคืน count = 1
      prisma.memberContribution.createMany.mockResolvedValue({ count: 1 });

      const result = await service.reconcile({
        periodId: 'p1',
        parsed: parsed([{ rowNo: 2, memberNo: 'M1', isPaid: true }]),
        paidNowMemberNos: new Set(),
        fullDistrict: false,
        autoMarkArrears: true,
      });

      expect(prisma.memberContribution.createMany.mock.calls[0][0].data).toHaveLength(2);
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
    const EXPECTED_SELECT = {
      memberNo: true,
      schoolId: true,
      school: { select: { code: true, name: true } },
      group: { select: { name: true } },
      associationMember: { select: { firstName: true, lastName: true } },
      contributions: { where: { periodId: 'p1' }, select: { totalAmount: true } },
    };

    // แถวที่ client โพสต์กลับมา — ตั้งใจให้ fullName/schoolName/groupName/amountDue "ปลอม" ไม่ตรงกับ DB
    // เพื่อพิสูจน์ว่า service ไม่เอาค่าพวกนี้จาก client ไปใช้เลย รับแค่ memberNo กับ reason เท่านั้น
    const postedRow = {
      memberId: 'id-M2', contributionId: 'c-M2', memberNo: 'M2',
      fullName: 'ปลอมชื่อ', schoolId: 's1', schoolCode: 'X', schoolName: 'ปลอมโรงเรียน',
      groupName: 'ปลอมกลุ่ม', amountDue: 999999, reason: 'NOT_IN_FILE' as const,
    };
    const dbMemberM2 = {
      memberNo: 'M2', schoolId: 's1',
      school: { code: 'A', name: 'ร.ร.A' },
      group: { name: 'กลุ่ม 1' },
      associationMember: { firstName: 'ชื่อจริง', lastName: 'นามสกุลจริง' },
      contributions: [{ totalAmount: 150 }],
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
    const dbMemberM9 = {
      memberNo: 'M9', schoolId: 's9',
      school: { code: 'B', name: 'ร.ร.B' },
      group: { name: 'กลุ่ม 2' },
      associationMember: { firstName: 'ชื่อ', lastName: 'M9' },
      contributions: [{ totalAmount: 200 }],
    };

    it('เอาชื่อ/โรงเรียน/กลุ่ม/ยอดเงินจากฐานข้อมูลเสมอ ไม่ใช้ค่าที่ client โพสต์มาปลอม', async () => {
      prisma.member.findMany.mockResolvedValueOnce([dbMemberM2]);

      const buffer = await service.buildMissingWorkbook('p1', [postedRow]);

      // ไม่มี actor ที่ถูกบังคับโรงเรียน -> query ต้องไม่ใส่คีย์ schoolId เลย
      expect(prisma.member.findMany).toHaveBeenCalledWith({
        where: { memberNo: { in: ['M2'] } },
        select: EXPECTED_SELECT,
      });

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      expect(rows).toHaveLength(1);
      // ค่าที่ออกไฟล์ต้องเป็นค่าจาก dbMemberM2 ทั้งหมด — ไม่ใช่ 'ปลอมชื่อ' / 999999 ที่ client ส่งมา
      expect(rows[0]).toMatchObject({
        เลขสมาชิก: 'M2',
        'ชื่อ-สกุล': 'ชื่อจริง นามสกุลจริง',
        โรงเรียน: 'ร.ร.A',
        กลุ่มเก็บเงิน: 'กลุ่ม 1',
        ยอดที่ต้องชำระ: 150,
        เหตุผล: 'ไม่มีในไฟล์',
      });
    });

    it('บังคับ schoolId จาก resolveSchoolId ใน query และตัดรายชื่อนอกขอบเขตทิ้ง แม้ DB จะคืนแถวมาจริง', async () => {
      resolveSchoolId.mockReturnValue('s9');
      // จำลองฐานข้อมูลจริง: ถ้า query ถูกกรองด้วย schoolId: 's9' จะเจอแค่ M9 เท่านั้น
      prisma.member.findMany.mockResolvedValueOnce([dbMemberM9]);

      const buffer = await service.buildMissingWorkbook('p1', [rowOutOfScope, rowInScope], {
        id: 'u2', role: Role.SCHOOL_ADMIN, schoolId: 's9',
      });

      // ถ้าใครลบ spread ...(forcedSchoolId ? { schoolId: forcedSchoolId } : {}) ออก
      // where จะไม่มี schoolId: 's9' อีกต่อไป และ assertion นี้จะ fail ทันที ไม่ว่า mock ด้านบนจะคืนอะไร
      expect(prisma.member.findMany).toHaveBeenCalledWith({
        where: { memberNo: { in: ['M1', 'M9'] }, schoolId: 's9' },
        select: EXPECTED_SELECT,
      });

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      expect(rows).toHaveLength(1);
      expect(rows[0]).toMatchObject({
        เลขสมาชิก: 'M9',
        โรงเรียน: 'ร.ร.B',
        เหตุผล: 'อยู่ในไฟล์ แต่ยังไม่ชำระ',
      });
    });

    it('สมาชิกที่ไม่มีแถว contribution ของงวดนี้ ใช้ยอดของงวดเป็นค่า fallback', async () => {
      const dbMemberNoContribution = {
        memberNo: 'M3', schoolId: 's1',
        school: { code: 'A', name: 'ร.ร.A' },
        group: { name: 'กลุ่ม 1' },
        associationMember: { firstName: 'ชื่อ', lastName: 'M3' },
        contributions: [] as Array<{ totalAmount: number }>,
      };
      prisma.member.findMany.mockResolvedValueOnce([dbMemberNoContribution]);

      const buffer = await service.buildMissingWorkbook('p1', [
        { ...postedRow, memberNo: 'M3' },
      ]);

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(book.Sheets[book.SheetNames[0]]);
      // PERIOD.welfareRate=100, serviceFee ปิดอยู่ -> defaultAmount = 100 จาก resolveAmounts(period)
      expect(rows[0]).toMatchObject({ เลขสมาชิก: 'M3', ยอดที่ต้องชำระ: 100 });
    });

    it('รายการว่างยังสร้างไฟล์ที่เปิดอ่านได้ ไม่ throw', async () => {
      prisma.member.findMany.mockResolvedValueOnce([]);

      const buffer = await service.buildMissingWorkbook('p1', []);

      const XLSX = await import('xlsx');
      const book = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json(book.Sheets[book.SheetNames[0]]);
      expect(rows).toEqual([]);
    });

    it('reason ที่ไม่ใช่สองค่าที่รู้จัก ถูกปฏิเสธ ไม่ถูกเอาไปเปิดตาราง label', async () => {
      await expect(
        service.buildMissingWorkbook('p1', [
          { ...postedRow, reason: 'constructor' as unknown as 'NOT_IN_FILE' },
        ]),
      ).rejects.toThrow(BadRequestException);

      expect(prisma.member.findMany).not.toHaveBeenCalled();
    });

    it('งวดไม่มีอยู่จริง โยน NotFoundException', async () => {
      prisma.contributionPeriod.findUnique.mockResolvedValueOnce(null);

      await expect(service.buildMissingWorkbook('missing-period', [postedRow])).rejects.toThrow(
        'ไม่พบงวดที่ระบุ',
      );
    });
  });
});
