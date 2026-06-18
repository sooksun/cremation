-- AlterTable
ALTER TABLE `Member` ADD COLUMN `membershipClass` ENUM('ORDINARY', 'CONTRIBUTORY') NOT NULL DEFAULT 'CONTRIBUTORY',
    ADD COLUMN `applicationSubmittedAt` DATETIME(3) NULL,
    ADD COLUMN `applicationDeadline` DATETIME(3) NULL,
    ADD COLUMN `membershipEndReason` ENUM('DECEASED', 'RETIRED', 'RESIGNED', 'ARREARS_TERMINATED', 'MANUAL') NULL,
    ADD COLUMN `arrearsNoticeSentAt` DATETIME(3) NULL,
    ADD COLUMN `consecutiveArrearsPeriods` INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE `ProtectedPerson` (
    `id` VARCHAR(191) NOT NULL,
    `memberId` VARCHAR(191) NOT NULL,
    `fullName` VARCHAR(191) NOT NULL,
    `relationship` ENUM('SPOUSE', 'PARENT', 'CHILD') NOT NULL,
    `nationalId` VARCHAR(191) NULL,
    `phone` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `endedAt` DATETIME(3) NULL,
    `endReason` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `ProtectedPerson_memberId_idx`(`memberId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `ProtectedPerson` ADD CONSTRAINT `ProtectedPerson_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;