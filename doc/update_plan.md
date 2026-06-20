# สถานะแผนแก้ไข (อัปเดต มิ.ย. 2026)

| รายการ | สถานะ |
|--------|--------|
| [P1] School scope (members, association-members, import CSV, groups, receipts, payments, upload) | ✅ แก้แล้ว |
| [P1] Workflow ค้างชำระ 3 ครั้ง | ✅ แก้แล้ว |
| [P1] Member/AssociationMember auto-create + cascade delete | ✅ แก้แล้ว |
| [P1] Death benefit นับ ARREARS + บังคับ ProtectedPerson | ✅ แก้แล้ว |
| [P1] รหัสผ่านสุ่ม + mustChangePassword ฝั่ง API | ✅ แก้แล้ว |
| [P2] PDF สมทบ digitCentersX | ✅ แก้แล้ว |
| [P2] Contribution matrix + payment template รวม ARREARS | ✅ แก้แล้ว |
| [P2] Reports / death-claims UI school scope | ✅ แก้แล้ว |
| [P2] excel-to-migration ตรง schema ใหม่ | ✅ แก้แล้ว |
| [P3] Reports ส่ง actor + resolveSchoolId ใน controller | ✅ แก้แล้ว |
| [P3] PATCH association-members ใช้ memberId เมื่อมี cremation | ✅ แก้แล้ว |
| [P3] POST association-members จำกัด ADMIN/SCHOOL_ADMIN | ✅ แก้แล้ว |
| [P3] change-password guard + API 403 redirect | ✅ แก้แล้ว |
| [P3] Death claim บังคับเลือก ProtectedPerson | ✅ แก้แล้ว |
| [P3] Period detail ส่ง schoolId | ✅ แก้แล้ว |

---

# บันทึกปัญหาเดิม (อ้างอิง)

[P1] School Admin สามารถข้ามโรงเรียนผ่าน ID ได้หลาย endpoint — **แก้แล้ว**

[P1] Workflow ค้างชำระ 3 ครั้งทำงานผิดหลัก — **แก้แล้ว**

[P1] ความสัมพันธ์ Member/AssociationMember สวนกับสเปก — **แก้แล้ว**

[P1] ยอดเงินสงเคราะห์อาจคำนวณต่ำกว่าระเบียบ — **แก้แล้ว**

[P1] บัญชี School Admin เริ่มต้นใช้รหัสผ่านคาดเดาได้ — **แก้แล้ว**

[P2] PDF สมาชิกสมทบวางเลขบัตรไม่ตรงช่อง — **แก้แล้ว**