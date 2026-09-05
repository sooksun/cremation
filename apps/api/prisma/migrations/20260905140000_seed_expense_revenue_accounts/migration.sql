-- บัญชีแยกประเภทของรายได้/ค่าใช้จ่ายที่ไม่ใช่เงินสงเคราะห์
--
-- เดิม receipts/payments มี if ที่กำหนดค่าเดิมทับตัวเอง ใบเสร็จทุกประเภทจึงลงเข้า 401
-- และใบสำคัญจ่ายทุกประเภทลงเข้า 501 หมด รายงานค่าใช้จ่ายดำเนินงานและค่าธรรมเนียมธนาคาร
-- จึงปนอยู่ใน "ค่าใช้จ่ายเงินสงเคราะห์ศพ" ทั้งก้อน
--
-- ทำเป็น migration ไม่ใช่ seed เพราะ seed เป็นสคริปต์สำหรับเครื่อง dev ที่ใส่ข้อมูล
-- ตัวอย่างและเคยรีเซ็ตรหัสผ่านผู้ใช้บน production มาแล้ว ผังบัญชีเป็นข้อมูลตั้งต้น
-- ที่ต้องมาพร้อม migrate deploy เสมอ
--
-- ใช้ INSERT ... SELECT ... WHERE NOT EXISTS เพื่อให้รันซ้ำได้โดยไม่ชน unique(code)
-- และไม่แตะชื่อบัญชีเดิมถ้ามีรหัสนั้นอยู่แล้ว

INSERT INTO `Account` (`id`, `code`, `name`, `type`, `isActive`)
SELECT * FROM (
  SELECT UUID() AS id, '405' AS code, 'รายได้ค่าสมัครและค่าบำรุง' AS name, 'INCOME' AS type, 1 AS isActive
  UNION ALL SELECT UUID(), '409', 'รายได้อื่น', 'INCOME', 1
  UNION ALL SELECT UUID(), '502', 'ค่าใช้จ่ายดำเนินงาน', 'EXPENSE', 1
  UNION ALL SELECT UUID(), '504', 'ค่าธรรมเนียมธนาคาร', 'EXPENSE', 1
  UNION ALL SELECT UUID(), '509', 'ค่าใช้จ่ายอื่น', 'EXPENSE', 1
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM `Account` a WHERE a.`code` = seed.`code`);

-- 402 "รายได้ค่าบริการ" กับ 404 "เงินบริจาค" ถูกยุบไปแล้วใน
-- 20260904120000_merge_service_revenue_into_welfare_revenue แต่การรัน `prisma db seed`
-- ของเวอร์ชันเก่าบนเครื่อง production สร้างกลับมาใหม่พร้อม isActive = 1
-- ลบทิ้งอีกครั้งเฉพาะกรณีที่ไม่มีรายการบัญชีอ้างถึง (ถ้ามีให้ปิดใช้งานแทน เพื่อไม่ทำลาย
-- งบย้อนหลังของงวดที่ปิดไปแล้ว)
DELETE FROM `Account`
WHERE `code` IN ('402', '404')
  AND NOT EXISTS (
    SELECT 1 FROM `LedgerEntry` WHERE `LedgerEntry`.`accountId` = `Account`.`id`
  );

UPDATE `Account` SET `isActive` = 0 WHERE `code` IN ('402', '404');
