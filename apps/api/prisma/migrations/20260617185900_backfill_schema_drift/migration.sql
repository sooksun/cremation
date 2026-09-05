-- คอลัมน์ที่มีใน schema.prisma แต่ไม่เคยมี migration ไหนสร้าง (drift จากการใช้ `prisma db push`)
-- ฐานข้อมูลที่ใช้งานอยู่มีคอลัมน์เหล่านี้แล้ว แต่ฐานข้อมูลใหม่ที่สร้างจาก `migrate deploy`
-- ล้วน ๆ จะไม่มี ทำให้ migration รุ่นถัดไปที่อ้างถึงคอลัมน์นี้ล้ม (error 1054)
-- ทุกคำสั่งเช็ค information_schema ก่อน จึงรันซ้ำบนฐานข้อมูลเดิมได้อย่างปลอดภัย

SET @c := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Member' AND COLUMN_NAME = 'salaryDeduction');
SET @s := IF(@c = 0,
  'ALTER TABLE `Member` ADD COLUMN `salaryDeduction` BOOLEAN NOT NULL DEFAULT false',
  'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;
