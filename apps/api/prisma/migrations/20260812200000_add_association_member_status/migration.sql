-- AlterTable
ALTER TABLE `AssociationMember`
    ADD COLUMN `status` ENUM('ACTIVE', 'ENDED') NOT NULL DEFAULT 'ACTIVE',
    ADD COLUMN `membershipEndReason` ENUM('DECEASED', 'RETIRED', 'RESIGNED', 'TRANSFERRED', 'ARREARS_TERMINATED', 'MANUAL') NULL,
    ADD COLUMN `membershipEndDate` DATETIME(3) NULL;

-- CreateIndex
CREATE INDEX `AssociationMember_status_idx` ON `AssociationMember`(`status`);
