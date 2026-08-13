-- ยกเลิกใบเสร็จแบบไม่ลบแถว (soft void)
-- คอลัมน์ใหม่เป็น NULL ได้ทั้งคู่และไม่มีค่าเริ่มต้น จึงเป็น metadata-only change
-- ไม่ต้องเขียนข้อมูลเดิมใหม่ ใบเสร็จที่มีอยู่ทั้งหมดจะ voidedAt = NULL = ยังไม่ถูกยกเลิก
-- AlterTable
ALTER TABLE `Receipt`
    ADD COLUMN `voidedAt` DATETIME(3) NULL,
    ADD COLUMN `voidReason` VARCHAR(191) NULL;

-- CreateIndex
CREATE INDEX `Receipt_voidedAt_idx` ON `Receipt`(`voidedAt`);
