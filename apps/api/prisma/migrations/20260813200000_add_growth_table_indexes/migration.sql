-- เพิ่ม index ให้ตารางที่โตเร็วที่สุดในระบบ (ledger ~1,600 แถว/เดือน, ใบเสร็จ ~620/เดือน)
--
-- ปลอดภัยกับการรันอัตโนมัติตอน container boot บนข้อมูลจริง:
-- ทุกคำสั่งเป็น CREATE INDEX ล้วน ไม่มีการแก้โครงสร้างคอลัมน์ ไม่มีการเขียนข้อมูลใหม่
-- InnoDB สร้าง secondary index แบบ in-place (ALGORITHM=INPLACE, LOCK=NONE) ตารางยังอ่านเขียนได้ระหว่างสร้าง
--
-- หมายเหตุ: MemberContribution.periodId ไม่ต้องเพิ่ม เพราะ MySQL สร้าง index ให้คอลัมน์
-- foreign key อยู่แล้ว (MemberContribution_periodId_fkey) การประกาศซ้ำได้ index ซ้อนเปล่า ๆ

-- CreateIndex
-- accounts.service.ts: getJournal/getTrialBalance กรอง LedgerEntry ด้วยช่วงวันที่ (เดิมไม่มี index เลย)
CREATE INDEX `LedgerEntry_date_idx` ON `LedgerEntry`(`date`);

-- CreateIndex
-- accounts.service.ts: getLedger กรองด้วย accountId + ช่วงวันที่ (FK index มีแค่ accountId)
CREATE INDEX `LedgerEntry_accountId_date_idx` ON `LedgerEntry`(`accountId`, `date`);

-- CreateIndex
-- reports/members: กรองสมาชิกด้วยสถานะ (ACTIVE, ARREARS) แทบทุกหน้า
CREATE INDEX `Member_status_idx` ON `Member`(`status`);

-- CreateIndex
-- เวอร์ชันแยกรายโรงเรียนของด้านบน (FK index มีแค่ schoolId)
CREATE INDEX `Member_schoolId_status_idx` ON `Member`(`schoolId`, `status`);

-- CreateIndex
-- reports.service.ts: รายรับ-รายจ่ายรายเดือนกรองใบสำคัญจ่ายด้วยช่วงวันที่
CREATE INDEX `PaymentVoucher_date_idx` ON `PaymentVoucher`(`date`);

-- CreateIndex
CREATE INDEX `PaymentVoucher_schoolId_date_idx` ON `PaymentVoucher`(`schoolId`, `date`);

-- CreateIndex
-- reports.service.ts: แดชบอร์ดกรองใบเสร็จด้วยช่วงวันที่ทุกครั้งที่เปิดหน้า
CREATE INDEX `Receipt_date_idx` ON `Receipt`(`date`);

-- CreateIndex
CREATE INDEX `Receipt_schoolId_date_idx` ON `Receipt`(`schoolId`, `date`);
