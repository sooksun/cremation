-- Track arrears notice per contribution period (prevents duplicate notice on same period)
ALTER TABLE `MemberContribution` ADD COLUMN `arrearsNoticeSentAt` DATETIME(3) NULL;