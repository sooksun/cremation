-- ปิดช่องว่างระหว่างประวัติ migration กับ schema.prisma
--
-- ที่มา: มีการใช้ `prisma db push` แก้สคีมาโดยตรงหลายรอบ คอลัมน์/ตาราง/ดัชนีจำนวนมาก
-- จึงมีอยู่จริงในฐานข้อมูลที่ใช้งาน แต่ไม่มี migration ไหนสร้างให้ ผลคือฐานข้อมูลที่สร้าง
-- ใหม่จาก `prisma migrate deploy` ล้วน ๆ จะขาดของเหล่านี้ทั้งหมด แล้ว Prisma Client
-- จะพังทันทีที่ query คอลัมน์ที่ไม่มีอยู่
--
-- ไฟล์นี้สร้างจาก `prisma migrate diff` ระหว่างฐานข้อมูลที่ migrate ล้วน ๆ กับ schema.prisma
-- แล้วแปลงทุกคำสั่งให้เช็ค information_schema ก่อน เพื่อให้รันซ้ำบนฐานข้อมูลที่มีของอยู่แล้ว
-- ได้โดยไม่ error (ฐานข้อมูล production จะเห็น migration นี้เป็น pending และรันแบบไม่ทำอะไร)

-- DropForeignKey BankAccount_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'BankAccount_schoolId_fkey');
SET @s := IF(@x > 0, 'ALTER TABLE `bankaccount` DROP FOREIGN KEY `BankAccount_schoolId_fkey`', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- DropForeignKey PaymentVoucher_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'PaymentVoucher_schoolId_fkey');
SET @s := IF(@x > 0, 'ALTER TABLE `paymentvoucher` DROP FOREIGN KEY `PaymentVoucher_schoolId_fkey`', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- DropForeignKey Receipt_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'Receipt_schoolId_fkey');
SET @s := IF(@x > 0, 'ALTER TABLE `receipt` DROP FOREIGN KEY `Receipt_schoolId_fkey`', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactDistrict ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactDistrict');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactDistrict` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactHouseNo ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactHouseNo');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactHouseNo` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactMoo ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactMoo');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactMoo` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactProvince ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactProvince');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactProvince` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactRoad ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactRoad');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactRoad` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactSoi ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactSoi');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactSoi` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactSubdistrict ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactSubdistrict');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactSubdistrict` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.contactZip ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'contactZip');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `contactZip` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredDistrict ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredDistrict');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredDistrict` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredHouseNo ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredHouseNo');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredHouseNo` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredMoo ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredMoo');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredMoo` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredProvince ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredProvince');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredProvince` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredRoad ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredRoad');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredRoad` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredSoi ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredSoi');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredSoi` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredSubdistrict ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredSubdistrict');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredSubdistrict` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- associationmember.registeredZip ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'associationmember' AND COLUMN_NAME = 'registeredZip');
SET @s := IF(@x = 0, 'ALTER TABLE `associationmember` ADD COLUMN `registeredZip` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- bankaccount.schoolId DROP
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bankaccount' AND COLUMN_NAME = 'schoolId');
SET @s := IF(@x > 0, 'ALTER TABLE `bankaccount` DROP COLUMN `schoolId`', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- bankaccount.createdAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bankaccount' AND COLUMN_NAME = 'createdAt');
SET @s := IF(@x = 0, 'ALTER TABLE `bankaccount` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- bankaccount.description ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bankaccount' AND COLUMN_NAME = 'description');
SET @s := IF(@x = 0, 'ALTER TABLE `bankaccount` ADD COLUMN `description` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- bankaccount.isDefault ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bankaccount' AND COLUMN_NAME = 'isDefault');
SET @s := IF(@x = 0, 'ALTER TABLE `bankaccount` ADD COLUMN `isDefault` BOOLEAN NOT NULL DEFAULT false', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- bankaccount.updatedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'bankaccount' AND COLUMN_NAME = 'updatedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `bankaccount` ADD COLUMN `updatedAt` DATETIME(3) NOT NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- banktransaction.deletedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'banktransaction' AND COLUMN_NAME = 'deletedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `banktransaction` ADD COLUMN `deletedAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.benefitVoucherId ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'benefitVoucherId');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `benefitVoucherId` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.collectionReceiptId ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'collectionReceiptId');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `collectionReceiptId` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.condolenceWreathAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'condolenceWreathAt');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `condolenceWreathAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.fixedBenefitAmount ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'fixedBenefitAmount');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `fixedBenefitAmount` DECIMAL(12, 2) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.funeralPrayerAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'funeralPrayerAt');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `funeralPrayerAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.isFixedBenefit ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'isFixedBenefit');
SET @s := IF(@x = 0, 'ALTER TABLE `deathclaim` ADD COLUMN `isFixedBenefit` BOOLEAN NOT NULL DEFAULT false', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.collectionChannel ALTER
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'collectionChannel');
SET @s := IF(@x > 0, 'ALTER TABLE `deathclaim` ALTER COLUMN `collectionChannel` DROP DEFAULT', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.collectionDeadline ALTER
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'collectionDeadline');
SET @s := IF(@x > 0, 'ALTER TABLE `deathclaim` ALTER COLUMN `collectionDeadline` DROP DEFAULT', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.documentDeadline ALTER
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'documentDeadline');
SET @s := IF(@x > 0, 'ALTER TABLE `deathclaim` ALTER COLUMN `documentDeadline` DROP DEFAULT', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- deathclaim.paymentDeadline ALTER
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'deathclaim' AND COLUMN_NAME = 'paymentDeadline');
SET @s := IF(@x > 0, 'ALTER TABLE `deathclaim` ALTER COLUMN `paymentDeadline` DROP DEFAULT', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.applicationStatus ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'applicationStatus');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `applicationStatus` ENUM(''PENDING'', ''APPROVED'', ''REJECTED'') NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.approvedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'approvedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `approvedAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.approvedById ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'approvedById');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `approvedById` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.approverName ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'approverName');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `approverName` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.committeeCertifiedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'committeeCertifiedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `committeeCertifiedAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.committeeCertifiedName ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'committeeCertifiedName');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `committeeCertifiedName` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.directorCertifiedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'directorCertifiedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `directorCertifiedAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.directorCertifiedName ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'directorCertifiedName');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `directorCertifiedName` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.rejectReason ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'rejectReason');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `rejectReason` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.rejectedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'rejectedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `rejectedAt` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- member.rejectedById ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'member' AND COLUMN_NAME = 'rejectedById');
SET @s := IF(@x = 0, 'ALTER TABLE `member` ADD COLUMN `rejectedById` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- paymentvoucher.createdAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'paymentvoucher' AND COLUMN_NAME = 'createdAt');
SET @s := IF(@x = 0, 'ALTER TABLE `paymentvoucher` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- paymentvoucher.updatedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'paymentvoucher' AND COLUMN_NAME = 'updatedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `paymentvoucher` ADD COLUMN `updatedAt` DATETIME(3) NOT NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- paymentvoucher.schoolId MODIFY
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'paymentvoucher' AND COLUMN_NAME = 'schoolId');
SET @s := IF(@x > 0, 'ALTER TABLE `paymentvoucher` MODIFY `schoolId` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- receipt.createdAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'receipt' AND COLUMN_NAME = 'createdAt');
SET @s := IF(@x = 0, 'ALTER TABLE `receipt` ADD COLUMN `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- receipt.updatedAt ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'receipt' AND COLUMN_NAME = 'updatedAt');
SET @s := IF(@x = 0, 'ALTER TABLE `receipt` ADD COLUMN `updatedAt` DATETIME(3) NOT NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- receipt.schoolId MODIFY
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'receipt' AND COLUMN_NAME = 'schoolId');
SET @s := IF(@x > 0, 'ALTER TABLE `receipt` MODIFY `schoolId` VARCHAR(191) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- receipt.type MODIFY
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'receipt' AND COLUMN_NAME = 'type');
SET @s := IF(@x > 0, 'ALTER TABLE `receipt` MODIFY `type` ENUM(''MEMBER_CONTRIBUTION'', ''MEMBERSHIP_FEE'', ''BOOK_FEE'', ''ANNUAL_FEE'', ''ADVANCE_WELFARE'', ''DEATH_COLLECTION'', ''OTHER'') NOT NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- user.failedLoginAttempts ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND COLUMN_NAME = 'failedLoginAttempts');
SET @s := IF(@x = 0, 'ALTER TABLE `user` ADD COLUMN `failedLoginAttempts` INTEGER NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- user.lockedUntil ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND COLUMN_NAME = 'lockedUntil');
SET @s := IF(@x = 0, 'ALTER TABLE `user` ADD COLUMN `lockedUntil` DATETIME(3) NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- user.signature ADD
SET @x := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'user' AND COLUMN_NAME = 'signature');
SET @s := IF(@x = 0, 'ALTER TABLE `user` ADD COLUMN `signature` TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateTable WelfareSettings
CREATE TABLE IF NOT EXISTS `WelfareSettings` (
    `id` VARCHAR(191) NOT NULL,
    `effectiveDate` DATETIME(3) NOT NULL,
    `welfareAmountPerCase` DECIMAL(12, 2) NOT NULL,
    `description` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable Asset
CREATE TABLE IF NOT EXISTS `Asset` (
    `id` VARCHAR(191) NOT NULL,
    `schoolId` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NULL,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `category` VARCHAR(191) NULL,
    `purchaseDate` DATETIME(3) NOT NULL,
    `originalCost` DECIMAL(12, 2) NOT NULL,
    `salvageValue` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `usefulLifeYears` INTEGER NOT NULL,
    `accumulatedDep` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
    `disposalDate` DATETIME(3) NULL,
    `disposalProceeds` DECIMAL(12, 2) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable CashBook
CREATE TABLE IF NOT EXISTS `CashBook` (
    `id` VARCHAR(191) NOT NULL,
    `schoolId` VARCHAR(191) NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `description` VARCHAR(191) NULL,
    `receiptId` VARCHAR(191) NULL,
    `paymentId` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `deletedAt` DATETIME(3) NULL,

    UNIQUE INDEX `CashBook_receiptId_key`(`receiptId`),
    UNIQUE INDEX `CashBook_paymentId_key`(`paymentId`),
    INDEX `CashBook_schoolId_date_idx`(`schoolId`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable ThaiAddress
CREATE TABLE IF NOT EXISTS `ThaiAddress` (
    `id` INTEGER NOT NULL,
    `subdistrict` VARCHAR(191) NOT NULL,
    `district` VARCHAR(191) NOT NULL,
    `province` VARCHAR(191) NOT NULL,
    `zipCode` VARCHAR(191) NOT NULL,

    INDEX `ThaiAddress_subdistrict_idx`(`subdistrict`),
    INDEX `ThaiAddress_district_idx`(`district`),
    INDEX `ThaiAddress_province_idx`(`province`),
    INDEX `ThaiAddress_zipCode_idx`(`zipCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex AuditLog_action_idx
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AuditLog' AND INDEX_NAME = 'AuditLog_action_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `AuditLog_action_idx` ON `AuditLog`(`action`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateIndex AuditLog_schoolId_idx
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AuditLog' AND INDEX_NAME = 'AuditLog_schoolId_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `AuditLog_schoolId_idx` ON `AuditLog`(`schoolId`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateIndex BankAccount_accountNo_key
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'BankAccount' AND INDEX_NAME = 'BankAccount_accountNo_key');
SET @s := IF(@x = 0, 'CREATE UNIQUE INDEX `BankAccount_accountNo_key` ON `BankAccount`(`accountNo`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateIndex Beneficiary_memberId_priority_key
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Beneficiary' AND INDEX_NAME = 'Beneficiary_memberId_priority_key');
SET @s := IF(@x = 0, 'CREATE UNIQUE INDEX `Beneficiary_memberId_priority_key` ON `Beneficiary`(`memberId`, `priority`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateIndex DeathClaim_collectionReceiptId_key
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'DeathClaim' AND INDEX_NAME = 'DeathClaim_collectionReceiptId_key');
SET @s := IF(@x = 0, 'CREATE UNIQUE INDEX `DeathClaim_collectionReceiptId_key` ON `DeathClaim`(`collectionReceiptId`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- CreateIndex DeathClaim_benefitVoucherId_key
SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'DeathClaim' AND INDEX_NAME = 'DeathClaim_benefitVoucherId_key');
SET @s := IF(@x = 0, 'CREATE UNIQUE INDEX `DeathClaim_benefitVoucherId_key` ON `DeathClaim`(`benefitVoucherId`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey AuditLog_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'AuditLog_schoolId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `AuditLog` ADD CONSTRAINT `AuditLog_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey DeathClaim_collectionReceiptId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'DeathClaim_collectionReceiptId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `DeathClaim` ADD CONSTRAINT `DeathClaim_collectionReceiptId_fkey` FOREIGN KEY (`collectionReceiptId`) REFERENCES `Receipt`(`id`) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey DeathClaim_benefitVoucherId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'DeathClaim_benefitVoucherId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `DeathClaim` ADD CONSTRAINT `DeathClaim_benefitVoucherId_fkey` FOREIGN KEY (`benefitVoucherId`) REFERENCES `PaymentVoucher`(`id`) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey Receipt_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'Receipt_schoolId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `Receipt` ADD CONSTRAINT `Receipt_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey PaymentVoucher_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'PaymentVoucher_schoolId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `PaymentVoucher` ADD CONSTRAINT `PaymentVoucher_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE SET NULL ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey Asset_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'Asset_schoolId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `Asset` ADD CONSTRAINT `Asset_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- AddForeignKey CashBook_schoolId_fkey
SET @x := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'CashBook_schoolId_fkey');
SET @s := IF(@x = 0, 'ALTER TABLE `CashBook` ADD CONSTRAINT `CashBook_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;
