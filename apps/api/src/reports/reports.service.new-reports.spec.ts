import { Role, MemberStatus } from '@prisma/client';
import { ReportsService } from './reports.service';

describe('ReportsService — PRD upgrade reports', () => {
  const prisma = {
    member: { findMany: jest.fn() },
    receipt: { findMany: jest.fn(), groupBy: jest.fn() },
    paymentVoucher: { findMany: jest.fn(), groupBy: jest.fn() },
    $transaction: jest.fn(),
  };
  prisma.$transaction.mockImplementation((arg: unknown) =>
    typeof arg === 'function' ? (arg as (tx: unknown) => Promise<unknown>)(prisma) : Promise.all(arg as Promise<unknown>[]),
  );
  const auditLog = { log: jest.fn() };

  const service = new ReportsService(
    prisma as never,
    {} as never,
    {} as never,
    auditLog as never,
  );

  const adminActor = { id: 'u1', role: Role.ADMIN } as never;

  beforeEach(() => jest.clearAllMocks());

  describe('getResignationReport', () => {
    it('groups by reason, counts totals, and audit-logs the generation', async () => {
      prisma.member.findMany.mockResolvedValue([
        {
          id: 'm1',
          memberNo: 'M001',
          schoolId: 's1',
          school: { name: 'School A' },
          resignDate: new Date('2026-01-10'),
          membershipEndReason: 'RETIRED',
          associationMember: {
            firstName: 'A',
            lastName: 'B',
            idCardNo: '1234567890123',
            associationMemberNo: 'A001',
          },
        },
        {
          id: 'm2',
          memberNo: 'M002',
          schoolId: 's1',
          school: { name: 'School A' },
          resignDate: new Date('2026-02-01'),
          membershipEndReason: null,
          associationMember: {
            firstName: 'C',
            lastName: 'D',
            idCardNo: null,
            associationMemberNo: 'A002',
          },
        },
      ]);

      const result = await service.getResignationReport(
        new Date('2026-01-01'),
        new Date('2026-03-01'),
        undefined,
        adminActor,
      );

      expect(result.summary.totalResigned).toBe(2);
      expect(result.summary.byReason).toEqual(
        expect.arrayContaining([
          { reason: 'RETIRED', count: 1 },
          { reason: 'ไม่ระบุ', count: 1 },
        ]),
      );
      expect(result.resignations[0].fullName).toBe('A B');
      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'REPORT_GENERATE', entityId: 'resignations' }),
      );
      expect(prisma.member.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          where: expect.objectContaining({ status: MemberStatus.RESIGNED }),
        }),
      );
    });

    it('masks ID card numbers for roles without full-PII access', async () => {
      prisma.member.findMany.mockResolvedValue([
        {
          id: 'm1',
          memberNo: 'M001',
          schoolId: 's1',
          school: { name: 'School A' },
          resignDate: new Date('2026-01-10'),
          membershipEndReason: 'RETIRED',
          associationMember: {
            firstName: 'A',
            lastName: 'B',
            idCardNo: '1234567890123',
            associationMemberNo: 'A001',
          },
        },
      ]);

      const viewerActor = { id: 'u2', role: Role.VIEWER } as never;
      const result = await service.getResignationReport(
        new Date('2026-01-01'),
        new Date('2026-03-01'),
        undefined,
        viewerActor,
      );

      expect(result.resignations[0].idCardNo).not.toBe('1234567890123');
    });

    it('substitutes a null reason consistently between summary.byReason and per-row resignations', async () => {
      prisma.member.findMany.mockResolvedValue([
        {
          id: 'm1',
          memberNo: 'M001',
          schoolId: 's1',
          school: { name: 'School A' },
          resignDate: new Date('2026-01-10'),
          membershipEndReason: null,
          associationMember: { firstName: 'A', lastName: 'B', idCardNo: null, associationMemberNo: 'A001' },
        },
      ]);

      const result = await service.getResignationReport(
        new Date('2026-01-01'),
        new Date('2026-03-01'),
        undefined,
        adminActor,
      );

      expect(result.summary.byReason).toEqual([{ reason: 'ไม่ระบุ', count: 1 }]);
      expect(result.resignations[0].membershipEndReason).toBe('ไม่ระบุ');
    });

    it('does not write a REPORT_GENERATE audit log when the underlying query fails', async () => {
      prisma.member.findMany.mockRejectedValue(new Error('db unavailable'));

      await expect(
        service.getResignationReport(new Date('2026-01-01'), new Date('2026-03-01'), undefined, adminActor),
      ).rejects.toThrow('db unavailable');

      expect(auditLog.log).not.toHaveBeenCalled();
    });
  });

  describe('getReceiptsLedger', () => {
    it('sums totals and rolls up by type', async () => {
      prisma.receipt.findMany.mockResolvedValue([
        {
          id: 'r1',
          receiptNo: 'R001',
          date: new Date('2026-01-05'),
          type: 'MEMBER_CONTRIBUTION',
          description: 'งวด 1',
          amount: 100,
          school: { name: 'School A' },
          bankAccount: null,
        },
        {
          id: 'r2',
          receiptNo: 'R002',
          date: new Date('2026-01-06'),
          type: 'MEMBERSHIP_FEE',
          description: 'ค่าสมัคร',
          amount: 50,
          school: { name: 'School A' },
          bankAccount: { bankName: 'KTB' },
        },
      ]);
      prisma.receipt.groupBy.mockResolvedValue([
        { type: 'MEMBER_CONTRIBUTION', _count: 1, _sum: { amount: 100 } },
        { type: 'MEMBERSHIP_FEE', _count: 1, _sum: { amount: 50 } },
      ]);

      const result = await service.getReceiptsLedger(
        new Date('2026-01-01'),
        new Date('2026-01-31'),
      );

      expect(result.summary.totalAmount).toBe(150);
      expect(result.summary.count).toBe(2);
      expect(result.summary.byType).toHaveLength(2);
      expect(result.receipts[1].bankAccount).toBe('KTB');
    });

    it('derives totalAmount/count from the byType aggregate (not a separate re-reduce) and audit-logs the generation', async () => {
      // findMany intentionally returns fewer/different rows than byType would sum to, so a
      // pass would only happen if totalAmount/count are derived FROM byType.
      prisma.receipt.findMany.mockResolvedValue([
        {
          id: 'r1',
          receiptNo: 'R001',
          date: new Date('2026-01-05'),
          type: 'MEMBER_CONTRIBUTION',
          description: 'งวด 1',
          amount: 999,
          school: { name: 'School A' },
          bankAccount: null,
        },
      ]);
      prisma.receipt.groupBy.mockResolvedValue([
        { type: 'MEMBER_CONTRIBUTION', _count: 3, _sum: { amount: 300 } },
      ]);

      const result = await service.getReceiptsLedger(
        new Date('2026-01-01'),
        new Date('2026-01-31'),
        undefined,
        undefined,
        adminActor,
      );

      expect(result.summary.totalAmount).toBe(300);
      expect(result.summary.count).toBe(3);
      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'REPORT_GENERATE', entityId: 'receipts-ledger' }),
      );
    });

    it('runs findMany and groupBy in one transaction', async () => {
      prisma.receipt.findMany.mockResolvedValue([]);
      prisma.receipt.groupBy.mockResolvedValue([]);

      await service.getReceiptsLedger(new Date('2026-01-01'), new Date('2026-01-31'));

      expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    });

    it('does not write a REPORT_GENERATE audit log when the underlying query fails', async () => {
      prisma.receipt.findMany.mockRejectedValue(new Error('db unavailable'));
      prisma.receipt.groupBy.mockResolvedValue([]);

      await expect(
        service.getReceiptsLedger(new Date('2026-01-01'), new Date('2026-01-31'), undefined, undefined, adminActor),
      ).rejects.toThrow('db unavailable');

      expect(auditLog.log).not.toHaveBeenCalled();
    });
  });

  describe('getMemberRegistryReport', () => {
    it('audit-logs generation of the PII-bearing registry report', async () => {
      prisma.member.findMany.mockResolvedValue([
        {
          id: 'm1',
          schoolId: 's1',
          school: { id: 's1', name: 'School A' },
          memberNo: 'M001',
          joinDate: new Date('2026-01-05'),
          applicationSubmittedAt: new Date('2026-01-01'),
          associationMember: {
            firstName: 'A',
            lastName: 'B',
            idCardNo: '1234567890123',
            associationMemberNo: 'A001',
            birthDate: new Date('1990-01-01'),
          },
        },
      ]);

      await service.getMemberRegistryReport(
        'coverage',
        new Date('2026-01-01'),
        new Date('2026-01-31'),
        undefined,
        adminActor,
      );

      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'REPORT_GENERATE', entityId: 'member-registry' }),
      );
    });

    it('returns createdAt so the frontend can display the "recorded" date field', async () => {
      const createdAt = new Date('2026-01-02T10:00:00Z');
      prisma.member.findMany.mockResolvedValue([
        {
          id: 'm1',
          schoolId: 's1',
          school: { id: 's1', name: 'School A' },
          memberNo: 'M001',
          joinDate: new Date('2026-01-05'),
          applicationSubmittedAt: new Date('2026-01-01'),
          createdAt,
          associationMember: {
            firstName: 'A',
            lastName: 'B',
            idCardNo: '1234567890123',
            associationMemberNo: 'A001',
            birthDate: new Date('1990-01-01'),
          },
        },
      ]);

      const result = await service.getMemberRegistryReport(
        'recorded',
        new Date('2026-01-01'),
        new Date('2026-01-31'),
        undefined,
        adminActor,
      );

      expect(result.bySchool[0].members[0].createdAt).toBe(createdAt);
    });
  });

  describe('getDisbursementLedger', () => {
    it('sums voucher totals and audit-logs the generation', async () => {
      prisma.paymentVoucher.findMany.mockResolvedValue([
        {
          id: 'p1',
          voucherNo: 'PV-001',
          date: new Date('2026-01-05'),
          type: 'DEATH_BENEFIT',
          description: 'จ่ายเงินสงเคราะห์',
          amount: 90000,
          school: { name: 'School A' },
          bankAccount: { bankName: 'KTB' },
        },
      ]);
      prisma.paymentVoucher.groupBy.mockResolvedValue([
        { type: 'DEATH_BENEFIT', _count: 1, _sum: { amount: 90000 } },
      ]);

      const result = await service.getDisbursementLedger(
        new Date('2026-01-01'),
        new Date('2026-01-31'),
        undefined,
        undefined,
        adminActor,
      );

      expect(result.summary.totalAmount).toBe(90000);
      expect(auditLog.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'REPORT_GENERATE', entityId: 'disbursement-ledger' }),
      );
    });

    it('derives totalAmount/count from the byType aggregate and runs both queries in one transaction', async () => {
      prisma.paymentVoucher.findMany.mockResolvedValue([
        {
          id: 'p1',
          voucherNo: 'PV-001',
          date: new Date('2026-01-05'),
          type: 'DEATH_BENEFIT',
          description: 'จ่ายเงินสงเคราะห์',
          amount: 999,
          school: { name: 'School A' },
          bankAccount: null,
        },
      ]);
      prisma.paymentVoucher.groupBy.mockResolvedValue([
        { type: 'DEATH_BENEFIT', _count: 3, _sum: { amount: 60000 } },
      ]);

      const result = await service.getDisbursementLedger(
        new Date('2026-01-01'),
        new Date('2026-01-31'),
      );

      expect(result.summary.totalAmount).toBe(60000);
      expect(result.summary.count).toBe(3);
      expect(prisma.$transaction).toHaveBeenCalledTimes(1);
    });

    it('does not write a REPORT_GENERATE audit log when the underlying query fails', async () => {
      prisma.paymentVoucher.findMany.mockRejectedValue(new Error('db unavailable'));
      prisma.paymentVoucher.groupBy.mockResolvedValue([]);

      await expect(
        service.getDisbursementLedger(
          new Date('2026-01-01'),
          new Date('2026-01-31'),
          undefined,
          undefined,
          adminActor,
        ),
      ).rejects.toThrow('db unavailable');

      expect(auditLog.log).not.toHaveBeenCalled();
    });
  });
});
