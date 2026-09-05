-- เดิมโฟลเดอร์นี้ชื่อ 20250217000000_add_association_member ซึ่งเรียงก่อน 20251126144339_init
-- ตามลำดับตัวอักษร prisma migrate deploy จึงพยายามสร้าง AssociationMember ที่อ้าง FK ไปยัง
-- ตาราง Member ตั้งแต่ก่อน init จะสร้าง Member ทำให้ติดตั้งใหม่จากฐานข้อมูลเปล่าล้มทุกครั้ง
-- (MySQL error 1824) และ container ของ api วนรีสตาร์ท
--
-- แก้โดยเปลี่ยนชื่อให้เรียงหลัง init และเขียน SQL ใหม่ให้ idempotent เพื่อให้ฐานข้อมูลเดิม
-- ที่เคยรันชื่อเก่าไปแล้ว รันชื่อใหม่ซ้ำได้โดยไม่พัง (ไม่ต้อง migrate resolve ด้วยมือบน server)

CREATE TABLE IF NOT EXISTS `AssociationMember` (
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

-- MySQL ไม่มี ADD CONSTRAINT IF NOT EXISTS จึงต้องเช็ค information_schema ก่อนทุกตัว
-- memberId ถูกถอดออกภายหลังตอนแยก AssociationMember (ตัวตน) ออกจาก Member (สมาชิกฌาปนกิจ)
-- ฐานข้อมูลที่ใช้งานอยู่จึงไม่มีทั้งคอลัมน์และ FK ตัวนี้แล้ว ต้องเช็คคอลัมน์ด้วย ไม่ใช่เช็คแต่ FK
SET @fk := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'AssociationMember_memberId_fkey');
SET @col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AssociationMember' AND COLUMN_NAME = 'memberId');
SET @sql := IF(@fk = 0 AND @col > 0,
  'ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_memberId_fkey` FOREIGN KEY (`memberId`) REFERENCES `Member`(`id`) ON DELETE CASCADE ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'AssociationMember_schoolId_fkey');
SET @col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AssociationMember' AND COLUMN_NAME = 'schoolId');
SET @sql := IF(@fk = 0 AND @col > 0,
  'ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'AssociationMember_memberTypeId_fkey');
SET @col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AssociationMember' AND COLUMN_NAME = 'memberTypeId');
SET @sql := IF(@fk = 0 AND @col > 0,
  'ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_memberTypeId_fkey` FOREIGN KEY (`memberTypeId`) REFERENCES `MemberType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
