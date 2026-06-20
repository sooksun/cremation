# การแปลง Excel เป็น Prisma Migration

## วิธีใช้งาน

1. วางไฟล์ `member_data.xlsx` ที่โฟลเดอร์ `doc/`

2. รันคำสั่ง:
```bash
cd apps/api
npm run db:excel-to-migration
```

3. Script จะสร้าง migration 3 ชุด ที่ `apps/api/prisma/migrations/`:
   - `seed_schools_from_excel` – School
   - `seed_association_member_from_excel` – AssociationMember (ข้อมูลบุคคล)
   - `seed_members_from_excel` – Member ฌาปนกิจ

4. ต้องมี **MemberType** ใน DB ก่อน (รัน `pnpm db:seed` หรือ `npx prisma db seed` จาก `apps/api`)

5. รัน migration:
```bash
npx prisma migrate deploy
```

## โครงสร้าง Excel ที่รองรับ

- **1 sheet ต่อ 1 โรงเรียน** – ชื่อ sheet หรือแถวแรกที่มีคำว่า "โรงเรียน" = ชื่อโรงเรียน
- **Header:** ที่, ชื่อ-สกุล, ตำแหน่ง, เบอร์โทร
- **แถวถัดไป:** ข้อมูลสมาชิก

## ลำดับการทำงาน (schema ปัจจุบัน)

1. **School** – INSERT โรงเรียน (ข้ามถ้ามีอยู่แล้ว WHERE NOT EXISTS)
2. **AssociationMember** – INSERT ข้อมูลบุคคล (firstName, lastName, phone, position, schoolId, memberTypeId)
3. **Member** – INSERT สมาชิกฌาปนกิจ อ้างอิง `associationMemberId` (เลขสมาชิก M00001, …)

## เงื่อนไข

- ต้องรัน `pnpm db:seed` ก่อน เพื่อให้มี **MemberType**
- School ที่สร้างจาก migration ต้อง match ชื่อใน Excel (script ใช้ code/name จาก sheet)
- Migration จะข้ามรายการที่มีอยู่แล้ว (WHERE NOT EXISTS / AND NOT EXISTS)