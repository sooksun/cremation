-- CreateTable
CREATE TABLE `AssociationMember` (
    `id` VARCHAR(191) NOT NULL,
    `memberId` VARCHAR(191) NOT NULL,
    `schoolId` VARCHAR(191) NOT NULL,
    `memberTypeId` VARCHAR(191) NOT NULL,
    `associationMemberNo` VARCHAR(191) NULL,
    `position` VARCHAR(100) NULL,
    `associationJoinDate` DATETIME(3) NULL,
    `notes` TEXT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `AssociationMember_memberId_key`(`memberId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_memberTypeId_fkey` FOREIGN KEY (`memberTypeId`) REFERENCES `MemberType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
