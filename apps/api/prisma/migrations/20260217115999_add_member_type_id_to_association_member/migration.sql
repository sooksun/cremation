-- Add memberTypeId to AssociationMember if missing (fix for DB created without this column)
-- รองรับกรณีตารางถูกสร้างจาก schema เก่าหรือ db push ที่ไม่มี memberTypeId

-- ฐานข้อมูลที่สร้างใหม่จะมี memberTypeId มาตั้งแต่ migration สร้างตารางแล้ว
-- จึงต้องเช็คก่อนเพิ่ม ไม่งั้น migrate deploy บน DB เปล่าล้มด้วย error 1060 (duplicate column)
SET @col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'AssociationMember' AND COLUMN_NAME = 'memberTypeId');
SET @sql := IF(@col = 0,
  'ALTER TABLE `AssociationMember` ADD COLUMN `memberTypeId` VARCHAR(191) NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `AssociationMember` am
SET am.`memberTypeId` = (SELECT m.`memberTypeId` FROM `Member` m WHERE m.id = am.`memberId` LIMIT 1)
WHERE am.`memberTypeId` IS NULL;

-- Set default from first MemberType for any rows still null (e.g. Member missing)
UPDATE `AssociationMember` am
SET am.`memberTypeId` = (SELECT id FROM `MemberType` LIMIT 1)
WHERE am.`memberTypeId` IS NULL;

ALTER TABLE `AssociationMember` MODIFY COLUMN `memberTypeId` VARCHAR(191) NOT NULL;

-- Add FK if not exists (MySQL 8.0.19+ supports IF NOT EXISTS for constraints via check)
-- ถ้ามี FK อยู่แล้วคำสั่งนี้จะ error - รันแยกหากจำเป็น
-- ALTER TABLE `AssociationMember` ADD CONSTRAINT `AssociationMember_memberTypeId_fkey` FOREIGN KEY (`memberTypeId`) REFERENCES `MemberType`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
