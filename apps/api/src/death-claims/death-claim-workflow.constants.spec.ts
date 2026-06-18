import { DeathClaimStatus, DeathClaimType, DeathCollectionChannel, MembershipClass } from '@prisma/client';
import {
  addDays,
  buildDefaultDocumentChecklist,
  computeWorkflowDeadlines,
  deriveStatusAfterCollection,
  resolveWorkflowStatus,
  isChecklistComplete,
  nthDayAfterDeathMonth,
  nthDayOfNextMonth,
  resolveCollectionChannel,
} from './death-claim-workflow.constants';

describe('death-claim-workflow.constants', () => {
  describe('nthDayOfNextMonth', () => {
    it('returns 5th of next month from reported date', () => {
      const result = nthDayOfNextMonth(new Date('2024-12-10'), 5);
      expect(result.getFullYear()).toBe(2025);
      expect(result.getMonth()).toBe(0);
      expect(result.getDate()).toBe(5);
    });
  });

  describe('nthDayAfterDeathMonth', () => {
    it('returns 15th of month after death for documents', () => {
      const result = nthDayAfterDeathMonth(new Date('2024-12-08'), 15);
      expect(result.getFullYear()).toBe(2025);
      expect(result.getMonth()).toBe(0);
      expect(result.getDate()).toBe(15);
    });

    it('returns 30th of month after death for payment', () => {
      const result = nthDayAfterDeathMonth(new Date('2024-12-08'), 30);
      expect(result.getDate()).toBe(30);
    });
  });

  describe('addDays', () => {
    it('adds 15 days for contributory collection', () => {
      const result = addDays(new Date('2024-12-08'), 15);
      expect(result.getDate()).toBe(23);
      expect(result.getMonth()).toBe(11);
    });
  });

  describe('resolveCollectionChannel', () => {
    it('uses salary deduction for ordinary members', () => {
      expect(
        resolveCollectionChannel({ membershipClass: MembershipClass.ORDINARY }),
      ).toBe(DeathCollectionChannel.SALARY_DEDUCTION);
    });

    it('uses bank transfer for contributory members', () => {
      expect(
        resolveCollectionChannel({ membershipClass: MembershipClass.CONTRIBUTORY }),
      ).toBe(DeathCollectionChannel.BANK_TRANSFER);
    });
  });

  describe('computeWorkflowDeadlines', () => {
    it('sets ordinary deadlines with notify on 5th next month', () => {
      const result = computeWorkflowDeadlines({
        deathDate: new Date('2024-12-08'),
        reportedDate: new Date('2024-12-10'),
        membershipClass: MembershipClass.ORDINARY,
      });

      expect(result.collectionChannel).toBe(DeathCollectionChannel.SALARY_DEDUCTION);
      expect(result.notifyAuthorityDeadline?.getDate()).toBe(5);
      expect(result.collectionDeadline.getDate()).toBe(5);
      expect(result.documentDeadline.getDate()).toBe(15);
      expect(result.paymentDeadline.getDate()).toBe(30);
    });

    it('sets contributory collection within 15 days', () => {
      const result = computeWorkflowDeadlines({
        deathDate: new Date('2024-12-08'),
        reportedDate: new Date('2024-12-10'),
        membershipClass: MembershipClass.CONTRIBUTORY,
      });

      expect(result.collectionChannel).toBe(DeathCollectionChannel.BANK_TRANSFER);
      expect(result.notifyAuthorityDeadline).toBeNull();
      expect(result.collectionDeadline.getDate()).toBe(23);
    });
  });

  describe('buildDefaultDocumentChecklist', () => {
    it('includes authority notice for ordinary members', () => {
      const items = buildDefaultDocumentChecklist({
        claimType: DeathClaimType.MEMBER_DEATH,
        membershipClass: MembershipClass.ORDINARY,
      });
      expect(items.some((i) => i.key === 'authority_notice')).toBe(true);
    });

    it('includes relationship proof for protected death', () => {
      const items = buildDefaultDocumentChecklist({
        claimType: DeathClaimType.PROTECTED_DEATH,
        membershipClass: MembershipClass.CONTRIBUTORY,
      });
      expect(items.some((i) => i.key === 'relationship_proof')).toBe(true);
    });
  });

  describe('isChecklistComplete', () => {
    it('returns true when all required items checked', () => {
      expect(
        isChecklistComplete([
          { key: 'a', label: 'A', required: true, checked: true },
          { key: 'b', label: 'B', required: false, checked: false },
        ]),
      ).toBe(true);
    });
  });

  describe('deriveStatusAfterCollection', () => {
    it('moves to COLLECTING when partial amount recorded', () => {
      expect(
        deriveStatusAfterCollection({
          currentStatus: DeathClaimStatus.REPORTED,
          collectedAmount: 1000,
          targetAmount: 5000,
          documentsComplete: false,
        }),
      ).toBe(DeathClaimStatus.COLLECTING);
    });

    it('moves to FUND_COMPLETE when fully collected without documents', () => {
      expect(
        deriveStatusAfterCollection({
          currentStatus: DeathClaimStatus.COLLECTING,
          collectedAmount: 5000,
          targetAmount: 5000,
          documentsComplete: false,
        }),
      ).toBe(DeathClaimStatus.FUND_COMPLETE);
    });

    it('moves to READY_TO_PAY when fund and documents complete', () => {
      expect(
        deriveStatusAfterCollection({
          currentStatus: DeathClaimStatus.FUND_COMPLETE,
          collectedAmount: 5000,
          targetAmount: 5000,
          documentsComplete: true,
        }),
      ).toBe(DeathClaimStatus.READY_TO_PAY);
    });
  });

  describe('resolveWorkflowStatus', () => {
    it('starts collection from REPORTED when startCollecting is set', () => {
      expect(
        resolveWorkflowStatus({
          currentStatus: DeathClaimStatus.REPORTED,
          collectedAmount: 0,
          targetAmount: 5000,
          documentsComplete: false,
          startCollecting: true,
        }),
      ).toBe(DeathClaimStatus.COLLECTING);
    });

    it('derives status from collected amount instead of client override', () => {
      expect(
        resolveWorkflowStatus({
          currentStatus: DeathClaimStatus.COLLECTING,
          collectedAmount: 5000,
          targetAmount: 5000,
          documentsComplete: false,
          collectedAmountChanged: true,
        }),
      ).toBe(DeathClaimStatus.FUND_COMPLETE);
    });

    it('keeps current status when only notes would change', () => {
      expect(
        resolveWorkflowStatus({
          currentStatus: DeathClaimStatus.COLLECTING,
          collectedAmount: 1000,
          targetAmount: 5000,
          documentsComplete: false,
        }),
      ).toBe(DeathClaimStatus.COLLECTING);
    });

    it('never returns PAID from workflow patch resolution', () => {
      const result = resolveWorkflowStatus({
        currentStatus: DeathClaimStatus.READY_TO_PAY,
        collectedAmount: 5000,
        targetAmount: 5000,
        documentsComplete: true,
        collectedAmountChanged: true,
      });
      expect(result).not.toBe(DeathClaimStatus.PAID);
      expect(result).toBe(DeathClaimStatus.READY_TO_PAY);
    });
  });
});