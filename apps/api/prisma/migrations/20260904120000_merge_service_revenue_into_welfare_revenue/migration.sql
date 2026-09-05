-- ยุบบัญชี 402 "รายได้ค่าบริการ" เข้าบัญชี 401 "รายได้เงินสงเคราะห์"
-- ตามข้อสรุปกับสมาคม: เงินสงเคราะห์ที่รับมาเป็นรายได้ก้อนเดียว รวมส่วน 10% ที่หักเข้าสมาคม
-- ยอดแยกเงินสงเคราะห์/ค่าบริการยังอยู่ที่ MemberContribution.welfareAmount / serviceAmount สำหรับรายงาน

UPDATE `LedgerEntry` `le`
JOIN `Account` `src` ON `src`.`id` = `le`.`accountId` AND `src`.`code` = '402'
JOIN `Account` `dst` ON `dst`.`code` = '401'
SET `le`.`accountId` = `dst`.`id`,
    `le`.`description` = REPLACE(`le`.`description`, 'รายได้ค่าบริการ', 'รายได้เงินสงเคราะห์');

-- ลบบัญชี 402 / 404 เมื่อไม่มีรายการบัญชีอ้างถึงแล้ว
DELETE FROM `Account`
WHERE `code` IN ('402', '404')
  AND NOT EXISTS (
    SELECT 1 FROM `LedgerEntry` WHERE `LedgerEntry`.`accountId` = `Account`.`id`
  );

-- ถ้า 404 "เงินบริจาค" เคยมีรายการบันทึกไว้ ให้ปิดใช้งานแทนการลบ
-- เพื่อไม่ทำลายบัญชีย้อนหลังและงบการเงินของงวดที่ปิดไปแล้ว
UPDATE `Account` SET `isActive` = 0 WHERE `code` IN ('402', '404');
