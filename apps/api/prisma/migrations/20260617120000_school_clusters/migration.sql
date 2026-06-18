-- CreateTable
CREATE TABLE `SchoolCluster` (
    `id` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `SchoolCluster_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AlterTable
ALTER TABLE `School` ADD COLUMN `clusterId` VARCHAR(191) NULL;

-- AddForeignKey
ALTER TABLE `School` ADD CONSTRAINT `School_clusterId_fkey` FOREIGN KEY (`clusterId`) REFERENCES `SchoolCluster`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;