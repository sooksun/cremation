# การแปลง Excel เป็น Prisma Migration

## วิธีใช้งาน (สำหรับ seed ครั้งแรก)

1. วางไฟล์ `member_data.xlsx` ที่โฟลเดอร์ `doc/`

2. รันคำสั่ง:
```bash
cd apps/api
npm run db:excel-to-migration
```

3. Script จะสร้าง migration 3 ชุด ที่ `apps/api/prisma/migrations/`:
   - `seed_schools_from_excel` – School
   - `seed_association_member_from_excel` – AssociationMember (ข้อมูลบุคคลจาก Excel โดยตรง)
   - `seed_members_from_excel` – Member ฌาปนกิจ (สร้างจากข้อมูล Excel โดยตรง)

4. ต้องมี **MemberType** ใน DB ก่อน (รัน `pnpm db:seed` หรือ `npx prisma db seed` จาก `apps/api`)

5. รัน migration:
```bash
npx prisma migrate deploy
```

## โครงสร้าง Excel ที่รองรับ (สำหรับ seed migration)

- **1 sheet ต่อ 1 โรงเรียน** – ชื่อ sheet หรือแถวแรกที่มีคำว่า "โรงเรียน" = ชื่อโรงเรียน
- **Header ตัวอย่าง:** ที่, ชื่อ-สกุล, ตำแหน่ง, เบอร์โทร, ... (script รองรับ firstName, lastName, phone, position ฯลฯ)
- **แถวถัดไป:** ข้อมูลสมาชิก

## Runtime CSV Import (ผ่าน UI /members)
- ใช้ endpoint `/members/import/csv`
- รองรับ header: memberNo, firstName, lastName, schoolCode, memberTypeCode, groupCode, status, joinDate, phone, idCardNo, birthDate, address, position
- สามารถสร้าง/อัปเดต AssociationMember + Member ได้
- UI ในหน้า Members มีปุ่มนำเข้า CSV

## ลำดับการทำงาน (schema ปัจจุบัน)

Script สร้าง 3 migrations แยก:

1. **seed_schools_from_excel** – INSERT School (ข้ามถ้ามี code หรือ name ซ้ำ)
2. **seed_association_member_from_excel** – INSERT AssociationMember (ข้อมูลบุคคลเต็ม: firstName, lastName, phone, position, associationJoinDate, schoolId, memberTypeId) – สร้างจาก Excel โดยตรง
3. **seed_members_from_excel** – INSERT Member ฌาปนกิจ อ้าง `associationMemberId` (เลขสมาชิก M00001, …) – สร้างจาก Excel โดยตรง

**ไม่ต้องมี Member อยู่ก่อน** (อัปเดตจากเวอร์ชันเก่า)

## เงื่อนไข

- ต้องรัน `pnpm db:seed` (หรือ `npx prisma db seed`) ก่อน เพื่อให้มี **MemberType** (REG, STF ฯลฯ)
- School ต้อง match โดย code, name, หรือ partial name จาก sheet
- Script ใช้ NOT EXISTS เพื่อข้ามรายการซ้ำ (AssociationMember ตรวจ firstName+lastName+school, Member ตรวจ associationMemberId)
- ไฟล์ Excel ต้องอยู่ที่ `doc/member_data.xlsx` (หลาย sheet ต่อโรงเรียน)