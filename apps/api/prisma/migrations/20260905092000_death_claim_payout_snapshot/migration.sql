-- แยก "ยอด ณ วันจ่ายจริง" ออกจาก snapshot ตอนสร้างเรื่อง
-- เดิม recordPayment เขียนทับ activeMemberCount/totalContribution/associationSupport/
-- netToPay/welfareRate ด้วยค่าที่คำนวณใหม่ ณ วันจ่าย ทำให้เป้าเก็บเงินเดิมหายไป
-- และตรวจย้อนหลังไม่ได้ว่าที่อนุมัติจ่ายไปนั้นเก็บครบตามเป้าที่ตั้งตอนแจ้งจริงหรือไม่
ALTER TABLE `DeathClaim`
  ADD COLUMN `payoutMemberCount` INTEGER NULL,
  ADD COLUMN `payoutWelfareRate` DECIMAL(10, 2) NULL,
  ADD COLUMN `payoutTotalContribution` DECIMAL(12, 2) NULL,
  ADD COLUMN `payoutAssociationSupport` DECIMAL(12, 2) NULL,
  ADD COLUMN `payoutNetToPay` DECIMAL(12, 2) NULL;
