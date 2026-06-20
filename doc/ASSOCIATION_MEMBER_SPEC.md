# สเปกทะเบียนสมาชิกสมาคมผู้ประกอบวิชาชีพ

## ชื่อสมาคม
สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง

## ความสัมพันธ์กับระบบ
- สมาชิกฌาปนกิจสงเคราะห์ = สมาชิกสมาคม (ทุกคนในตาราง Member)
- 1 Member : 1 AssociationMember — **AssociationMember เป็นต้นทางข้อมูลบุคคล**, Member อ้าง `associationMemberId`

## Database Schema

```prisma
model AssociationMember {
  id                  String    @id @default(cuid())
  school              School    @relation(...)
  schoolId            String
  memberType          MemberType @relation(...)
  memberTypeId        String
  associationMemberNo String?
  firstName           String
  lastName            String
  idCardNo            String?
  birthDate           DateTime?
  address             String?
  phone               String?
  position            String?
  associationJoinDate DateTime?
  notes               String?   @db.Text
  cremationMember     Member?   // 1:1 ถ้าเป็นสมาชิกฌาปนกิจ
  createdAt           DateTime
  updatedAt           DateTime
}

model Member {
  associationMemberId String   @unique
  memberNo            String   // เลขสมาชิกฌาปนกิจ
  schoolId            String
  joinDate            DateTime
  status              MemberStatus
  // ...
}
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/association-members | รายการสมาชิกสมาคม (filter: schoolId, search, status, page, limit) |
| GET | /api/association-members/:memberId | ดูข้อมูลสมาชิกสมาคมตาม memberId (สมาชิกฌาปนกิจ) |
| PATCH | /api/association-members/:memberId | แก้ไขข้อมูลสมาชิกสมาคม (เมื่อมีสมาชิกฌาปนกิจ) |
| PATCH | /api/association-members/by-id/:id | แก้ไขข้อมูลสมาชิกสมาคมที่ยังไม่มีสมาชิกฌาปนกิจ |
| POST | /api/association-members | สร้างสมาชิกสมาคมโดยไม่มีสมาชิกฌาปนกิจ (ADMIN, SCHOOL_ADMIN) |

## Business Rules
1. เมื่อสร้าง Member ใหม่ → สร้าง AssociationMember โดยอัตโนมัติ (associationJoinDate = member.joinDate)
2. การลบ Member → ลบ AssociationMember ด้วย (Cascade)
3. ทุก query ต้อง filter ตาม schoolId ตาม multi-tenant
