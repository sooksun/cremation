-- Add createdAt and updatedAt to LedgerEntry
-- These columns support ordering and future auditability.
ALTER TABLE `LedgerEntry`
  ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  ADD COLUMN `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3);

-- Expand the AuditAction enum with new values for comprehensive audit logging
-- (permission changes, sensitive master data, PII updates, etc.)
-- IMPORTANT: All existing + new values must be listed.
ALTER TABLE `AuditLog`
  MODIFY `action` ENUM(
    'USER_LOGIN',
    'USER_LOGOUT',
    'PASSWORD_CHANGE',
    'USER_CREATE',
    'USER_UPDATE',
    'USER_DELETE',
    'USER_ROLE_CHANGE',
    'CONTRIBUTION_PAYMENT',
    'BATCH_PAYMENT',
    'RECEIPT_CREATE',
    'PAYMENT_VOUCHER_CREATE',
    'DEATH_CLAIM_CREATE',
    'DEATH_CLAIM_UPDATE',
    'DEATH_CLAIM_APPROVE',
    'DEATH_CLAIM_PAYMENT',
    'MEMBER_CREATE',
    'MEMBER_UPDATE',
    'MEMBER_STATUS_CHANGE',
    'CONTRIBUTION_PERIOD_CLOSE',
    'ASSET_DEPRECIATION_RECORD',
    'ACCOUNT_CREATE',
    'ACCOUNT_UPDATE',
    'SCHOOL_CREATE',
    'SCHOOL_UPDATE',
    'SCHOOL_DELETE',
    'SCHOOL_ADMIN_CREATE',
    'SCHOOL_ADMIN_UPDATE',
    'SCHOOL_ADMIN_DELETE',
    'GROUP_CREATE',
    'GROUP_UPDATE',
    'GROUP_DELETE',
    'MEMBER_TYPE_CREATE',
    'MEMBER_TYPE_UPDATE',
    'MEMBER_TYPE_DELETE',
    'BANK_ACCOUNT_CREATE',
    'BANK_ACCOUNT_UPDATE',
    'BANK_ACCOUNT_DELETE',
    'ASSOCIATION_MEMBER_CREATE',
    'ASSOCIATION_MEMBER_UPDATE',
    'WELFARE_SETTINGS_UPDATE',
    'ASSET_CREATE',
    'ASSET_UPDATE',
    'ASSET_DISPOSE'
  ) NOT NULL;

-- Note:
-- This migration was created after using `prisma db push` on a development database
-- that had legacy migration history problems (shadow DB failures).
-- The actual column changes were applied via `prisma db push`.
-- On a clean database (or fresh migration history), `prisma migrate dev` will generate
-- equivalent statements automatically.
