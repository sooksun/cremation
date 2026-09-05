-- memberNo เป็น running number ที่ DocumentNumberService ออกให้แบบ read-then-increment
-- โดยไม่มี lock และเป็นคีย์จับคู่ไฟล์ Excel นำเข้าเงิน (findFirst by memberNo)
-- ถ้าไม่มี unique constraint สองคำขอพร้อมกันจะได้เลขเดียวกันแบบเงียบ ๆ
-- migration จะล้มถ้ามีเลขซ้ำอยู่แล้ว ซึ่งเป็นสิ่งที่ต้องการ: ต้องแก้ข้อมูลก่อนจึงเดินต่อได้

-- ทุกคำสั่งเช็คก่อนสร้าง เพื่อให้รันซ้ำได้หลังแก้ข้อมูลเลขสมาชิกซ้ำแล้วสั่ง deploy ใหม่
-- (ถ้าไม่เช็ค การรันรอบสองจะล้มที่ index ตัวที่สร้างสำเร็จไปแล้วในรอบแรก)

SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Member' AND INDEX_NAME = 'Member_memberNo_key');
SET @s := IF(@x = 0, 'CREATE UNIQUE INDEX `Member_memberNo_key` ON `Member`(`memberNo`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'Member' AND INDEX_NAME = 'Member_schoolId_memberNo_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `Member_schoolId_memberNo_idx` ON `Member`(`schoolId`, `memberNo`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'DeathClaim' AND INDEX_NAME = 'DeathClaim_reportedDate_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `DeathClaim_reportedDate_idx` ON `DeathClaim`(`reportedDate`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'DeathClaim' AND INDEX_NAME = 'DeathClaim_schoolId_reportedDate_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `DeathClaim_schoolId_reportedDate_idx` ON `DeathClaim`(`schoolId`, `reportedDate`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @x := (SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'DeathClaim' AND INDEX_NAME = 'DeathClaim_status_idx');
SET @s := IF(@x = 0, 'CREATE INDEX `DeathClaim_status_idx` ON `DeathClaim`(`status`)', 'SELECT 1');
PREPARE stmt FROM @s; EXECUTE stmt; DEALLOCATE PREPARE stmt;
