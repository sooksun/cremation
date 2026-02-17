-- Migration: Seed AssociationMember จาก doc/member_data.xlsx
-- สร้างโดย excel-to-migration.ts
-- จำนวน: 15 รายการ
-- หมายเหตุ: ใช้ INSERT...SELECT โดย match Member จาก firstName, lastName และชื่อโรงเรียน


-- แถว 1: นางกรองแก้ว พรมรักษ์ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjj58kiqcphwd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  'โทร 085-6180464',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกรองแก้ว'
  AND m.lastName = 'พรมรักษ์'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 2: นางสาวพัชรี สิงห์ฉลาด (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjbt5zex20o3v',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 091-0793411',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรี'
  AND m.lastName = 'สิงห์ฉลาด'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 3: นางสาววนิดา อยู่อินทร์ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjrzv45v0ls',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 088-2945726',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววนิดา'
  AND m.lastName = 'อยู่อินทร์'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 4: นายอนุรักษ์ ใจปัญธิ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjj91mfc6pbl6v',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 087-1757611',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุรักษ์'
  AND m.lastName = 'ใจปัญธิ'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 5: นางสาวภัณฑิรา หวายคำ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjj6skwgbloka6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 095-1274994',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัณฑิรา'
  AND m.lastName = 'หวายคำ'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 6: นายสมทรัพย์ รัตตพิทักษ์ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjl1q6rrftpra',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 083-7622879',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมทรัพย์'
  AND m.lastName = 'รัตตพิทักษ์'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 7: นางสาวอรอนงค์ บุตรแสน (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjvefxan0pgak',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 098-3294474',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรอนงค์'
  AND m.lastName = 'บุตรแสน'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 8: นายพิชญ์ยุทธ์ นาวา (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjj17qp6uho9t1h',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 061-3151418',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิชญ์ยุทธ์'
  AND m.lastName = 'นาวา'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 9: นางสาวจิราวรรณ อภิรมย์ฤทัย (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjefyol0nunp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 082-6989728',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิราวรรณ'
  AND m.lastName = 'อภิรมย์ฤทัย'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 10: นางสาวนุชนาถ ศรีบัวบาน (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjju6t4rig4u5e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 091-7423271',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนุชนาถ'
  AND m.lastName = 'ศรีบัวบาน'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 11: นายกันต์ณภัทร สิริโชติชัยกุล (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjrykufrm9qm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  'โทร 092-8955915',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกันต์ณภัทร'
  AND m.lastName = 'สิริโชติชัยกุล'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 12: นายภาณุพงศ์ นภัสกรชัย (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjj6nt9e246h1',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  'โทร 093-2707659',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงศ์'
  AND m.lastName = 'นภัสกรชัย'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 13: นางสาวอัญชลี โปทา (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjptc2pji025k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  'โทร 065-2197838',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = 'โปทา'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 14: นางสาวอรจิรา สมบูรณ์ (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjrf67ncn2ot',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  'โทร 094-7040225',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรจิรา'
  AND m.lastName = 'สมบูรณ์'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;

-- แถว 15: นางสาวภารุจีร์ แซ่ลี (โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว)
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0ekjjg4f3tl7kzqj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  'โทร 093-7134791',
  '2026-02-17 02:53:59',
  '2026-02-17 02:53:59'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภารุจีร์'
  AND m.lastName = 'แซ่ลี'
  AND (s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแ%' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว')
LIMIT 1;
