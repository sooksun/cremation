-- Phase D: death claim collection workflow + document checklist

ALTER TABLE `DeathClaim` ADD COLUMN `status` ENUM('REPORTED', 'COLLECTING', 'FUND_COMPLETE', 'READY_TO_PAY', 'PAID') NOT NULL DEFAULT 'REPORTED';
ALTER TABLE `DeathClaim` ADD COLUMN `collectionChannel` ENUM('SALARY_DEDUCTION', 'BANK_TRANSFER') NOT NULL DEFAULT 'BANK_TRANSFER';
ALTER TABLE `DeathClaim` ADD COLUMN `notifyAuthorityDeadline` DATETIME(3) NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `collectionDeadline` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);
ALTER TABLE `DeathClaim` ADD COLUMN `documentDeadline` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);
ALTER TABLE `DeathClaim` ADD COLUMN `paymentDeadline` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3);
ALTER TABLE `DeathClaim` ADD COLUMN `collectedAmount` DECIMAL(12,2) NOT NULL DEFAULT 0;
ALTER TABLE `DeathClaim` ADD COLUMN `collectionCompletedAt` DATETIME(3) NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `documentsComplete` BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE `DeathClaim` ADD COLUMN `documentChecklist` JSON NOT NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `workflowNotes` TEXT NULL;

-- Backfill workflow fields for existing claims
UPDATE `DeathClaim` dc
LEFT JOIN `Member` m ON m.id = dc.memberId
SET
  dc.collectionChannel = CASE
    WHEN m.membershipClass = 'ORDINARY' OR m.salaryDeduction = 1 THEN 'SALARY_DEDUCTION'
    ELSE 'BANK_TRANSFER'
  END,
  dc.notifyAuthorityDeadline = CASE
    WHEN m.membershipClass = 'ORDINARY' OR m.salaryDeduction = 1
      THEN DATE_ADD(LAST_DAY(dc.reportedDate), INTERVAL 5 DAY)
    ELSE NULL
  END,
  dc.collectionDeadline = CASE
    WHEN m.membershipClass = 'ORDINARY' OR m.salaryDeduction = 1
      THEN DATE_ADD(LAST_DAY(dc.reportedDate), INTERVAL 5 DAY)
    ELSE DATE_ADD(dc.deathDate, INTERVAL 15 DAY)
  END,
  dc.documentDeadline = DATE_ADD(
    LAST_DAY(dc.deathDate),
    INTERVAL 15 DAY
  ),
  dc.paymentDeadline = DATE_ADD(
    LAST_DAY(dc.deathDate),
    INTERVAL 30 DAY
  ),
  dc.collectedAmount = dc.totalContribution,
  dc.collectionCompletedAt = dc.createdAt,
  dc.documentsComplete = CASE WHEN EXISTS (
    SELECT 1 FROM `DeathBenefitPayment` p WHERE p.deathClaimId = dc.id
  ) THEN 1 ELSE 0 END,
  dc.documentChecklist = JSON_ARRAY(
    JSON_OBJECT('key', 'death_certificate', 'label', 'ใบมรณบัตร', 'required', true, 'checked', false),
    JSON_OBJECT('key', 'beneficiary_id', 'label', 'สำเนาบัตรประชาชนผู้รับเงิน', 'required', true, 'checked', false),
    JSON_OBJECT('key', 'bank_book', 'label', 'สำเนาสมุดบัญชีผู้รับเงิน', 'required', true, 'checked', false)
  ),
  dc.status = CASE
    WHEN EXISTS (SELECT 1 FROM `DeathBenefitPayment` p WHERE p.deathClaimId = dc.id) THEN 'PAID'
    ELSE 'REPORTED'
  END;