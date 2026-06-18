-- Phase E: governance — disbursement approval (ข้อ 13.6)

ALTER TABLE `DeathClaim` ADD COLUMN `approvedById` VARCHAR(191) NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `approvedAt` DATETIME(3) NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `approverName` VARCHAR(191) NULL;
ALTER TABLE `DeathClaim` ADD COLUMN `approverSignature` TEXT NULL;

ALTER TABLE `DeathClaim` ADD CONSTRAINT `DeathClaim_approvedById_fkey`
  FOREIGN KEY (`approvedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- Extend AuditAction enum
ALTER TABLE `AuditLog` MODIFY `action` ENUM(
  'CONTRIBUTION_PAYMENT',
  'BATCH_PAYMENT',
  'DEATH_CLAIM_CREATE',
  'DEATH_CLAIM_PAYMENT',
  'DEATH_CLAIM_APPROVE',
  'RECEIPT_CREATE',
  'PAYMENT_VOUCHER_CREATE'
) NOT NULL;