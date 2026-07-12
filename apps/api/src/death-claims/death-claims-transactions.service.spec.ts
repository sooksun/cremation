import { BadRequestException } from '@nestjs/common';
import { DeathClaimStatus, Role } from '@prisma/client';
import { DeathClaimsService } from './death-claims.service';
import { SchoolScopeService } from '../common/security/school-scope.service';

describe('DeathClaimsService transactions', () => {
  const claimId = 'claim-1';
  const schoolId = 'school-a';
  const actor = { id: 'user-1', role: Role.FINANCE, schoolId };

  const paidReadyClaim = {
    id: claimId,
    claimNo: 'DC-2026-0001',
    schoolId,
    status: DeathClaimStatus.READY_TO_PAY,
    collectedAmount: 5000,
    totalContribution: 5000,
    associationSupport: 500,
    netToPay: 4500,
    documentsComplete: true,
    approvedAt: new Date(),
    payment: null,
    documentChecklist: [],
    member: { associationMember: null },
    school: { name: 'Test' },
  };

  const auditLog = { log: jest.fn() };
  const schoolScope = new SchoolScopeService();

  describe('recordPayment', () => {
    const txCreate = jest.fn();
    const txClaimUpdate = jest.fn();

    const docNumber = { generateNumber: jest.fn().mockResolvedValue('DOC-TEST') };

    const prisma = {
      deathClaim: { findUnique: jest.fn() },
      $transaction: jest.fn(async (fn: (tx: unknown) => Promise<unknown>) =>
        fn({
          account: { findFirst: jest.fn().mockResolvedValue({ id: 'acc-x' }) },
          receipt: { create: jest.fn().mockResolvedValue({ id: 'rcpt-1' }) },
          paymentVoucher: { create: jest.fn().mockResolvedValue({ id: 'vch-1' }) },
          ledgerEntry: { createMany: jest.fn() },
          deathBenefitPayment: { create: txCreate },
          deathClaim: { update: txClaimUpdate },
        }),
      ),
    };

    const service = new DeathClaimsService(
      prisma as never,
      docNumber as never,
      {} as never,
      schoolScope,
      auditLog as never,
      {} as never,
    );

    beforeEach(() => {
      jest.clearAllMocks();
      prisma.deathClaim.findUnique.mockResolvedValue({ ...paidReadyClaim });
      txCreate.mockResolvedValue({
        id: 'pay-1',
        amount: 4500,
        deathClaim: paidReadyClaim,
        bankAccount: null,
        voucher: null,
      });
      txClaimUpdate.mockResolvedValue({ ...paidReadyClaim, status: DeathClaimStatus.PAID });
    });

    it('wraps payment insert and status update in a transaction', async () => {
      await service.recordPayment(
        claimId,
        { payDate: '2024-12-15', method: 'CASH' },
        actor,
      );

      expect(prisma.$transaction).toHaveBeenCalledTimes(1);
      expect(txCreate).toHaveBeenCalled();
      expect(txClaimUpdate).toHaveBeenCalledWith({
        where: { id: claimId },
        data: {
          status: DeathClaimStatus.PAID,
          collectionReceiptId: 'rcpt-1',
          benefitVoucherId: 'vch-1',
        },
      });
    });

    it('rejects payment amount that differs from netToPay', async () => {
      await expect(
        service.recordPayment(
          claimId,
          { payDate: '2024-12-15', method: 'CASH', amount: 1 },
          actor,
        ),
      ).rejects.toThrow(BadRequestException);

      expect(prisma.$transaction).not.toHaveBeenCalled();
    });

    it('uses netToPay when amount is omitted', async () => {
      await service.recordPayment(
        claimId,
        { payDate: '2024-12-15', method: 'CASH' },
        actor,
      );

      expect(txCreate).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ amount: 4500 }),
        }),
      );
    });
  });
});