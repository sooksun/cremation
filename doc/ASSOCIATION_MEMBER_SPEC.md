# สเปกทะเบียนสมาชิกสมาคมผู้ประกอบวิชาชีพ

## ชื่อสมาคม
สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง

## ความสัมพันธ์กับระบบ
- สมาชิกฌาปนกิจสงเคราะห์ = สมาชิกสมาคม (ทุกคน)
- 1 Member : 1 AssociationMember (optional profile)

## Database Schema

```prisma
model AssociationMember {
  id                  String   @id @default(cuid())
  member              Member   @relation(...)
  memberId            String   @unique
  school              School   @relation(...)
  schoolId            String   // การสังกัดโรงเรียน
  memberType          MemberType @relation(...)
  memberTypeId        String   // ประเภทสมาชิก
  associationMemberNo String?  // เลขสมาชิกสมาคม
  position            String?  // ตำแหน่งในสมาคม
  associationJoinDate DateTime?
  notes               String?  @db.Text
  createdAt           DateTime
  updatedAt           DateTime
}
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/association-members | รายการสมาชิกสมาคม (filter: schoolId, search, status, page, limit) |
| GET | /api/association-members/:memberId | ดูข้อมูลสมาชิกสมาคมตาม memberId |
| PATCH | /api/association-members/:memberId | แก้ไขข้อมูลสมาชิกสมาคม |

## Business Rules
1. เมื่อสร้าง Member ใหม่ → สร้าง AssociationMember โดยอัตโนมัติ (associationJoinDate = member.joinDate)
2. การลบ Member → ลบ AssociationMember ด้วย (Cascade)
3. ทุก query ต้อง filter ตาม schoolId ตาม multi-tenant
