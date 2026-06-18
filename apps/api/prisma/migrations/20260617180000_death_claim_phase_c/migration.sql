-- AlterTable
ALTER TABLE `DeathClaim` ADD COLUMN `deceasedType` ENUM('MEMBER', 'PARENT', 'CHILD', 'SPOUSE') NOT NULL DEFAULT 'MEMBER',
    ADD COLUMN `deceasedName` VARCHAR(191) NULL,
    ADD COLUMN `relationshipNote` VARCHAR(191) NULL,
    ADD COLUMN `protectedPersonId` VARCHAR(191) NULL;

-- CreateIndex
CREATE INDEX `DeathClaim_protectedPersonId_idx` ON `DeathClaim`(`protectedPersonId`);

-- AddForeignKey
ALTER TABLE `DeathClaim` ADD CONSTRAINT `DeathClaim_protectedPersonId_fkey` FOREIGN KEY (`protectedPersonId`) REFERENCES `ProtectedPerson`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;