-- Migration: Seed AssociationMember จาก doc/member_data.xlsx
-- สร้างโดย excel-to-migration.ts | รวมข้อมูลทุก sheet
-- จำนวน: 731 รายการ
-- หมายเหตุ: School ต้องมีอยู่แล้ว (รัน seed_schools ก่อน) และ Member ต้อง match ชื่อ+โรงเรียน


-- แถว 1: นางกรองแก้ว พรมรักษ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8vzt0tw6btbf2c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 085-6180464',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกรองแก้ว'
  AND m.lastName = 'พรมรักษ์'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 2: นางสาวพัชรี สิงห์ฉลาด | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8vzzouqg8yiu6p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 091-0793411',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรี'
  AND m.lastName = 'สิงห์ฉลาด'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 3: นางสาววนิดา อยู่อินทร์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8vzxun29v5un9t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 088-2945726',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววนิดา'
  AND m.lastName = 'อยู่อินทร์'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 4: นายอนุรักษ์ ใจปัญธิ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0z2enoqjpkfb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-1757611',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุรักษ์'
  AND m.lastName = 'ใจปัญธิ'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 5: นางสาวภัณฑิรา หวายคำ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0n13t267kke',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-1274994',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัณฑิรา'
  AND m.lastName = 'หวายคำ'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 6: นายสมทรัพย์ รัตตพิทักษ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0m0m1xt1kwf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 083-7622879',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมทรัพย์'
  AND m.lastName = 'รัตตพิทักษ์'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 7: นางสาวอรอนงค์ บุตรแสน | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0v3wrkxfrtec',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-3294474',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรอนงค์'
  AND m.lastName = 'บุตรแสน'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 8: นายพิชญ์ยุทธ์ นาวา | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0x7x1n546939',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 061-3151418',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิชญ์ยุทธ์'
  AND m.lastName = 'นาวา'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 9: นางสาวจิราวรรณ อภิรมย์ฤทัย | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w070v6tm9nsdt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-6989728',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิราวรรณ'
  AND m.lastName = 'อภิรมย์ฤทัย'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 10: นางสาวนุชนาถ ศรีบัวบาน | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dn94mk9tt4c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 091-7423271',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนุชนาถ'
  AND m.lastName = 'ศรีบัวบาน'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 11: นายกันต์ณภัทร สิริโชติชัยกุล | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jtjtl7gmd19',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 092-8955915',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกันต์ณภัทร'
  AND m.lastName = 'สิริโชติชัยกุล'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 12: นายภาณุพงศ์ นภัสกรชัย | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w060ogvrpn9e2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2707659',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงศ์'
  AND m.lastName = 'นภัสกรชัย'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 13: นางสาวอัญชลี โปทา | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0byg2zi6nl2u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 065-2197838',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = 'โปทา'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 14: นางสาวอรจิรา สมบูรณ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0kt7ex4j1wug',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 094-7040225',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรจิรา'
  AND m.lastName = 'สมบูรณ์'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 15: นางสาวภารุจีร์ แซ่ลี | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0i40miz705u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-7134791',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภารุจีร์'
  AND m.lastName = 'แซ่ลี'
  AND (s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%' OR s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 16: นายกิตติกร   ต๊ะคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w06uv0o7vqbs5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 085-6944424',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกิตติกร'
  AND m.lastName = 'ต๊ะคำ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 17: นายไกรวิชญ์  วงค์สุรินทร์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dkjuoxfg23r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 834541701',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไกรวิชญ์'
  AND m.lastName = 'วงค์สุรินทร์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 18: นางพูลศิริ   เมธีรัตนกูล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0zm1ij6kdtu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 084-4613754',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางพูลศิริ'
  AND m.lastName = 'เมธีรัตนกูล'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 19: นายพิพัฒน์   เมธีรัตนกูล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tvvy41p0e5q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 093-2943690',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิพัฒน์'
  AND m.lastName = 'เมธีรัตนกูล'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 20: นายสุรชัย   คำมงคล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0c0im4biszt5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 083-7658902',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรชัย'
  AND m.lastName = 'คำมงคล'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 21: นางสาวนิภาพร   ทองขันนาค | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0piq4yvv1jid',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 091-3064674',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิภาพร'
  AND m.lastName = 'ทองขันนาค'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 22: นางสาวพิมพ์ใจ   นารีรักษ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01f59y11855q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-8781849',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์ใจ'
  AND m.lastName = 'นารีรักษ์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 23: นางสาววัชรีพร   ก้อนคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0g58dd4rr6u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-8584453',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววัชรีพร'
  AND m.lastName = 'ก้อนคำ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 24: นางสาวปฐมาภรณ์   เคร่งครัด | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0e7xpqh445wn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-7029705',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปฐมาภรณ์'
  AND m.lastName = 'เคร่งครัด'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 25: นางสาวนิชาภัทร   สว่างถาวรกุล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w057pt8ba8ovl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 086-4296892',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิชาภัทร'
  AND m.lastName = 'สว่างถาวรกุล'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 26: นางสาวดวงพร   สมเมือง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dvxfzjxkxjw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 086-4984618',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวดวงพร'
  AND m.lastName = 'สมเมือง'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 27: นางสาวชญาน์ทิพย์   กาสม | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w06h1vqpen1wq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 081-6716139',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชญาน์ทิพย์'
  AND m.lastName = 'กาสม'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 28: นางสาวอัมพิกา   สมศักดิ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0x34lu403uqn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 081-1670232',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัมพิกา'
  AND m.lastName = 'สมศักดิ์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 29: นายณรงค์ฤทธิ์   ชัยประดล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mj2z2810pba',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 083-8304969',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณรงค์ฤทธิ์'
  AND m.lastName = 'ชัยประดล'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 30: นายรัฐพงศ์   สมทิพย์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sl45zk98x98',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 085-7147891',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายรัฐพงศ์'
  AND m.lastName = 'สมทิพย์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 31: นายอิทธิพัทธ์   นัยติ๊บ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0c73n3eyhzdl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 090-3165159',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอิทธิพัทธ์'
  AND m.lastName = 'นัยติ๊บ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 32: นายชานนท์   วงศ์นันทเจริญ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jz3r5fegqh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 084-7405243',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชานนท์'
  AND m.lastName = 'วงศ์นันทเจริญ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 33: นางสาวทองประกาย   ก้างออนตา | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01dhdw6y6fph',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 091-0713306',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวทองประกาย'
  AND m.lastName = 'ก้างออนตา'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 34: นางสาวพรรณนิกา เขื่อนเชียงสา | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pftzpr0rkto',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-9458719',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพรรณนิกา'
  AND m.lastName = 'เขื่อนเชียงสา'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 35: นางสาวธีร์จุฑา   แจ้งสว่าง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dsjlvl28loi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-1483399',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธีร์จุฑา'
  AND m.lastName = 'แจ้งสว่าง'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 36: นางสาวเพชรา  คชเพชร | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0zbp7ikvc52',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 092-9946335',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเพชรา'
  AND m.lastName = 'คชเพชร'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 37: นางสาวกัญจนพร มาเยอะ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0knvcy2zxzd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-3030116',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญจนพร'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 38: นางสาวเมขลา เยอะหนื่อ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0yr5qz9u7byg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-9021950',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเมขลา'
  AND m.lastName = 'เยอะหนื่อ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 39: นางสาวพัทธ์ธีรา  กิจตาวงค์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jwelddli44',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-8212649',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัทธ์ธีรา'
  AND m.lastName = 'กิจตาวงค์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 40: นางสาวศิริลักษณ์  งามหมู่ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w04h1ooozcfu2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 091-1394423',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริลักษณ์'
  AND m.lastName = 'งามหมู่'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 41: นายณัฐวุฒิ   เป็กยันเมือง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0iv2d0wyycr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 084-1715006',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐวุฒิ'
  AND m.lastName = 'เป็กยันเมือง'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 42: นางสาวมยุรฉัตร  ปรารมณ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09sl5yk0l6od',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-7120859',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมยุรฉัตร'
  AND m.lastName = 'ปรารมณ์'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 43: นายศรายุทธ  บุญคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0djkqfjb79e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 063-0616495',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศรายุทธ'
  AND m.lastName = 'บุญคำ'
  AND (s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%' OR s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 44: นายสมจิตร คําปา | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08srvuydv2gf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อํานวยการโรงเรียนบ้านผาเดื่อ',
  m.joinDate,
  'โทร 088-2526952',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมจิตร'
  AND m.lastName = 'คําปา'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 45: นางสาวเมธิญา ยะขาว | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0syye8b0kpwo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9534613',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเมธิญา'
  AND m.lastName = 'ยะขาว'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 46: นายคนองเมฆ ใจสุข | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w061zc01nqk7x',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 092-2684723',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคนองเมฆ'
  AND m.lastName = 'ใจสุข'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 47: นายทรงกรด ทายะนา | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wa6d6qtj5gk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-3570552',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายทรงกรด'
  AND m.lastName = 'ทายะนา'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 48: นางสาวณฐมน จิตรประสาร | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09obn28lzjtl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2392263',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณฐมน'
  AND m.lastName = 'จิตรประสาร'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 49: นายนภจร โยธาภักดิ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0djvvpg990in',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 085-8833667',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนภจร'
  AND m.lastName = 'โยธาภักดิ์'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 50: นายธนาวุฒิ ศรีบริบูรณ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0v14t517m1er',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยงเด็กพิการ',
  m.joinDate,
  'โทร 090-1025904',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนาวุฒิ'
  AND m.lastName = 'ศรีบริบูรณ์'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 51: นางสาวนันทนา เสรีสวัสดิ์ศรี | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cmdlyfgdow',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยงเด็กพิการ',
  m.joinDate,
  'โทร 064-2103194',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนันทนา'
  AND m.lastName = 'เสรีสวัสดิ์ศรี'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 52: นางสาววิมลสิริ เคนทรภักดิ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0iiys4msdvp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูขั้นวิกฤตฯ',
  m.joinDate,
  'โทร 088-6608534',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิมลสิริ'
  AND m.lastName = 'เคนทรภักดิ์'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 53: นางสาวศรสวรรค์ มาเยอ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ctgjtvi58rm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการโรงเรียน',
  m.joinDate,
  'โทร 088-2526952',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศรสวรรค์'
  AND m.lastName = 'มาเยอ'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 54: นายฤทธี วังเอี่ยม | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pvkh6c5x4e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 097-2407545',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฤทธี'
  AND m.lastName = 'วังเอี่ยม'
  AND (s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%' OR s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 55: นางสาวกมลลักษณ์ จันทร์หลวง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ni8e7s98cjj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 082-1641455',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกมลลักษณ์'
  AND m.lastName = 'จันทร์หลวง'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 56: นายสมชาย วจนะพระคุณไพศาล | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07ex2soqmpfb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 061-3568852',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมชาย'
  AND m.lastName = 'วจนะพระคุณไพศาล'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 57: นางสาวกาญจนาพร วงค์ชัย | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jple2457rnn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-7819570',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกาญจนาพร'
  AND m.lastName = 'วงค์ชัย'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 58: นายลิลิณชยา พราหมณ์แก้ว | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0n4mkaomz02',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 080-1153822',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายลิลิณชยา'
  AND m.lastName = 'พราหมณ์แก้ว'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 59: นายวงศกร หลวงสา | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0h2hc2gu2n6s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-1461928',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวงศกร'
  AND m.lastName = 'หลวงสา'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 60: นายศุภณัฐ เม่นแย้ม | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w02u9t1uy4dns',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-5661741',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศุภณัฐ'
  AND m.lastName = 'เม่นแย้ม'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 61: นายสิงหา ภูธิเบศน์ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ji6edh4f0x',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 083-9399255',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสิงหา'
  AND m.lastName = 'ภูธิเบศน์'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 62: นางสาวเจนจิรา สีสะอาด | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hd5ozoi4bc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-9688368',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเจนจิรา'
  AND m.lastName = 'สีสะอาด'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 63: นายธีร์ โพธิ์เกตุ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0k8l3ajzyfa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 062-3093830',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธีร์'
  AND m.lastName = 'โพธิ์เกตุ'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 64: นายพิชญพันธ์ จันทรา | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08tev4noqgr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 089-8523837',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิชญพันธ์'
  AND m.lastName = 'จันทรา'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 65: นางสาวอัชชนา ศรีแก้ว | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05ceajtdd32b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-3988448',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัชชนา'
  AND m.lastName = 'ศรีแก้ว'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 66: นายกันต์พล เชื้อเมืองพาน | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0yvt181s165o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-4815753',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกันต์พล'
  AND m.lastName = 'เชื้อเมืองพาน'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 67: นางสาวสุธาสินี คำเผ่า | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0yujsfyvmwp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 085-5240673',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุธาสินี'
  AND m.lastName = 'คำเผ่า'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 68: นางสาวณัฐชา วงค์แสง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0p8slcv99lyb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 944422886',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐชา'
  AND m.lastName = 'วงค์แสง'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 69: นางสาวลักขนา แซ่เติ๋น | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ngij87ycahn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2621893',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวลักขนา'
  AND m.lastName = 'แซ่เติ๋น'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 70: นายอนุภัทร แซ่ฟุ้ง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07uzy3dy9b75',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 083-0653216',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุภัทร'
  AND m.lastName = 'แซ่ฟุ้ง'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 71: นางสาวพนิดา ขจรเจริญเดช | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0vcvul2dwk3s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 097-3216847',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพนิดา'
  AND m.lastName = 'ขจรเจริญเดช'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 72: นางสาวพิมพร พัฒนพงษ์ธรรม | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0gxcitbntelu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูกู๊ดเนเบอร์',
  m.joinDate,
  'โทร 093-0421241',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพร'
  AND m.lastName = 'พัฒนพงษ์ธรรม'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 73: นางสาวนภัสสร เมอโปดู่ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0t0xcvpg9bve',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  'โทร 063-1521161',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนภัสสร'
  AND m.lastName = 'เมอโปดู่'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 74: นางชมกนก รัตนจำรูญสกุล | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08ye3ctprr7h',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  'โทร 084-4956966',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางชมกนก'
  AND m.lastName = 'รัตนจำรูญสกุล'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 75: นางสาวจิตรา ปาสาบุตร | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08mntv2p9r4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  'โทร 093-1560821',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิตรา'
  AND m.lastName = 'ปาสาบุตร'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 76: นายพงศกร ใจโปธา(น้าสาม) | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0iahn18c73d8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 095-4681146',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพงศกร'
  AND m.lastName = 'ใจโปธา(น้าสาม)'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 77: นางสาวบัวฟอง ไทยใหญ่ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0oy521qu0db',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  'โทร 080-3975581',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวบัวฟอง'
  AND m.lastName = 'ไทยใหญ่'
  AND (s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%' OR s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 78: นายณัฐพล ศรีวิชัย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09ybyh57lvoc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียนบ้านห้วยหก',
  m.joinDate,
  'โทร 0876841608',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐพล'
  AND m.lastName = 'ศรีวิชัย'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 79: นางสาวเกศริน ธิยศ | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pbumqboq5qm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0882905507',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกศริน'
  AND m.lastName = 'ธิยศ'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 80: นายวรายุทธ ไชยช่อฟ้า | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wjvzll9ye5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0828988922',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวรายุทธ'
  AND m.lastName = 'ไชยช่อฟ้า'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 81: นางสาวสรัลชนา นันตา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dbl3mvmdmas',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0803796157',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสรัลชนา'
  AND m.lastName = 'นันตา'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 82: นางสาวพรธิตา สีใจมา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jqi3ej8p1w',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0820586956',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพรธิตา'
  AND m.lastName = 'สีใจมา'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 83: นางสาวนฤมล อภิวงษา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0s6p1mothbj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0842142591',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนฤมล'
  AND m.lastName = 'อภิวงษา'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 84: นางสาวธัญญารักษ์ ไชยวงค์คำ | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0vh5q3bvwql',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0971964847',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญญารักษ์'
  AND m.lastName = 'ไชยวงค์คำ'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 85: นางสาวสุชาดา ก้อนทองไทย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0unawoux5xq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 0612138935',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชาดา'
  AND m.lastName = 'ก้อนทองไทย'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 86: นายสมพร ประเสริฐไทย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0o68ezbpyz8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 0800734104',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมพร'
  AND m.lastName = 'ประเสริฐไทย'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 87: นางสาวณัณภัส กันแก้ว | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w04efvolhij4s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการโรงเรียน',
  m.joinDate,
  'โทร 0624414689',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัณภัส'
  AND m.lastName = 'กันแก้ว'
  AND (s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%' OR s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 88: นางสาวธัญนันท์ สุขเกษม | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0e0cbs2l5g4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 087-1601066',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญนันท์'
  AND m.lastName = 'สุขเกษม'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 89: นางสาววรัญญา จันทร์พรมมา | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0gzd8989rsyw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 088-2367147',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรัญญา'
  AND m.lastName = 'จันทร์พรมมา'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 90: นางสาวนภาพร ปินทรายมูล | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09yeik7ekrak',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 066-1426465',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนภาพร'
  AND m.lastName = 'ปินทรายมูล'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 91: นางสาวจันทนี คำดี | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0rf5mcnwoa8c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 086-6715489',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจันทนี'
  AND m.lastName = 'คำดี'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 92: นางสาวภณิดา วังแก้ว | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0r4giyzdnc6r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 080-4612740',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภณิดา'
  AND m.lastName = 'วังแก้ว'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 93: นายนนท์ ศรีวิชัย | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sscn849ckt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-9459496',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนนท์'
  AND m.lastName = 'ศรีวิชัย'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 94: นางชวัลลักษณ์ อินเรือง | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nfyqs4iwcsh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-0583883',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางชวัลลักษณ์'
  AND m.lastName = 'อินเรือง'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 95: นางสาวสุชาดา ยานะ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ytocno8d1b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 097-4652963',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชาดา'
  AND m.lastName = 'ยานะ'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 96: นางสาวนริศรา วงค์สุรินทร์ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0w5adkziadf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 090-3240057',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนริศรา'
  AND m.lastName = 'วงค์สุรินทร์'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 97: นายสุรพันธ์ วัฒนปัญญานนท์ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0vvzd86wtrib',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 087-0307021',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรพันธ์'
  AND m.lastName = 'วัฒนปัญญานนท์'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 98: นายสุรชาติ อาหยิ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cou5f63x44l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 097-9538389',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรชาติ'
  AND m.lastName = 'อาหยิ'
  AND (s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%' OR s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 99: นายภานุวัฒน์ นะที | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w06qmsf15rjc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อํานวยการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภานุวัฒน์'
  AND m.lastName = 'นะที'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 100: จ.ส.อ.นัทธพงศ์ คําแผ่นชัย | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hq7fw6osgo5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อํานวยการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'จ.ส.อ.นัทธพงศ์'
  AND m.lastName = 'คําแผ่นชัย'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 101: นายวีระศักดิ์ อุดทา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pggke7lxxsg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวีระศักดิ์'
  AND m.lastName = 'อุดทา'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 102: นาวสาวมานิดา เสาวรส | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ajvk6cwg5m9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นาวสาวมานิดา'
  AND m.lastName = 'เสาวรส'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 103: นายฤทธิชัย ใหญ่พงค์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fhqfd9e44wh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฤทธิชัย'
  AND m.lastName = 'ใหญ่พงค์'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 104: นายอัครา ปินตารักษ์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0xtq55guiv8i',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอัครา'
  AND m.lastName = 'ปินตารักษ์'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 105: นางสาวยุพาพร ถมหนวด | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0vki5ykcwbul',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวยุพาพร'
  AND m.lastName = 'ถมหนวด'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 106: นายพิรุฬห์วัฒน์ วัดคํา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0biks90fdt2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิรุฬห์วัฒน์'
  AND m.lastName = 'วัดคํา'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 107: นางสาวแสงเทียน คําน้อย | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0luj2iy1218o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวแสงเทียน'
  AND m.lastName = 'คําน้อย'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 108: นางสาววารี ศรีวรนันท์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0kxa6kh1x99o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววารี'
  AND m.lastName = 'ศรีวรนันท์'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 109: นายไกรสร แซ่ฟุ้ง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fzxmraie1ze',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไกรสร'
  AND m.lastName = 'แซ่ฟุ้ง'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 110: นางพัชรินทร์ คีรีแสนใจ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fwu0fy5cvm6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางพัชรินทร์'
  AND m.lastName = 'คีรีแสนใจ'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 111: นางสาวปวีณา จํามิ่ง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fi250n8hbii',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปวีณา'
  AND m.lastName = 'จํามิ่ง'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 112: นายจิรภัทร ตันมา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07knjdnjrccf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิรภัทร'
  AND m.lastName = 'ตันมา'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 113: นางสาวเกวลี พินิจ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dqgm7pg81z',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกวลี'
  AND m.lastName = 'พินิจ'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 114: นางสาวปณิตา แสนปัญญา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0rj98gseuoon',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปณิตา'
  AND m.lastName = 'แสนปัญญา'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 115: นางสาววราพร ก๋าแปง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ooq4hifbzqa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววราพร'
  AND m.lastName = 'ก๋าแปง'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 116: นางสาวสุนิสา สุกุล | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0d7b9tfg7yf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุนิสา'
  AND m.lastName = 'สุกุล'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 117: นางสาวจิราพร  ปัญญาฟู | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0qeziqpeo09',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิราพร'
  AND m.lastName = 'ปัญญาฟู'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 118: นางสาณัฐกาญ จันทะวงค์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0c7ghb0tkh2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาณัฐกาญ'
  AND m.lastName = 'จันทะวงค์'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 119: นางสาวอัมรา นันท์โภคินวงษ์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05tufouuimc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัมรา'
  AND m.lastName = 'นันท์โภคินวงษ์'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 120: นางสาวอารีรัตน์ มณีจันทร์สุข | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0egff57mssc8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอารีรัตน์'
  AND m.lastName = 'มณีจันทร์สุข'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 121: นายวรเชษฐ ทิพย์ดวง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0k3dz5c1gsta',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวรเชษฐ'
  AND m.lastName = 'ทิพย์ดวง'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 122: นางสาวมลธิรา  ใจปิง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08osd6eu8w6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมลธิรา'
  AND m.lastName = 'ใจปิง'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 123: นางสาววิไลรัตน์ มาเยอะ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0xhz1vmsjjif',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูธุรการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิไลรัตน์'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 124: นางภัทรวดี ชํานาญยา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dlwygok3wq6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางภัทรวดี'
  AND m.lastName = 'ชํานาญยา'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 125: นางสาวเอณิกา วงค์เมืองแล | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0uczw4u566v',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเอณิกา'
  AND m.lastName = 'วงค์เมืองแล'
  AND (s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%' OR s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 126: นายธีรพล ทาใหม่ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0d5wupqhpv1g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผอ.รร.',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธีรพล'
  AND m.lastName = 'ทาใหม่'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 127: นางรัตนา วะไลใจ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0w1rrs6qxero',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางรัตนา'
  AND m.lastName = 'วะไลใจ'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 128: นางสาวบานเย็น ศรีคำ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jy1m0yqq8er',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวบานเย็น'
  AND m.lastName = 'ศรีคำ'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 129: นางสาวณปภัช ทองหลอม | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fqy9qblmscp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณปภัช'
  AND m.lastName = 'ทองหลอม'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 130: นายฤทธินนท์ จันดีวันนา | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0uremkklcjqe',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฤทธินนท์'
  AND m.lastName = 'จันดีวันนา'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 131: นายธนาธิป อุทธิยา | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09zsnb9n75du',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนาธิป'
  AND m.lastName = 'อุทธิยา'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 132: นายคมภูศิษฐ์ นัฐธนากาญจน์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pwtcco3zrc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคมภูศิษฐ์'
  AND m.lastName = 'นัฐธนากาญจน์'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 133: นางสาวธัญสีนี ชูเพชรสมบูรณ์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0r4j79y5xx1',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญสีนี'
  AND m.lastName = 'ชูเพชรสมบูรณ์'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 134: นางสาวภัทราพร โนจิตร | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0za1a5d5q89',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัทราพร'
  AND m.lastName = 'โนจิตร'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 135: นางสาวกานต์ชนิต แสงแก้ว | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00htti6ud8fqj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกานต์ชนิต'
  AND m.lastName = 'แสงแก้ว'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 136: นางสาวฐิตาพร ชูทอง | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0atvm8j74ox9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฐิตาพร'
  AND m.lastName = 'ชูทอง'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 137: นางกรพันธุ์ จินะเทศ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fodisgdd6h4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกรพันธุ์'
  AND m.lastName = 'จินะเทศ'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 138: นายยุทธติกาล มหายศกุล | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0b43fil0kcsd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยุทธติกาล'
  AND m.lastName = 'มหายศกุล'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 139: นางสาวอภิสรา อนันต์พระคุณ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05wwm0o9vzxb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอภิสรา'
  AND m.lastName = 'อนันต์พระคุณ'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 140: นายอริญชย์ วะรีวะราช | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0795xf3o0cpv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการโรงเรียน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอริญชย์'
  AND m.lastName = 'วะรีวะราช'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 141: นายธนฤทธิ์ ชัยวรรณ์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wbvyvvjd2te',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พี่เลี้ยงเด็กพิการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนฤทธิ์'
  AND m.lastName = 'ชัยวรรณ์'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 142: นายบุญคง คืนมาเมือง | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w081lj3mg7yhj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ช่างไฟฟ้า ระดับ 4',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายบุญคง'
  AND m.lastName = 'คืนมาเมือง'
  AND (s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 143: นายวันชัย ชื่นตา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w031jmokxmnoa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผอ.',
  m.joinDate,
  'โทร 085-7242631',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวันชัย'
  AND m.lastName = 'ชื่นตา'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 144: นายปิยวัฒน์ ก๋าใจคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0slza4rdpvd8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รอง ผอ.',
  m.joinDate,
  'โทร 095-4489477',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายปิยวัฒน์'
  AND m.lastName = 'ก๋าใจคำ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 145: นายพิชัย ก่ำแก้ว | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hzlmcbdde96',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รอง ผอ.',
  m.joinDate,
  'โทร 093-1457052',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิชัย'
  AND m.lastName = 'ก่ำแก้ว'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 146: นายสงคราม กิตติกาจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00olvph312qyn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 089-8531875',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสงคราม'
  AND m.lastName = 'กิตติกาจ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 147: นายประเชิญ ต๊ะวิชัย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0k5euy3w5eza',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 097-3397205',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายประเชิญ'
  AND m.lastName = 'ต๊ะวิชัย'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 148: นายพิทยุตม์ จุมปา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0b0w0ar67vwo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 097-9231010',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิทยุตม์'
  AND m.lastName = 'จุมปา'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 149: นายพิเชษฐ์ แสนสุข | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0kzxb81oudwi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 061-6861222',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิเชษฐ์'
  AND m.lastName = 'แสนสุข'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 150: นายทัศนัย ใจกาวิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nl6qdlzgv9k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 093-1366939',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายทัศนัย'
  AND m.lastName = 'ใจกาวิน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 151: นายมาโนช สุวรรณ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0t862drlvina',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 094-6087718',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายมาโนช'
  AND m.lastName = 'สุวรรณ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 152: นางสาวดวงพิกุล ชัยวร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01gj6v5wy0mc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 093-1325068',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวดวงพิกุล'
  AND m.lastName = 'ชัยวร'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 153: นางณัชชา ภูมิเรศสุนทร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mo5rvsu1w7b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 089-9525410',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางณัชชา'
  AND m.lastName = 'ภูมิเรศสุนทร'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 154: นางรสรินทร์ กิตติกาจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ixowa7u30q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 087-1734667',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางรสรินทร์'
  AND m.lastName = 'กิตติกาจ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 155: นางกนกพร อานุ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wro5iprmtr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 081-7467090',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกนกพร'
  AND m.lastName = 'อานุ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 156: นางสาวนิตยา สักแสน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wltvq6m58f',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 089-7563466',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิตยา'
  AND m.lastName = 'สักแสน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 157: นางสาวปัทมาภรณ์ ถิ่นการ์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sorndmnzqji',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 088-2250474',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปัทมาภรณ์'
  AND m.lastName = 'ถิ่นการ์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 158: นางสาวชยาภรณ์ แซ่เฮ่อ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0i1zk1fceyzc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 065-0316925',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชยาภรณ์'
  AND m.lastName = 'แซ่เฮ่อ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 159: นางสาวรุ่งทิวา ยวงอินแปลง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05lgacpbhyz',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 082-4809551',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรุ่งทิวา'
  AND m.lastName = 'ยวงอินแปลง'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 160: นางสาวกนกอร จิตอ่อนน้อม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05ipirbx9n4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 086-1856195',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกอร'
  AND m.lastName = 'จิตอ่อนน้อม'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 161: นางสาวเปรมยุดา รากะรินทร์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0j05pcyczmxj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูคศ.1',
  m.joinDate,
  'โทร 091-7133870',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเปรมยุดา'
  AND m.lastName = 'รากะรินทร์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 162: นางสาวกนกพร ทิศเชย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w050etuvvw1sw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 083-9410364',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกพร'
  AND m.lastName = 'ทิศเชย'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 163: นายกฤษขจร ฟ้าเลิศ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0rfm6lzzjvkj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 082-4809288',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกฤษขจร'
  AND m.lastName = 'ฟ้าเลิศ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 164: นายภากร บัวทิม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00vppc5myqw89',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 658318851',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภากร'
  AND m.lastName = 'บัวทิม'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 165: นางสาววันพร เขื่อนคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mr90llutpsr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 090-0542472',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววันพร'
  AND m.lastName = 'เขื่อนคำ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 166: นางสาวอาภัสรา วังทิพย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0kxi1gcfya7j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 082-7646672',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอาภัสรา'
  AND m.lastName = 'วังทิพย์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 167: นางสาวพิมพ์พร ผัดขัน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sbk2429qev',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 090-1320591',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์พร'
  AND m.lastName = 'ผัดขัน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 168: นางสาวกนกพิชญ์ กาญจนวาส | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0509ksqxwbc7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 082-1602038',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกพิชญ์'
  AND m.lastName = 'กาญจนวาส'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 169: นางสาวชวัลรัตน์ สุริยะ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dayvnvok246',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-2731683',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชวัลรัตน์'
  AND m.lastName = 'สุริยะ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 170: นางสาวนิตฐินันท์ สนธิคุณ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0lqkea3sey5j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 080-0412835',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิตฐินันท์'
  AND m.lastName = 'สนธิคุณ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 171: นางสาวภาณุมาศ พลวิทย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07309qsgqiqh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-665-6996',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภาณุมาศ'
  AND m.lastName = 'พลวิทย์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 172: นายธนากร ทองเงา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w04907lgc7hwa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 095-7524838',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนากร'
  AND m.lastName = 'ทองเงา'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 173: นายพิสิทธิ์ โกเสนตอ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w04dczuxkrsgf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 087 5447241',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิสิทธิ์'
  AND m.lastName = 'โกเสนตอ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 174: นายธวัชชัย จันติ๊บ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ssj1on8a0re',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-3472982',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธวัชชัย'
  AND m.lastName = 'จันติ๊บ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 175: นางสาวพิมวิไล ตาบุญใจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bn6z8ya3mn8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 062-4872741',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมวิไล'
  AND m.lastName = 'ตาบุญใจ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 176: นางสาวสุทธิดา มุงเมือง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0co1tkpwt1g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 095-3287851',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุทธิดา'
  AND m.lastName = 'มุงเมือง'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 177: นายนัทธวุฒิ โสรินทร์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0oj2cxk57jrm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 987538430',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนัทธวุฒิ'
  AND m.lastName = 'โสรินทร์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 178: นายเอกรินทร์ อิ่นคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hmagv8zlmrc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 931480700',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกรินทร์'
  AND m.lastName = 'อิ่นคำ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 179: นายศุภกฤต ฝั้นใจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cfhjm3fsjgt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 814676177',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศุภกฤต'
  AND m.lastName = 'ฝั้นใจ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 180: นางสาวภาสินี ทองรอบพิทักษ์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mq21oi338g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-1342911',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภาสินี'
  AND m.lastName = 'ทองรอบพิทักษ์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 181: นายสิงหา สุวรรณโค | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0azrt97bv2ip',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 931930759',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสิงหา'
  AND m.lastName = 'สุวรรณโค'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 182: นายวิกาวี ชัยอารีย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w02x0ew74jbhk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 636791988',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวิกาวี'
  AND m.lastName = 'ชัยอารีย์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 183: นายณัฐวุฒิ แดงปัดแหว๋ว | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pcq8qy024z',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 613734518',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐวุฒิ'
  AND m.lastName = 'แดงปัดแหว๋ว'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 184: นางสาววรัญญา ทับทิมหิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0puhdxj92d5r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 822538772',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรัญญา'
  AND m.lastName = 'ทับทิมหิน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 185: นางสาวพิชามญชุ์ สายเพียร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mof7bc0qabp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 655069062',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิชามญชุ์'
  AND m.lastName = 'สายเพียร'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 186: นายเสกสรรค์ จันแปงเงิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bz9vnq1nmf5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 088-5564326',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเสกสรรค์'
  AND m.lastName = 'จันแปงเงิน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 187: นางสาวพิทยา พรรดา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w029u502suk8v',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 638239692',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิทยา'
  AND m.lastName = 'พรรดา'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 188: นายพิเชฐ พินิจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hpswxtkz54',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 091-2715313',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิเชฐ'
  AND m.lastName = 'พินิจ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 189: นางสาววริชญา ชาวน่าน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0a1ogpky2ud',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 062-5165273',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววริชญา'
  AND m.lastName = 'ชาวน่าน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 190: นายชยากร อุ่นธง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nok1pyw3t4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 803630998',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชยากร'
  AND m.lastName = 'อุ่นธง'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 191: นางสาวศุภกานต์ ไชยโย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tsy1lp66wk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 092-2870976',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศุภกานต์'
  AND m.lastName = 'ไชยโย'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 192: นายญาณัคร์พนิต คำผง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00leylq4dh2z',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 957345731',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายญาณัคร์พนิต'
  AND m.lastName = 'คำผง'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 193: นางสาวพัณณกร วังแจ่ม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0919a5nwmefm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 650026013',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัณณกร'
  AND m.lastName = 'วังแจ่ม'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 194: นายสมพร แสนก่อ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cyl38nw1376',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 092-7954173',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมพร'
  AND m.lastName = 'แสนก่อ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 195: นายสายไทย สีอมย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0al47k2skwhq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 089-4318697',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสายไทย'
  AND m.lastName = 'สีอมย'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 196: นางสาวนิตยา หน่อวัน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jiz6hgkkgjf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  'โทร 095-1341572',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิตยา'
  AND m.lastName = 'หน่อวัน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 197: นายศักดา ธนพชรรัชต์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0btmtoev8z3n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 092-6997876',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศักดา'
  AND m.lastName = 'ธนพชรรัชต์'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 198: นายภีรดาดลย์ ไชยพูน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0o0lbw1iz6f8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 093-1349584',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภีรดาดลย์'
  AND m.lastName = 'ไชยพูน'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 199: น.ส.ประไพ เชอมือ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tegf0ga2eta',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 064-0173381',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'น.ส.ประไพ'
  AND m.lastName = 'เชอมือ'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 200: นายนามติ๊บ ธรรมใส | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sv60iteg20k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนามติ๊บ'
  AND m.lastName = 'ธรรมใส'
  AND (s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%' OR s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 201: นางสาวมัญชุสา เพ็ชรชนะ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bzs4ejhn35',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 093-1375973',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมัญชุสา'
  AND m.lastName = 'เพ็ชรชนะ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 202: นางสาววรรณภัทร วรวัฒน์รัชกุล | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cbs48zhente',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 084-6327587',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรณภัทร'
  AND m.lastName = 'วรวัฒน์รัชกุล'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 203: นายรุ่งโรจน์ ร้องสาคร | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sp8ih0r17kb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 080-8503403',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายรุ่งโรจน์'
  AND m.lastName = 'ร้องสาคร'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 204: นายสมเกียรติ กิติคำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w048infzwmlgb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 098-7791219',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมเกียรติ'
  AND m.lastName = 'กิติคำ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 205: นางสาววิรัญชนา พระคุณวรกาญจน์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0e07iyeb7tm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 089-5583213',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิรัญชนา'
  AND m.lastName = 'พระคุณวรกาญจน์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 206: นางสาวอมรรัตน์ ปนคำปิน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01qa64nd2ji2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 082-6652962',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอมรรัตน์'
  AND m.lastName = 'ปนคำปิน'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 207: นายธนาวุธ นามวงค์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sipcowh9r4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 081-3772842',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนาวุธ'
  AND m.lastName = 'นามวงค์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 208: นายไกรระวี จันต๊ะคาด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w06wpcbx42tbf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 091-0712316',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไกรระวี'
  AND m.lastName = 'จันต๊ะคาด'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 209: นางสาวธณัชชา ใจอารีย์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dxre5ocrd0q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 086-4291972',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธณัชชา'
  AND m.lastName = 'ใจอารีย์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 210: นางสาววรัชยาสิริ บัวผัด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0whynpj84j7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 092-8328981',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรัชยาสิริ'
  AND m.lastName = 'บัวผัด'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 211: นางสาวสิรินันท์ แก้วยองผาง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00ae7wdktxn4d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 095-6786501',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิรินันท์'
  AND m.lastName = 'แก้วยองผาง'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 212: นางสาวจริยา เอกจันทร์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mtngvyfw4fo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 097-9309385',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจริยา'
  AND m.lastName = 'เอกจันทร์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 213: นางสาวฐิติรัตน์ ใจอ้าย | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0r4dbnvr76ek',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 094-9408349',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฐิติรัตน์'
  AND m.lastName = 'ใจอ้าย'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 214: นายสุวิจักขณ์ บุญวงศ์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ad5fvnlr5f',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 097-9787832',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุวิจักขณ์'
  AND m.lastName = 'บุญวงศ์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 215: นายภานุพงศ์ แจขจัด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08rahevjoa1',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-745-4678',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภานุพงศ์'
  AND m.lastName = 'แจขจัด'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 216: นางอักษรา ตาลำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00lvwvrmhspu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 086-1885482',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางอักษรา'
  AND m.lastName = 'ตาลำ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 217: นางสาวธัญญารัตน์ ยาวิละ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ltx8byankwp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-7369826',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญญารัตน์'
  AND m.lastName = 'ยาวิละ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 218: นายนิธิศ จะตุแสน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fxjp5miyl5r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-3765364',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนิธิศ'
  AND m.lastName = 'จะตุแสน'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 219: นางสาวปัทมา สุวรรณ์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w014582eofboe',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 080-4426048',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปัทมา'
  AND m.lastName = 'สุวรรณ์'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 220: นางสาวการต์พิชชา ขันโท | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09ujxardkku8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2652647',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวการต์พิชชา'
  AND m.lastName = 'ขันโท'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 221: นางสาวนิรมล ศรีทอง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w06p5kdzrhx1h',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 090-3232994',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิรมล'
  AND m.lastName = 'ศรีทอง'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 222: นางสาวนภัสสร อรุณฟอง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0kt7qcdxdr19',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-9047069',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนภัสสร'
  AND m.lastName = 'อรุณฟอง'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 223: นางสาวเจนจิรา จันทาพูน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01p6y6o74tjw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 082-0950255',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเจนจิรา'
  AND m.lastName = 'จันทาพูน'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 224: นางสาวทิพวรรณ์ จันทร์เพ็ญ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tunq49x5bms',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 062-5303267',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวทิพวรรณ์'
  AND m.lastName = 'จันทร์เพ็ญ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 225: นางสาวเมธยา ทะคำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ouu1hipmpkr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-6751661',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเมธยา'
  AND m.lastName = 'ทะคำ'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 226: นางสาวพิยดา ไชยลังกา | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nm2rbiszmhm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-2109750',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิยดา'
  AND m.lastName = 'ไชยลังกา'
  AND (s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 227: นางสาวศศิกานต์ เตจ๊ะวันดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hvt0q1m7n5t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 088-2667412',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศศิกานต์'
  AND m.lastName = 'เตจ๊ะวันดี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 228: นายเสน่ห์ สุธรรม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w02upba7xt3gw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 091-8593405',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเสน่ห์'
  AND m.lastName = 'สุธรรม'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 229: นางสาวจิราภรณ์ มงคลดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wnvh40anv4g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 083-5700850',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิราภรณ์'
  AND m.lastName = 'มงคลดี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 230: นายสุรศักดิ์ นารี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0w6ig904fnv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 064-4746342',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรศักดิ์'
  AND m.lastName = 'นารี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 231: นางสาวปทมา ชัยโรจน์วงศ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00cs2hox5zqyr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-7592028',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปทมา'
  AND m.lastName = 'ชัยโรจน์วงศ์'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 232: นางสาวนฤมล โนฤทธิ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0uovih3he51r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 065-4966704',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนฤมล'
  AND m.lastName = 'โนฤทธิ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 233: นางสาวสิริรัตน์ พันธ์วิไล | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0p5q0eit9te',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-0967132',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิริรัตน์'
  AND m.lastName = 'พันธ์วิไล'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 234: นางสาววดี ดีปัญญา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0f6sj9kvlq8g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 064-2538600',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววดี'
  AND m.lastName = 'ดีปัญญา'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 235: นางสาวสุจิตรา กว้าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0z15v3x1d4qh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-0841022',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุจิตรา'
  AND m.lastName = 'กว้าง'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 236: นางสาวอัญชลี สุธีราช | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0efplv7vcthn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-5411047',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = 'สุธีราช'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 237: นายอภิรักษ์ สุวรรณ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sui6oddk8w8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-7582878',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอภิรักษ์'
  AND m.lastName = 'สุวรรณ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 238: นายพิทักษ์ วงศ์บุญมา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0x4gf3hnk5u9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 091-8581370',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิทักษ์'
  AND m.lastName = 'วงศ์บุญมา'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 239: นางสาวณัฏฐินดา สีปโภคา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0zuwoq4ocdu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 083-0508745',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฏฐินดา'
  AND m.lastName = 'สีปโภคา'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 240: นางสาวกรกฏ อินทร์การทุม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0h3bxj67sxg8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 083-4418019',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกรกฏ'
  AND m.lastName = 'อินทร์การทุม'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 241: นายปรีชา เชยบุญเรือง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0of6xrvokaj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 089-2662066',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายปรีชา'
  AND m.lastName = 'เชยบุญเรือง'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 242: นางสาวพัชรา ทะยืน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w045uezn8zakp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9264119',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรา'
  AND m.lastName = 'ทะยืน'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 243: นายชัชชุพงศ์ กรรณิกา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0xtfr0h3u4qs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-2847278',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชัชชุพงศ์'
  AND m.lastName = 'กรรณิกา'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 244: นางสาวกรกนก สัญเพ็ชร | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0svkt7fh5kle',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 088-2317990',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกรกนก'
  AND m.lastName = 'สัญเพ็ชร'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 245: นางสาวรุ่งนภา รินแก้ว | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0lyvvsah05g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-9316397',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรุ่งนภา'
  AND m.lastName = 'รินแก้ว'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 246: นางสาววรรณพร รักห้วม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ll14kcb4q29',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-8907202',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรณพร'
  AND m.lastName = 'รักห้วม'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 247: นางสาววาสินี สุวรรณกาน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w02vkclinwfs6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-5701616',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววาสินี'
  AND m.lastName = 'สุวรรณกาน'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 248: นางสาวชมนุษย์ สวัสดิ์กิจ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w049863a860yt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 065-2561519',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชมนุษย์'
  AND m.lastName = 'สวัสดิ์กิจ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 249: นางสาวอภิญญา เกิดสกล | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0m2o23uoqe7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-1699616',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอภิญญา'
  AND m.lastName = 'เกิดสกล'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 250: นายสมเกตุ แสงจันทร์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0peprpi0es3g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-6383385',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมเกตุ'
  AND m.lastName = 'แสงจันทร์'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 251: นางสาวไอรดา ศรีสวัสดิ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bxsl50z6lr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-6285268',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวไอรดา'
  AND m.lastName = 'ศรีสวัสดิ์'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 252: นางสาวภัทรศิริ หอมดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0swlkibshhaa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-6437882',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัทรศิริ'
  AND m.lastName = 'หอมดี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 253: นางสาววิญญา อินต๊ะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05u6kyv4hg9j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 086-1817961',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิญญา'
  AND m.lastName = 'อินต๊ะ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 254: นายศราวุธ ยิ้มงาม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w073go6o2xvif',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 063-5955841',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศราวุธ'
  AND m.lastName = 'ยิ้มงาม'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 255: นายเกริกพล ชัตตะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0t62yi1cq6r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 091-4837306',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเกริกพล'
  AND m.lastName = 'ชัตตะ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 256: นายสรชัย แซ่ห้าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ztgugdejgh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 086-1849819',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสรชัย'
  AND m.lastName = 'แซ่ห้าง'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 257: นางสาวณัสสร แซ่ย่าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08ofb39c2mgt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 080-8541343',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัสสร'
  AND m.lastName = 'แซ่ย่าง'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 258: นางสาวนิกาพร มีชัย | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0svu1d78nhln',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 090-3268944',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิกาพร'
  AND m.lastName = 'มีชัย'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 259: นางสาวกรกัญญา ชมภูเกตุ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0o8vekovvfxd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 090-3161901',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกรกัญญา'
  AND m.lastName = 'ชมภูเกตุ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 260: นางสาวปริชาติ งานดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0z78ka1iw1vh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 090-3192619',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปริชาติ'
  AND m.lastName = 'งานดี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 261: นายทศพล สุคำ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0lsqfffbefm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-5661321',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายทศพล'
  AND m.lastName = 'สุคำ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 262: นางสาวมาลินี รักษ์อินทร์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0p27dcd3k8aq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 097-9956706',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมาลินี'
  AND m.lastName = 'รักษ์อินทร์'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 263: นางสาวมณีรัตน์ สมฤทธิ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0w4ftk6v2qnc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-3593789',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมณีรัตน์'
  AND m.lastName = 'สมฤทธิ์'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 264: นางสาวภัทรา ใจผ่อง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0v4bjpoh6xq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-5654822',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัทรา'
  AND m.lastName = 'ใจผ่อง'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 265: นางสาวอรุณนาท ตั้งศิริ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0qorb9smtn6b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 065-0284281',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรุณนาท'
  AND m.lastName = 'ตั้งศิริ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 266: นายวชิรชัย มีบุญ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nt3r7lxrug',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 089-8521980',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวชิรชัย'
  AND m.lastName = 'มีบุญ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 267: นางสาวพิมพ์รัตน์ เชื้อเมืองพาน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0taq0vedmjam',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 086-9181624',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์รัตน์'
  AND m.lastName = 'เชื้อเมืองพาน'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 268: นายพรรษา ทำโมนะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ycb321goqf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการโรงเรียน',
  m.joinDate,
  'โทร 083-2657809',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพรรษา'
  AND m.lastName = 'ทำโมนะ'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 269: นางสาวโชตินภา สมองฟ้าไกร | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w00ehttglc7sha',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 093-3614188',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวโชตินภา'
  AND m.lastName = 'สมองฟ้าไกร'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 270: นายจิราวุฒิ แก้วสี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0uuhqoa8kf5l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 065-2718358',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิราวุฒิ'
  AND m.lastName = 'แก้วสี'
  AND (s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%' OR s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 271: นายพิชชากร  อานุ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w08j52c2katd7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิชชากร'
  AND m.lastName = 'อานุ'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 272: นางกฤษกร เรืองวิทยนันท์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0wh1smu0243e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกฤษกร'
  AND m.lastName = 'เรืองวิทยนันท์'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 273: นางสาววรรนิสา กุญชร | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w081ttfe4k7gp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรนิสา'
  AND m.lastName = 'กุญชร'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 274: นางสาวณัฐิภา  ปัญญาแก้ว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0z3kw1h5us2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐิภา'
  AND m.lastName = 'ปัญญาแก้ว'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 275: นางสาวภัควลัญจน์ จันทร์ไชยวงศ์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05a7ieumkiex',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัควลัญจน์'
  AND m.lastName = 'จันทร์ไชยวงศ์'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 276: นางสาวขวัญมนัส  ทำทาน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0dh3qsk4ghxv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวขวัญมนัส'
  AND m.lastName = 'ทำทาน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 277: นายสุธินันท์  คำแสน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0jvvl0ene1se',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุธินันท์'
  AND m.lastName = 'คำแสน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 278: นางประภัสวรรณ เชื้อเมืองพาน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07qvr11qs7tk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางประภัสวรรณ'
  AND m.lastName = 'เชื้อเมืองพาน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 279: นายเดชณรงค์  คบลา | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0gdc6evwsayb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเดชณรงค์'
  AND m.lastName = 'คบลา'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 280: นางสาวอชิรญา  ช่างเขียน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0z781hbfvzfc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอชิรญา'
  AND m.lastName = 'ช่างเขียน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 281: นางธารทิพย์  นรรัตน์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tzup4f6th6e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางธารทิพย์'
  AND m.lastName = 'นรรัตน์'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 282: นางสาวณัฐณิชา แสงนิล | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w064m3a3wdu4t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐณิชา'
  AND m.lastName = 'แสงนิล'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 283: นางสาวปรารถนา สร้างโศรก | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bfz7jcc4ujd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปรารถนา'
  AND m.lastName = 'สร้างโศรก'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 284: นายสุทิน เขื่อนคำแสน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0qp3ofc15lx9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุทิน'
  AND m.lastName = 'เขื่อนคำแสน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 285: นายยศพล ศรีอัญชลีกร | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tmcjcyna03',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยศพล'
  AND m.lastName = 'ศรีอัญชลีกร'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 286: นางสาววิเศษลักษณ์  วงศ์เป็ง | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0hf64kgv4mgs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิเศษลักษณ์'
  AND m.lastName = 'วงศ์เป็ง'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 287: นางสาวเจษสุภาภรณ์ คำปวน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w012tdob4yoocc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเจษสุภาภรณ์'
  AND m.lastName = 'คำปวน'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 288: นายภูริทัต  อินทรประเสริฐ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0l4gwdsbgo19',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภูริทัต'
  AND m.lastName = 'อินทรประเสริฐ'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 289: นางสาวสุภนุช จิตสวา | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01rz71gvpq7z',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุภนุช'
  AND m.lastName = 'จิตสวา'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 290: นายอะแล  มาเยอะ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mfjvhgydtao',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอะแล'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 291: นางสาวหมี่ตุ แซ่จ๋าว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01tl354h1dpa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหมี่ตุ'
  AND m.lastName = 'แซ่จ๋าว'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 292: นางวิรศรา  แซ่ฮ่อ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0cepq4u01jz7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางวิรศรา'
  AND m.lastName = 'แซ่ฮ่อ'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 293: นางสาวหมี่โผ่ แซ่จ๋าว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w01rqatqa2hkn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหมี่โผ่'
  AND m.lastName = 'แซ่จ๋าว'
  AND (s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%' OR s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 294: นายชำนาญ บอแฉ่ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0l0y0srirv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 0807905583',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชำนาญ'
  AND m.lastName = 'บอแฉ่'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 295: นางสาวชามรี ระวังทรัพย์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0xezhq9ur1rj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 0834799281',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชามรี'
  AND m.lastName = 'ระวังทรัพย์'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 296: นางสาวสุพรรณษา คอง | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sjnzwqalhyf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0882242395',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุพรรณษา'
  AND m.lastName = 'คอง'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 297: นายกฤษฎาภูมิ ไชยภูมิ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pkqvlgji0fp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0869239061',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกฤษฎาภูมิ'
  AND m.lastName = 'ไชยภูมิ'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 298: นางสาวปิ่นทิพย์ ผาสุวรรณ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0srtpfo6te5k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0645432664',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปิ่นทิพย์'
  AND m.lastName = 'ผาสุวรรณ'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 299: นางสาวชญานี โพธิ์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w09jsusg4uvc4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0972989779',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชญานี'
  AND m.lastName = 'โพธิ์'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 300: นางสาวเบญจวรรณ เตปินใจ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0lep7deq8d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0887741277',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเบญจวรรณ'
  AND m.lastName = 'เตปินใจ'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 301: นางสาวธัญญพัทธ์ ธนกฤษไพศย์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0x1njl7xir2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 0863675280',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญญพัทธ์'
  AND m.lastName = 'ธนกฤษไพศย์'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 302: นางสาวตุ๊ดนันท์ ชาวเหนือ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0awfvw40kexi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 0910710952',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวตุ๊ดนันท์'
  AND m.lastName = 'ชาวเหนือ'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 303: นางวิชญาดา จันลา | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0k7ykb81qjws',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 0817844584',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางวิชญาดา'
  AND m.lastName = 'จันลา'
  AND (s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 304: นายดนัยวัฒน์  มณี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0sgc1i6o1pw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 082-5915326',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายดนัยวัฒน์'
  AND m.lastName = 'มณี'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 305: นายภูมินทร์ แสงสร้อย | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0zla1fbydool',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9251551',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภูมินทร์'
  AND m.lastName = 'แสงสร้อย'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 306: นายสหัสวรรษ ศักภิวัล | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pskheyv9n59',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-7194151',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสหัสวรรษ'
  AND m.lastName = 'ศักภิวัล'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 307: นางสาวสุดา พรมตา | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05f12ys3igu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 061-5929222',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุดา'
  AND m.lastName = 'พรมตา'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 308: นายยุทธพงษ์ สุยะ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0ti3ijqpo6e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยุทธพงษ์'
  AND m.lastName = 'สุยะ'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 309: นายภัทรพล ศรีผาย | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0szd2yigak5i',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 081-3572080',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภัทรพล'
  AND m.lastName = 'ศรีผาย'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 310: นางสาวภัณฑิรา ยอดคีรี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0rkhaiayhogh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-5752946',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัณฑิรา'
  AND m.lastName = 'ยอดคีรี'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 311: นางสาวชลธิชา เขื่อนปัญญา | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w022twsavvkup',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-6919918',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชลธิชา'
  AND m.lastName = 'เขื่อนปัญญา'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 312: นางสาวรมณีย์  หล้าธิ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0qeoiix9kg6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-8840785',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรมณีย์'
  AND m.lastName = 'หล้าธิ'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 313: นางสาวไหนจ้อย  แซ่ลี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0asyxyq5n69',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-1577858',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวไหนจ้อย'
  AND m.lastName = 'แซ่ลี'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 314: นายชยาวุธ ปิติว่าเจริญ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w07gpxjpunu8p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชยาวุธ'
  AND m.lastName = 'ปิติว่าเจริญ'
  AND (s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 315: วาที่รอยเอกบรรจงฤทธิ์  สุทธสม | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tbrvzkkrqm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผูอํานวยการโรงเรียน',
  m.joinDate,
  'โทร 918400071',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'วาที่รอยเอกบรรจงฤทธิ์'
  AND m.lastName = 'สุทธสม'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 316: นายสุทิวัส ตติยะตนตระกูล | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0pzfk7y862a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชํานาญการ',
  m.joinDate,
  'โทร 997598441',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุทิวัส'
  AND m.lastName = 'ตติยะตนตระกูล'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 317: นางสาวกานทชญา พรมเสน | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0txhijfuigpt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 858685977',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกานทชญา'
  AND m.lastName = 'พรมเสน'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 318: นายชัยกาญจน นวลกําแหง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0yyrop09jlxf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 927692833',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชัยกาญจน'
  AND m.lastName = 'นวลกําแหง'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 319: นางสาวธาดารัตน อุดมปละ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w05zypopn9ktr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 651141704',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธาดารัตน'
  AND m.lastName = 'อุดมปละ'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 320: นางสาวกังสดาล ใจกลา | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bejdlitmj3s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 928294215',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกังสดาล'
  AND m.lastName = 'ใจกลา'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 321: นางสาวเกศินี วิชัยเนตร | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0nln3bf3v6eb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 982950564',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกศินี'
  AND m.lastName = 'วิชัยเนตร'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 322: นางสาวจารุวรรณ คําเหล็ก | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0bi1vrg5owi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 993780418',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'คําเหล็ก'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 323: นายกิตติภพ แซตัง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fr98a28xe',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผูชวย',
  m.joinDate,
  'โทร 941419092',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกิตติภพ'
  AND m.lastName = 'แซตัง'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 324: นายวรเชษฐ แววสี | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0putkiwthcfk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผูชวย',
  m.joinDate,
  'โทร 808245547',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวรเชษฐ'
  AND m.lastName = 'แววสี'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 325: นางสาวศันสนา ปวกหลวง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tdqfjdmhm3o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 844865092',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศันสนา'
  AND m.lastName = 'ปวกหลวง'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 326: นางสาวปยะนุช สุนาโท | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0mco2svwjcv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจาง',
  m.joinDate,
  'โทร 879653814',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปยะนุช'
  AND m.lastName = 'สุนาโท'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 327: นางสาวรัชฎา ตาฮง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0h6ei6ekag95',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผูชวยครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัชฎา'
  AND m.lastName = 'ตาฮง'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 328: นายสมศักดิ์ แซหมื่อ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0flqet5oj1et',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  'โทร 828312471',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมศักดิ์'
  AND m.lastName = 'แซหมื่อ'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 329: นายธนาพล มาเยอะ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fk7vzf4ex35',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 625707424',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนาพล'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%' OR s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 330: นางสาวสุดารัตน์ ปัญญาศิริวงศ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0f87at36urwa',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 086 395 1946',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุดารัตน์'
  AND m.lastName = 'ปัญญาศิริวงศ์'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 331: นางจีราพร อินทะนิล | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0a5qh2bbok35',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 085 723 5256',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางจีราพร'
  AND m.lastName = 'อินทะนิล'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 332: นายพงศ์พันธ์ โพธิ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0g3edlavb9w',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087 786 6616',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพงศ์พันธ์'
  AND m.lastName = 'โพธิ์'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 333: นายเนตรศักดิ์ เชียงเครือ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0fm3aw458wz',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095 290 8637',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเนตรศักดิ์'
  AND m.lastName = 'เชียงเครือ'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 334: นางสาวจินดารัตน์ บุปผฤกษ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w0tptl5ehj3d7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 092 896 5315',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจินดารัตน์'
  AND m.lastName = 'บุปผฤกษ์'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 335: นางสาวกาญจนา บุตรี | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15xlujwedfxi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 090 215 6584',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกาญจนา'
  AND m.lastName = 'บุตรี'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 336: นางสาวชมพร ติตนากาศ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1eigl0oz2vk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062 075 3430',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชมพร'
  AND m.lastName = 'ติตนากาศ'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 337: นางสาววิภาภัค กันตะยา | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bvhfhhdoi0u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 089 665 1664',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิภาภัค'
  AND m.lastName = 'กันตะยา'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 338: นางสาวเขมิกา เตมูลละ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1c07j93338u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094 613 4046',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเขมิกา'
  AND m.lastName = 'เตมูลละ'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 339: นางสาวสิเรชา รุ่งกานภาค | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gk56owvybfw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 085 189 8192',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิเรชา'
  AND m.lastName = 'รุ่งกานภาค'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 340: นายคณภัณฑ์ หมั่นสมบัติ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1l0tttil2qfd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 088 236 7367',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคณภัณฑ์'
  AND m.lastName = 'หมั่นสมบัติ'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 341: นางสาวธัญชนรี แก้วนภรสิการ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fj9h030fkea',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096 345 8861',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญชนรี'
  AND m.lastName = 'แก้วนภรสิการ'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 342: นางสาวปรียลักษณ์ โภคาร | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10ho886jj4nm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 096 329 3591',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปรียลักษณ์'
  AND m.lastName = 'โภคาร'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 343: นางสาวชนากานต์ อภิสริประภา | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w182p0s6zjw1s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้ช่วยครู',
  m.joinDate,
  'โทร 064 738 4502',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชนากานต์'
  AND m.lastName = 'อภิสริประภา'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 344: นางสาวรัตตกาล ยาธรงษ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1q8i1ayfv68',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  'โทร 081 029 9962',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัตตกาล'
  AND m.lastName = 'ยาธรงษ์'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 345: นายมล คำจันทร์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rbof4dyovs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 082 606 0137',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายมล'
  AND m.lastName = 'คำจันทร์'
  AND (s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 346: นายบัญญัติ ยานะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16p6p7t64c5e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 828892454',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายบัญญัติ'
  AND m.lastName = 'ยานะ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 347: นายวุฒิชัย กันสุธรรม | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1b2q9rfn6xju',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 858636619',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวุฒิชัย'
  AND m.lastName = 'กันสุธรรม'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 348: นางสาวธนารัตน์ ลือชัย | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1esmld2y1nvg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 9552744645',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธนารัตน์'
  AND m.lastName = 'ลือชัย'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 349: นางสาวพิมบุญ แสนมงคล | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w18uiczt8116s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 911396631',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมบุญ'
  AND m.lastName = 'แสนมงคล'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 350: นางสาวกัลยรัตน์ ชัยธรรม | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15h69pbpibbc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 875441721',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัลยรัตน์'
  AND m.lastName = 'ชัยธรรม'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 351: นางสาวชญานี คันทะเนตร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z46fgmu35v',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 956808218',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชญานี'
  AND m.lastName = 'คันทะเนตร'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 352: ว่าที่ ร.ต.ภูวดล กุญชร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jftm0md7r3o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 835673282',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่'
  AND m.lastName = 'ร.ต.ภูวดล กุญชร'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 353: นางสาวอัญชลี หาทองคำ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1lyaszorhlr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 931722192',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = 'หาทองคำ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 354: นางสาวปฐมาวดี แมตสอง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1frnw2r1othm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 958359428',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปฐมาวดี'
  AND m.lastName = 'แมตสอง'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 355: นายคชศักดิ์ ต่างเพ็ชร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1yrck5ve84de',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 639685911',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคชศักดิ์'
  AND m.lastName = 'ต่างเพ็ชร'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 356: นายณัฐภูมิ มาแว่น | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jhp4avlexa8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 987698276',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐภูมิ'
  AND m.lastName = 'มาแว่น'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 357: นางสาวปรีณาภา คำภิละ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1si8078ymxn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 931626490',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปรีณาภา'
  AND m.lastName = 'คำภิละ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 358: นางสาวสุชานันท์ ภักดีบุรี | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z8fhg27fd8k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 931683389',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชานันท์'
  AND m.lastName = 'ภักดีบุรี'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 359: นางสาวยุพิน คำแก้ว | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gn77itto6t7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 824156084',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวยุพิน'
  AND m.lastName = 'คำแก้ว'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 360: นายธีรทัช บุญทา | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bu562q3c4r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 912979799',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธีรทัช'
  AND m.lastName = 'บุญทา'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 361: นางสาวอริศรา พิธีเรือง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ir2zx2zx50b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 957284987',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอริศรา'
  AND m.lastName = 'พิธีเรือง'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 362: นางสาวสุพัตรา คำสุ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ghhiuew018',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 623098815',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุพัตรา'
  AND m.lastName = 'คำสุ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 363: นางสาววิลาวรรณ อินตา | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ki1si5z79kf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 813940907',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิลาวรรณ'
  AND m.lastName = 'อินตา'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 364: นายอนุชิต แข็งแรง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w18lpevjhwlxc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  'โทร 612674790',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุชิต'
  AND m.lastName = 'แข็งแรง'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 365: นางสาวฐิตาภรณ์ สายอิ่นแก้ว | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1229a9s5kxwr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 063-7272518',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฐิตาภรณ์'
  AND m.lastName = 'สายอิ่นแก้ว'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 366: นายกรกฎ โรจนนิจ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cj3wvqogsoh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-8064029',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกรกฎ'
  AND m.lastName = 'โรจนนิจ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 367: นางสาวศิรินกรณ์  สุยะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ppbny5c15ih',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-2850050',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิรินกรณ์'
  AND m.lastName = 'สุยะ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 368: นางสาวสุจินดา ใจกล้า | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16mydu6buoqq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-5774566',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุจินดา'
  AND m.lastName = 'ใจกล้า'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 369: นายพุฒิชัย  ไฝเครือ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1o5ssg7gvr4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 086-4308642',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพุฒิชัย'
  AND m.lastName = 'ไฝเครือ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 370: นายภาณุพงค์  ยาจันทร์ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1m1flehzwhus',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-2427771',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงค์'
  AND m.lastName = 'ยาจันทร์'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 371: นายฉัตรดนัย  ใยญาติ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cuxodbx6x4h',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 085-8789838',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฉัตรดนัย'
  AND m.lastName = 'ใยญาติ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 372: นายเลอพงษ์  ปัญญาดี | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qfvfvknbnoh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 087-1878403',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเลอพงษ์'
  AND m.lastName = 'ปัญญาดี'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 373: นางสาวจารุวรรณ กันทะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wjau4gtk42s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  'โทร 080-6029200',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'กันทะ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 374: นายจายแสง  มอญคำ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1951z7kw337',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 081-1611905',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจายแสง'
  AND m.lastName = 'มอญคำ'
  AND (s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%' OR s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 375: นายเกรียงศักดิ์  ฝึกฝน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w178mjoirsnjh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 943645494',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเกรียงศักดิ์'
  AND m.lastName = 'ฝึกฝน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 376: นางสุรีย์พร  แข็งขันธ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wjsmrgpjr5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 085-0331023',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสุรีย์พร'
  AND m.lastName = 'แข็งขันธ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 377: นางนวนันท์  สิทธิวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w13v7pusztgyq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 090-3186928',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางนวนันท์'
  AND m.lastName = 'สิทธิวงศ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 378: นางสาวพิมพ์พิกา จันทร์เทพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w192yvabgr95h',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 093-3026863',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์พิกา'
  AND m.lastName = 'จันทร์เทพ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 379: นางสาวน้ำเพชร  ชัยชมภู | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cvfu0uerx8k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 095-6906952',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวน้ำเพชร'
  AND m.lastName = 'ชัยชมภู'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 380: นางสาวพัชรา  สินธรมงคล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1v1mtflgjfc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 085-5737026',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรา'
  AND m.lastName = 'สินธรมงคล'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 381: ว่าที่ร้อยตรีโสธร   ศรีอาวุธ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14cjijihdxas',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 096-2765061',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีโสธร'
  AND m.lastName = 'ศรีอาวุธ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 382: นางศรีจันทร์  กันทะนะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1t0enukx9e4f',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 086-1900711',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางศรีจันทร์'
  AND m.lastName = 'กันทะนะ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 383: นางสาวอัญชลี  เมฆวิบูลย์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wy01nog9yj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 099-1545942',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = 'เมฆวิบูลย์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 384: นางสาวฟ้าใส วิสารกาญจน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1p6284typ9td',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 087-9362077',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฟ้าใส'
  AND m.lastName = 'วิสารกาญจน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 385: นายพีรกร  สมคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xcqui7tak2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 081-2872691',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพีรกร'
  AND m.lastName = 'สมคำ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 386: นางธรรยธรฐ์  ดวงสนิท | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1s25o3f0a4kd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 062-0436223',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางธรรยธรฐ์'
  AND m.lastName = 'ดวงสนิท'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 387: นางสาวฉัตรนิฏฐา   สุนันตา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bqba7aojwte',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 088-2686202',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฉัตรนิฏฐา'
  AND m.lastName = 'สุนันตา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 388: ว่าที่ร้อยตรีอนุรักษ์  มั่นอ่วม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w157sw1zojit9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 081-0450609',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีอนุรักษ์'
  AND m.lastName = 'มั่นอ่วม'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 389: นางสาวศิริพร   เยอะหนื่อ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rq96485a4n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 095-8324631',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริพร'
  AND m.lastName = 'เยอะหนื่อ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 390: นายทนงศักดิ์   หวานหอม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ti7cw5q4jd8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 087-5699698',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายทนงศักดิ์'
  AND m.lastName = 'หวานหอม'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 391: นางสาวนิลรัตน์  ไชยรังสฤษดิ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1m3tg6e0e5r9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 092-6857660',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิลรัตน์'
  AND m.lastName = 'ไชยรังสฤษดิ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 392: นายไพชยนต์   สิทธิยศ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1m6cbbmcr1l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 091-8505533',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไพชยนต์'
  AND m.lastName = 'สิทธิยศ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 393: นางสาวศรัญญา  เชื้อเมืองพาน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ho9rycen4de',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 098-2720503',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศรัญญา'
  AND m.lastName = 'เชื้อเมืองพาน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 394: นายพิรเศรษฐ์   จินะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ije2tlv7my',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 095-9708458',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพิรเศรษฐ์'
  AND m.lastName = 'จินะ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 395: นายธนทรัพย์   รัตนไภ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1pdhjxfh696b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 085-6897599',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนทรัพย์'
  AND m.lastName = 'รัตนไภ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 396: นายศักดา  วันเพ็ญ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w13ztvvhs7i7q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 063-1231439',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศักดา'
  AND m.lastName = 'วันเพ็ญ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 397: นางสาวภาสินี   ธิศรี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1yx0xhr3g08d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 084-0407484',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภาสินี'
  AND m.lastName = 'ธิศรี'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 398: นางสาววรัชญ์ขวัญ  ปัญวิยะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1nrf4nh5mckp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 065-5354154',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรัชญ์ขวัญ'
  AND m.lastName = 'ปัญวิยะ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 399: นางสาวปวริศา   สุระจิตต์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ozxa7yyed7e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 095-3516691',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปวริศา'
  AND m.lastName = 'สุระจิตต์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 400: นางรตีกานต์   เดินแปง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wpwskooxz7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 084-1377508',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางรตีกานต์'
  AND m.lastName = 'เดินแปง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 401: นางสาววารุณี  หลวงไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zkh0fkdw009',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 087-3115318',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววารุณี'
  AND m.lastName = 'หลวงไชย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 402: นางสาวนพเก้า  นิพัฒน์ศิริผล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1isac28b2xh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 097-9536835',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนพเก้า'
  AND m.lastName = 'นิพัฒน์ศิริผล'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 403: นางสาวปุญญิสา ปงลังกา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17z8i421jwec',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 080-5519466',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปุญญิสา'
  AND m.lastName = 'ปงลังกา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 404: นางสาวหนึ่งฤทัย  สุทธสม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bz5mm4o3kp4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 088-9658379',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหนึ่งฤทัย'
  AND m.lastName = 'สุทธสม'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 405: นายคามิน  คีรีอยู่ลือ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wkzq3r0bqi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 098-4097071',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคามิน'
  AND m.lastName = 'คีรีอยู่ลือ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 406: นายชัญญานุช  โพธิ์เงิน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19tpxmwozv0b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 082-4044326',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชัญญานุช'
  AND m.lastName = 'โพธิ์เงิน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 407: นางสาวรัชนี สุทธิประภา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1t9cz0kz985m',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 087-8500503',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัชนี'
  AND m.lastName = 'สุทธิประภา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 408: นายเชนร์   อุดอ้าย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19hiqz81kc38',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 081-1119039',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเชนร์'
  AND m.lastName = 'อุดอ้าย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 409: นายศิวกร  มูลละ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1s61txrvxcfl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 091-8089098',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศิวกร'
  AND m.lastName = 'มูลละ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 410: นางสาวชนันท์ธิดา  สิริวสุพงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1l2zfniac6ic',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 085-7210100',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชนันท์ธิดา'
  AND m.lastName = 'สิริวสุพงศ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 411: นางสาวเนตรนภัทร  แก้วแดง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w13zio1bjgn4j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 097-1211162',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเนตรนภัทร'
  AND m.lastName = 'แก้วแดง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 412: นายภูบดินทร์  อินรส | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12kjnecq0ghl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 084-3638896',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภูบดินทร์'
  AND m.lastName = 'อินรส'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 413: นางสาวกัญญารัตน์  ยะกับ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xgqbrnbrgg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 088-4137508',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญญารัตน์'
  AND m.lastName = 'ยะกับ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 414: นางสาวกัญญารัตน์  วงศ์หลวง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19n4fjnj7hwf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096 - 5298809',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญญารัตน์'
  AND m.lastName = 'วงศ์หลวง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 415: นายจิรายุทธ  ศรีคำเทียม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17j1wq83zt6b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-2496238',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิรายุทธ'
  AND m.lastName = 'ศรีคำเทียม'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 416: นางสาวรุ้งทราย  ลูนปัน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10jbmxnsnw4hb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-1601810',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรุ้งทราย'
  AND m.lastName = 'ลูนปัน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 417: นางสาวกัญจนพร  อภัยกาวี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1suesgycb6f9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 084-6113901',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญจนพร'
  AND m.lastName = 'อภัยกาวี'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 418: นางสาวพิมพ์พิจิตร ศรีสงค์ใจ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1d3ki5wt8g38',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-3855528',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์พิจิตร'
  AND m.lastName = 'ศรีสงค์ใจ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 419: นางสาวรติมา  ภาวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16rtyh2bnc5k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-6586388',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรติมา'
  AND m.lastName = 'ภาวงศ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 420: นายศุภกฤต  อภิไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1e0gkzuoy2qs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-4839323',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศุภกฤต'
  AND m.lastName = 'อภิไชย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 421: นางสาวรุ่งทิวา  กาศมณี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11fjfluzlnotj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-3593592',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรุ่งทิวา'
  AND m.lastName = 'กาศมณี'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 422: นางสาวศิรินันท์ อรัญวาส | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vm04rcbu3y',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-2752375',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิรินันท์'
  AND m.lastName = 'อรัญวาส'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 423: นางสาวชลิดา  ปินคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z01rnw3cj4c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-3593315',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชลิดา'
  AND m.lastName = 'ปินคำ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 424: นางสาวพุทธกาล บัณฑิตเทอดสกุล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w18yv86bnlmu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-1530774',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพุทธกาล'
  AND m.lastName = 'บัณฑิตเทอดสกุล'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 425: นายยชญ์วิวรรธน์  ชมภูชนะภัย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vft4tew0lbj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-3790096',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยชญ์วิวรรธน์'
  AND m.lastName = 'ชมภูชนะภัย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 426: นายณัฐวัฒน์  ภูริธิติมา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1avdstxhq61q',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9539821',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐวัฒน์'
  AND m.lastName = 'ภูริธิติมา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 427: นายณัฐพล  วัฒนาชัยมงคล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1yaqbbf643mp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 089-8531344',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐพล'
  AND m.lastName = 'วัฒนาชัยมงคล'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 428: นายสัภยา  ตาลำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10mfn509b971',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9238579',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสัภยา'
  AND m.lastName = 'ตาลำ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 429: นางสาวศรัณย์ธร สังข์เมือง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fzgd29ni397',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-2342389',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศรัณย์ธร'
  AND m.lastName = 'สังข์เมือง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 430: นางสาวจิราพร  ระคาไพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tsof3e0x6sd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-3083925',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิราพร'
  AND m.lastName = 'ระคาไพ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 431: นางสาวกฤษณา ธรรมศร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17mumo82fpj5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-6250412',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกฤษณา'
  AND m.lastName = 'ธรรมศร'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 432: นางสาวรัญชิดา  พรมมินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1u9w9ddx5y7b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-5854171',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัญชิดา'
  AND m.lastName = 'พรมมินทร์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 433: นางสาววาริกา  แดนช่างคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cf0lrffqwzg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-9100030',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววาริกา'
  AND m.lastName = 'แดนช่างคำ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 434: นางสาวจุฑามาศ  ไชยพูน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1o11pw776yd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 065-4341799',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจุฑามาศ'
  AND m.lastName = 'ไชยพูน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 435: นางสาวยลลดา  สารบัว | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vhunm9kr3ti',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-3097516',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวยลลดา'
  AND m.lastName = 'สารบัว'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 436: นางสาวรัฐพร  หมั่นแสวง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10k5mk0fgcr7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 084-0435968',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัฐพร'
  AND m.lastName = 'หมั่นแสวง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 437: นางสาวศุภลักษณ์  โพธิ์ทองพร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19e6jnjnjcdm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 099-1415093',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศุภลักษณ์'
  AND m.lastName = 'โพธิ์ทองพร'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 438: นางสาวณัฐธิชา ศรีเพชร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14iq9cbbi6xi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-0347251',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐธิชา'
  AND m.lastName = 'ศรีเพชร'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 439: นางสาวนภัสสร  คำลือ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fm912h8gwf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-4521619',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนภัสสร'
  AND m.lastName = 'คำลือ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 440: นางสาวชลลดา  แข่งขัน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12fh4qmpjsq9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-1867266',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชลลดา'
  AND m.lastName = 'แข่งขัน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 441: นางสาวจันทิมา  รอบรู้ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fkadlot24a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 084-3678991',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจันทิมา'
  AND m.lastName = 'รอบรู้'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 442: นายธัชกร  ปัญญาอินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15nbbuxu6bzb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 091-4824232',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธัชกร'
  AND m.lastName = 'ปัญญาอินทร์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 443: นางสาวสกาวเดือน  งามพิง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1dujuz4ykj8r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-6720717',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสกาวเดือน'
  AND m.lastName = 'งามพิง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 444: นางสาวเสาวนีย์  นามอ้าย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11ftm78jas5l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 088-5991930',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเสาวนีย์'
  AND m.lastName = 'นามอ้าย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 445: นางสาวสุพัตรา  ฉางข้าวไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1f9ss9euq4e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-9765687',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุพัตรา'
  AND m.lastName = 'ฉางข้าวไชย'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 446: นางสาวหนึ่งฤทัย  พนาแสนใจ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w140heagrnxnq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9242108',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหนึ่งฤทัย'
  AND m.lastName = 'พนาแสนใจ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 447: นางสาววราพร  สุยะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ucxq3vy44n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 063-7848586',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววราพร'
  AND m.lastName = 'สุยะ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 448: นายจักรพงษ์  ติ๊บเหล็ก | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1kppd33xk019',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 088-5789492',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจักรพงษ์'
  AND m.lastName = 'ติ๊บเหล็ก'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 449: นายรัฐพล  คำพงษ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xblr86itxk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-3599828',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายรัฐพล'
  AND m.lastName = 'คำพงษ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 450: นางสาวจุฑานาถ  ทองล้วน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w157pq9bcmaen',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-1611796',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจุฑานาถ'
  AND m.lastName = 'ทองล้วน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 451: นางสาวณิชกานต์  ดีคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1loy1lg67g2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-2876432',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณิชกานต์'
  AND m.lastName = 'ดีคำ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 452: นายเอกรัตน์  อายุยืน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ij3ykwxptlq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-2949470',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกรัตน์'
  AND m.lastName = 'อายุยืน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 453: นางสาววรรณวิสา  กันทา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w131s0obj70a3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 082-5301310',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรณวิสา'
  AND m.lastName = 'กันทา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 454: นายจักรรินทร์    โฆษิตมุธากร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wmovkt1t8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-1349014',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจักรรินทร์'
  AND m.lastName = 'โฆษิตมุธากร'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 455: นางสางธัญธิญาพร  ก๋องแก้ว | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11kw0jrzzcxzh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-3215181',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสางธัญธิญาพร'
  AND m.lastName = 'ก๋องแก้ว'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 456: นางสาวสุชัญญา  ทาทอง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wwghd3txsb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 064-5169867',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชัญญา'
  AND m.lastName = 'ทาทอง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 457: นายนัทธพงศ์  ยศวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w153ukw5hxlb9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 098-4197698',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนัทธพงศ์'
  AND m.lastName = 'ยศวงศ์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 458: นางสาวประพิมพ์พร  แก้วมาเมือง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1x2ms7mqr1u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 082-1854015',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวประพิมพ์พร'
  AND m.lastName = 'แก้วมาเมือง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 459: นางสาวกนกวรรณ  ธีรโฆษิต | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1p48fud70imt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-6754401',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกวรรณ'
  AND m.lastName = 'ธีรโฆษิต'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 460: นายนิธิรัตน์   สุดสม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11ts2ma0jzm3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 064-0689008',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนิธิรัตน์'
  AND m.lastName = 'สุดสม'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 461: นางสาวเสาวลักษณ์  บานเย็น | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tfinex6jj9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 098-7741335',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเสาวลักษณ์'
  AND m.lastName = 'บานเย็น'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 462: นางสาวมาลิสา  คำเงิน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zukb2y1ewgj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 082-3852997',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมาลิสา'
  AND m.lastName = 'คำเงิน'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 463: นายวิสาร  โลบันลือภพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1dy9d879k8sh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-3452163',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวิสาร'
  AND m.lastName = 'โลบันลือภพ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 464: นางสาวจารุวรรณ  แซ่ฟุ้ง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1n51wji8u4d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-0763293',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'แซ่ฟุ้ง'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 465: นางสาวศศิธร  เชียวตา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qrwyh7al9vt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 098-3936698',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศศิธร'
  AND m.lastName = 'เชียวตา'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 466: นายศราวุฒิ   ฝั้นก๋า | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1q6a7vzrc89o',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 082-7818713',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศราวุฒิ'
  AND m.lastName = 'ฝั้นก๋า'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 467: นายจิรวัฒน์  วงศ์ประเสริฐ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1j3qxej2muih',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093 - 5456470',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิรวัฒน์'
  AND m.lastName = 'วงศ์ประเสริฐ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 468: นางสาวมณีวรรณ  คันธวังอินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1khy2etgyryp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 098-7626563',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมณีวรรณ'
  AND m.lastName = 'คันธวังอินทร์'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 469: นางกษมา  ทองสุวรรณ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zauo84iym3i',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการโรงเรียน',
  m.joinDate,
  'โทร 061-8939459',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกษมา'
  AND m.lastName = 'ทองสุวรรณ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 470: นางสาวศรีวรรณ   ปอแฉ่ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1hryjgo3xvef',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พี่เลี้ยงเด็กพิการ',
  m.joinDate,
  'โทร 080-5020642',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศรีวรรณ'
  AND m.lastName = 'ปอแฉ่'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 471: นายยี่  คำอู๋ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1k41fra6ed2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ภารโรง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยี่'
  AND m.lastName = 'คำอู๋'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 472: นายแสง บุญธีราโชติ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12jx6xxl8any',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ภารโรง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายแสง'
  AND m.lastName = 'บุญธีราโชติ'
  AND (s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 473: นายชัชวาลย์ ใจอินทร์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z4uyre3ena',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 084-1768959',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชัชวาลย์'
  AND m.lastName = 'ใจอินทร์'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 474: นายสุริยา วงษ์ตา | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1w4dcifrxxfr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 093-2912629',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุริยา'
  AND m.lastName = 'วงษ์ตา'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 475: นางสาวเบญจพร พันธะเกษม | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1l56k5fnbba',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-6561310',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเบญจพร'
  AND m.lastName = 'พันธะเกษม'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 476: นายกิตติพงษ์ ไชยลังการ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11h05kl4on5u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-1370151',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกิตติพงษ์'
  AND m.lastName = 'ไชยลังการ'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 477: นางสาวอัจรียา นนท์ศรี | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w139e9ws0dava',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 063-9808306',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัจรียา'
  AND m.lastName = 'นนท์ศรี'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 478: นางสาวจุฑารัตน์ คันทะเสน | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1owcf5b8itpf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 086-3686080',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจุฑารัตน์'
  AND m.lastName = 'คันทะเสน'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 479: นางสาวเนตรนภา เชื้อหมอ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1a9cho69zjdf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-2391601',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเนตรนภา'
  AND m.lastName = 'เชื้อหมอ'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 480: นางสาวเมธาวี ขัติพรหม | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cg3z53y7d3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2798273',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเมธาวี'
  AND m.lastName = 'ขัติพรหม'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 481: นางสาวธิติยา ลก | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1mkjfg7ymmj7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-8649139',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธิติยา'
  AND m.lastName = 'ลก'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 482: นางสาวชินาทร บัวแดง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1kb22uw2csqg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 090-3198085',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชินาทร'
  AND m.lastName = 'บัวแดง'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 483: นายเนติพงศ์ เสาร์จันทร์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ibw5wr0nlt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 064-9832103',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเนติพงศ์'
  AND m.lastName = 'เสาร์จันทร์'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 484: นายอนุชิต ตันวงค์ษา | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1w5qwwl2b76k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-6600953',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุชิต'
  AND m.lastName = 'ตันวงค์ษา'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 485: นางสาววรรณวลี ดิถีเพ็ง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12btl7tqp6ay',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 064-0976548',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรณวลี'
  AND m.lastName = 'ดิถีเพ็ง'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 486: นายชุติพนธ์ สมบูรณ์วงษ์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11333x9deb67k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-3975171',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชุติพนธ์'
  AND m.lastName = 'สมบูรณ์วงษ์'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 487: นายภาณุพงศ์ กาสอน | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1i2wl5xzknr9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-5677288',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงศ์'
  AND m.lastName = 'กาสอน'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 488: นางสาวภัสปชธร แสนเป็ง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1n3gqeih98pj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 095-9470659',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัสปชธร'
  AND m.lastName = 'แสนเป็ง'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 489: นางสาวพัชรินธรณ์ รวมสุข | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zozegsqdrtn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 080-0590433',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรินธรณ์'
  AND m.lastName = 'รวมสุข'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 490: นางสาวเปมิกา เมอแล | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w144fgf0j7q7m',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูทวิภาษา',
  m.joinDate,
  'โทร 097-9937905',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเปมิกา'
  AND m.lastName = 'เมอแล'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 491: นางสาวอำพร แลเชอะ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bgks0j7e95w',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  'โทร 093-1137875',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอำพร'
  AND m.lastName = 'แลเชอะ'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 492: นายจะแฮ มูยี | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ss3p01cgxf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 097-9929437',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจะแฮ'
  AND m.lastName = 'มูยี'
  AND (s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%' OR s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 493: นายสุขสันต์  สอนนวล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1hudhcri6ult',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียน',
  m.joinDate,
  'โทร 081-2771948',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุขสันต์'
  AND m.lastName = 'สอนนวล'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 494: นางสาวปรียนันท์ ทิพากร | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19kdye652w4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 089-8501524',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปรียนันท์'
  AND m.lastName = 'ทิพากร'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 495: นายขวัญชัย  โกแสนตอ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1dcgrzlrqgt8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 080-1201701',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายขวัญชัย'
  AND m.lastName = 'โกแสนตอ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 496: นายชานนท์  จันต๊ะคาด | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ync922m7cz',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 087-1939121',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชานนท์'
  AND m.lastName = 'จันต๊ะคาด'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 497: นางรพีพรรณ  มาลารัตน์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16dxv0jtibe2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.3',
  m.joinDate,
  'โทร 882350984',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางรพีพรรณ'
  AND m.lastName = 'มาลารัตน์'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 498: นางสาวภัณฑิรา  เมืองปัญโญ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1w09n5abezj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 062-3606360',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัณฑิรา'
  AND m.lastName = 'เมืองปัญโญ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 499: นายชาญณรงค์  โลดแจ้ง | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fs50m4dqueo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 095-9646886',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชาญณรงค์'
  AND m.lastName = 'โลดแจ้ง'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 500: ว่าที่ ร.ต.หญิงวิจิตรา  เย็นจิตต์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15jmcbyrvafs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 095-8706560',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่'
  AND m.lastName = 'ร.ต.หญิงวิจิตรา เย็นจิตต์'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 501: นางสาวมาลินี ดอนมูล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1exthskn4qfo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 064-5052248',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมาลินี'
  AND m.lastName = 'ดอนมูล'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 502: นายสุรศักดิ์  เนตรทิพย์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1y48mparsa0j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 081-0297031',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรศักดิ์'
  AND m.lastName = 'เนตรทิพย์'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 503: นางสาวศุภกานต์ ชื่นจิต | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1l0erh61jwbp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 080-1265649',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศุภกานต์'
  AND m.lastName = 'ชื่นจิต'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 504: นางสาวอรปรียา  กาแก้ว | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1m61p4gek0pr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 088-4092760',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรปรียา'
  AND m.lastName = 'กาแก้ว'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 505: นางสาวนิลาวรรณ สายพรหม | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1au3t2ztupmo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 098-1962334',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิลาวรรณ'
  AND m.lastName = 'สายพรหม'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 506: นายจารุกิตติ์ ยิ่งสมบูรณ์ชัย | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1fonpq68zouv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 063-1862235',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจารุกิตติ์'
  AND m.lastName = 'ยิ่งสมบูรณ์ชัย'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 507: นายเอกพงศ์  ใจต๊ะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rg0kl4zvg5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 093-0517458',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกพงศ์'
  AND m.lastName = 'ใจต๊ะ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 508: นายชัชพล  ลำดวน | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tl6hpbkqcqd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 062-3579987',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชัชพล'
  AND m.lastName = 'ลำดวน'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 509: นางสาวกัญญาวีร์  เวียงมูล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15dndazwkf8s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 082-7815307',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญญาวีร์'
  AND m.lastName = 'เวียงมูล'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 510: นายปฏิภาณ สมฟองทอง | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1lfr5kvg2ii',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 098-5164323',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายปฏิภาณ'
  AND m.lastName = 'สมฟองทอง'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 511: นายณัฐพล  เหม็งทะเหล็ก | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cd7ukjbc47s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 088-6587110',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐพล'
  AND m.lastName = 'เหม็งทะเหล็ก'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 512: นางสาวฐิตาภรณ์ สายอิ่นแก้ว | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1mlyfo4qfshf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 063-7272518',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฐิตาภรณ์'
  AND m.lastName = 'สายอิ่นแก้ว'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 513: นายกรกฎ โรจนนิจ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1knlk7w5jk1',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-8064029',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกรกฎ'
  AND m.lastName = 'โรจนนิจ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 514: นางสาวศิรินกรณ์  สุยะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rqxk5skw50e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 061-2850050',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิรินกรณ์'
  AND m.lastName = 'สุยะ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 515: นางสาวสุจินดา ใจกล้า | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ohj6yga8e3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 087-5774566',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุจินดา'
  AND m.lastName = 'ใจกล้า'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 516: นายพุฒิชัย  ไฝเครือ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1x29djd0mlvf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 086-4308642',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพุฒิชัย'
  AND m.lastName = 'ไฝเครือ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 517: นายภาณุพงค์  ยาจันทร์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ufdhnvnvh5b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 095-2427771',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงค์'
  AND m.lastName = 'ยาจันทร์'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 518: นายฉัตรดนัย  ใยญาติ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1e4ror0iaspj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.2',
  m.joinDate,
  'โทร 085-8789838',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฉัตรดนัย'
  AND m.lastName = 'ใยญาติ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 519: นายเลอพงษ์  ปัญญาดี | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rkzmdhlnpn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 087-1878403',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเลอพงษ์'
  AND m.lastName = 'ปัญญาดี'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 520: นางสาวจารุวรรณ กันทะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1p7s0jfw0h2j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  'โทร 080-6029200',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'กันทะ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 521: นายจายแสง  มอญคำ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cpr1ccg33lf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 081-1611905',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจายแสง'
  AND m.lastName = 'มอญคำ'
  AND (s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%' OR s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 522: นายบรรหาญ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wd227iyk5i8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ปันทะนัน',
  m.joinDate,
  'โทร ผู้อำนวยการโรงเรียน',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายบรรหาญ'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 523: นางสาวพิมพ์พิชมญชุ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1awrn3x28ky7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'สุภายอง',
  m.joinDate,
  'โทร ครูชำนาญการ',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์พิชมญชุ์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 524: นางสาวอัญชลี | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1motqdwhd13r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เกเย็น',
  m.joinDate,
  'โทร ครูชำนาญการ',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัญชลี'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 525: นางสาวชไมพร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17xflsixbta4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ลินคำ',
  m.joinDate,
  'โทร ครูชำนาญการ',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชไมพร'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 526: นางสาวสุพิชชา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1l0v1jc0j18',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'สร้อยข่าย',
  m.joinDate,
  'โทร ครูชำนาญการ',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุพิชชา'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 527: นายสมรัตชัย | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w174p9jwg1pmb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ปุริมาโน',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมรัตชัย'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 528: นางสาวจันทรา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1koqf8mhr8ap',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'หวุ่ยซือกู่',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจันทรา'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 529: นางสาวพรอภิมล | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1mjcgkhmng2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'จันทรา',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพรอภิมล'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 530: นางสาวสโรชา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tqemf22h45p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ป๊อกยะดา',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสโรชา'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 531: นางสาวสุรีย์รัตน์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17to8l04olal',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ดอนชัย',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุรีย์รัตน์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 532: นายจักรกฤษณ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1pamxddyj3k8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ใจคำ',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจักรกฤษณ์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 533: นายวรรณ์ธนัย | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1k8kn6ojjyb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นันทวรรณ์',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวรรณ์ธนัย'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 534: นางสาวสิริยากร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qj4rn7jbnj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คำเงิน',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิริยากร'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 535: นางสาวลัดดาวัลย์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16lgp4pitb3a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ศรีวิชัย',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวลัดดาวัลย์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 536: นายนิคม | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rwbz4kz2mx9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เหลือจาด',
  m.joinDate,
  'โทร ครู',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนิคม'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 537: นางสาวณัจฉรียา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1iu0ryvn5wz',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ปงลังกา',
  m.joinDate,
  'โทร ครูผู้ช่วย',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัจฉรียา'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 538: นายวีระพงษ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gt7z3yq7clr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'กันภัย',
  m.joinDate,
  'โทร ครูผู้ช่วย',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวีระพงษ์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 539: นายกิตติพงษ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1lcixnlqlo3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'สมโภชน์',
  m.joinDate,
  'โทร ครูผู้ช่วย',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายกิตติพงษ์'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 540: นางสาวชโลทร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zrrxlofdtl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'สูนศรี',
  m.joinDate,
  'โทร ครูผู้ช่วย',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชโลทร'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 541: นางนายยาแบ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gzj53ui08mn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'อายี',
  m.joinDate,
  'โทร นักการภารโรง',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางนายยาแบ'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%' OR s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 542: นายสมคิด อนุเคราะห์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tnxiho5u1pf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 090-3320944',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมคิด'
  AND m.lastName = 'อนุเคราะห์'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 543: นายศรายุทธ อุ่นใจ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1mtiu1tbnvzf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 095-2412225',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศรายุทธ'
  AND m.lastName = 'อุ่นใจ'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 544: นายจิตอิสรภาพ ใจอารีย์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16sqrss5ibaq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 097-9472832',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิตอิสรภาพ'
  AND m.lastName = 'ใจอารีย์'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 545: นายชญตว์ ปานนับร้อย | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w156crqqpzfd9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 089-7011404',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชญตว์'
  AND m.lastName = 'ปานนับร้อย'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 546: นางสาวเกศรา อินตาพรม | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1i6o8rzgncf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 091-0784225',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกศรา'
  AND m.lastName = 'อินตาพรม'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 547: นางสาวมุกดา วารีขจร | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1nqklfeyd0bo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-9764261',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมุกดา'
  AND m.lastName = 'วารีขจร'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 548: นางสาววิรรณ อย่างวรโชติ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1hknsg0r1umt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 090-4731329',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิรรณ'
  AND m.lastName = 'อย่างวรโชติ'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 549: นางสาวมาติกา จิระณชานนท์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cdy1ylwudml',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-2596616',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมาติกา'
  AND m.lastName = 'จิระณชานนท์'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 550: นางสาวริศรา กรสวรรค์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1i74eqnmq9sp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-3723135',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวริศรา'
  AND m.lastName = 'กรสวรรค์'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 551: นางสาวหมี่ซาง มาเยอะ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1g8v1udhusec',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 089-8527465',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหมี่ซาง'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%' OR s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 552: นายศิวนาถ  ประสาวะถา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16nsphpjpiqw',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผอ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศิวนาถ'
  AND m.lastName = 'ประสาวะถา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 553: นายธนันชัย  พิพิธพงศ์สันต์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1c68le6nzw6k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รอง ผอ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนันชัย'
  AND m.lastName = 'พิพิธพงศ์สันต์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 554: นางสาวปภัสสร จงตรอง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cuotyc7z5k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รอง ผอ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปภัสสร'
  AND m.lastName = 'จงตรอง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 555: นางสาวศิริลักษณ์ สุดแสวง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16m1uzsi3ne8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.3',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริลักษณ์'
  AND m.lastName = 'สุดแสวง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 556: นางสาวศันสนีย์ เทพคำ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1lgj37q2332j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศันสนีย์'
  AND m.lastName = 'เทพคำ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 557: นางพิชาภัส วงค์จรณบูรณ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16z61ue3zhpd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางพิชาภัส'
  AND m.lastName = 'วงค์จรณบูรณ์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 558: นางสาวสุธัมวดี ใจยะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11yj789d9qbn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุธัมวดี'
  AND m.lastName = 'ใจยะ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 559: นางสาวกนกพร ชุมภู | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1auwzwhh27yh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกพร'
  AND m.lastName = 'ชุมภู'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 560: ว่าที่ร้อยตรีหญิงอชิรญาณ์ สีชา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1pjiigzjglwc',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีหญิงอชิรญาณ์'
  AND m.lastName = 'สีชา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 561: นายนิวัฒ บัวติ๊บ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ndfkmbalkt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนิวัฒ'
  AND m.lastName = 'บัวติ๊บ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 562: นางสาวกิ่งกาญจน์ สายสูงเนิน | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ls4uarjabd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.๒',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกิ่งกาญจน์'
  AND m.lastName = 'สายสูงเนิน'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 563: นายเอกภพ คำรส | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1bn8khxmwtqv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.2',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกภพ'
  AND m.lastName = 'คำรส'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 564: นายศุภการ แก้วรากมุข | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cugii5hps9j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศุภการ'
  AND m.lastName = 'แก้วรากมุข'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 565: นางสาวณัฐวลัญช์ เรือนสอน | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1irlu9hjrt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐวลัญช์'
  AND m.lastName = 'เรือนสอน'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 566: นางสาวณัฏฐนันท์ บำเพ็ญกุล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12acgxgemz8n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฏฐนันท์'
  AND m.lastName = 'บำเพ็ญกุล'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 567: นางสาวนภาพร สุขธงไชยกูล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1os8x93wo7f9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนภาพร'
  AND m.lastName = 'สุขธงไชยกูล'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 568: นางสาวปาริชาติ เพ็ชรพลอย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ets2zy5vl5u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปาริชาติ'
  AND m.lastName = 'เพ็ชรพลอย'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 569: นางสาวชบาไพร ปัญโญ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xj1y882ole',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชบาไพร'
  AND m.lastName = 'ปัญโญ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 570: นางสาวสุฎาพร ธนสารพิพัฒน์คุณ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17mi5sf13he',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุฎาพร'
  AND m.lastName = 'ธนสารพิพัฒน์คุณ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 571: นางสาวภิญญดา ไชยวัง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1t6xyt94kq2a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภิญญดา'
  AND m.lastName = 'ไชยวัง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 572: นางสาวชรินทร์รัตน์ บุญเลา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1slr5uzzo5p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชรินทร์รัตน์'
  AND m.lastName = 'บุญเลา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 573: นายฌัชวิทย์ รัตนเดชา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w139l6hx04u1p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายฌัชวิทย์'
  AND m.lastName = 'รัตนเดชา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 574: นางสาวเมธาพร ญาวิระ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1x5t8vf7t7e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเมธาพร'
  AND m.lastName = 'ญาวิระ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 575: นายธนากร แสนคำมา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1f5vznq5byhg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนากร'
  AND m.lastName = 'แสนคำมา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 576: นายทรงภพ ขุนยวมอนุรักษ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1kgrukr9n2kn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายทรงภพ'
  AND m.lastName = 'ขุนยวมอนุรักษ์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 577: นางสาวกันติยา น่วมฟั่น | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1n0yn6rnwv2',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกันติยา'
  AND m.lastName = 'น่วมฟั่น'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 578: นางสาวนันทวัน จันทรังษี | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1cd90bbi0at',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนันทวัน'
  AND m.lastName = 'จันทรังษี'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 579: นายพงษ์สิทธิ์ นันต๊ะภูมิ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1q2sb3zvbjv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพงษ์สิทธิ์'
  AND m.lastName = 'นันต๊ะภูมิ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 580: นางสาวจุฑาลักษณ์ ศักดิ์เรืองฤทธิ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w154xp30xxej8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจุฑาลักษณ์'
  AND m.lastName = 'ศักดิ์เรืองฤทธิ์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 581: นางสาวธัญญาลักษณ์ จินะเขียว | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1y99bkqbq7sf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คศ.1',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญญาลักษณ์'
  AND m.lastName = 'จินะเขียว'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 582: นางสาวสุภาวรรณ อ่อนนวล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w15zj6nco7d7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุภาวรรณ'
  AND m.lastName = 'อ่อนนวล'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 583: นางสาวเกศรินทร์ แสนคำหล่อ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jwzsptgzy9m',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกศรินทร์'
  AND m.lastName = 'แสนคำหล่อ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 584: นางสาวธัญญา แหวนเพชร | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ndr3exo5sfp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธัญญา'
  AND m.lastName = 'แหวนเพชร'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 585: นางสาวศิริลักษณ์ วงศ์ไชย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1u6i4rrmi0vl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริลักษณ์'
  AND m.lastName = 'วงศ์ไชย'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 586: นางสาวนวลจันทร์ ชัยชนะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rdg26zh9bto',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนวลจันทร์'
  AND m.lastName = 'ชัยชนะ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 587: ว่าที่ร้อยตรีสุทธินันต์ สรรเสริญบุญ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17cfzyyc2r8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีสุทธินันต์'
  AND m.lastName = 'สรรเสริญบุญ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 588: นางสาวสิริวิมล ปิ่นญาติ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w188zjoa30rep',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิริวิมล'
  AND m.lastName = 'ปิ่นญาติ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 589: นางสาวภูษณิศา ยะโหนด | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1044fu6hucaet',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภูษณิศา'
  AND m.lastName = 'ยะโหนด'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 590: นางสาวอิชยา บุญอินเขียว | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1sky91anfjf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอิชยา'
  AND m.lastName = 'บุญอินเขียว'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 591: นางสาวสุทามาศ สุริยะวงศ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ss3yim37i2p',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุทามาศ'
  AND m.lastName = 'สุริยะวงศ์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 592: นางชนันทภรณ์ รูปะวิเชตร์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qxpq03ywi3i',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางชนันทภรณ์'
  AND m.lastName = 'รูปะวิเชตร์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 593: นางสาวสุกัญญา แสงทอง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w145flptw2qpj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุกัญญา'
  AND m.lastName = 'แสงทอง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 594: นายธีรวัฒน์  แสนคำ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11pn9uh11c3d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธีรวัฒน์'
  AND m.lastName = 'แสนคำ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 595: นางสาวสุภัสสร  ทิพย์อุบล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rmjkx4iz8c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุภัสสร'
  AND m.lastName = 'ทิพย์อุบล'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 596: นางสาวเกษร  พิพิธพงศ์สันต์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xw8npdorfy',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเกษร'
  AND m.lastName = 'พิพิธพงศ์สันต์'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 597: นางสาวแดงน้อย แซ่ย่าง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1nn173oqvhd',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'แม่ครัว',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวแดงน้อย'
  AND m.lastName = 'แซ่ย่าง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 598: นางสาวเซียวกวง แซ่จาง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1to9imbt1p8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'แม่ครัว',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเซียวกวง'
  AND m.lastName = 'แซ่จาง'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 599: นางอาเซียว มาเยอะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w13je83dki56j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'แม่ครัว',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางอาเซียว'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 600: นายหล่อปา หวุ่ยเมียะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1je86o6jbhwn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คนงาน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายหล่อปา'
  AND m.lastName = 'หวุ่ยเมียะ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 601: นางสาวกัญญา ยาผ่า | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1heh34b6ae07',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คนงาน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญญา'
  AND m.lastName = 'ยาผ่า'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 602: นายหล่อโย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1nknf5wbacf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คนงาน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายหล่อโย'
  AND m.lastName = NULL
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 603: นางสาวหมี่ซอ  เชกอ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12ebrjoc78bk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหมี่ซอ'
  AND m.lastName = 'เชกอ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 604: นายณัฐวุฒิ  ม่านอินทนิล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14dlihwkuufi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายณัฐวุฒิ'
  AND m.lastName = 'ม่านอินทนิล'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 605: นางสาวพรทิพย์ หวุ่ยยือกู่ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12nzf4hwa82u',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพรทิพย์'
  AND m.lastName = 'หวุ่ยยือกู่'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 606: นางสาวจวงจันทร์ เชอมือ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1f2t7q1jj0t5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจวงจันทร์'
  AND m.lastName = 'เชอมือ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 607: นายมานะ  เรืองสา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19l52jthlr3k',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'คนงาน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายมานะ'
  AND m.lastName = 'เรืองสา'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 608: นางสาวหมี่จู  มาเยอะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1d6s4hoaczuu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานร้านกาแฟ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวหมี่จู'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 609: นางสาวฤดี โสเช | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jwx9gphu5c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฤดี'
  AND m.lastName = 'โสเช'
  AND (s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%' OR s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 610: นางบุญชนิต   ธรรมสาร | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1r7oqrptx0pb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการโรงเรียนราษฎร์พัฒนา',
  m.joinDate,
  'โทร 091-853-7047',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางบุญชนิต'
  AND m.lastName = 'ธรรมสาร'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 611: นางสาวอังคณา   ยานะตระกูล | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16j8yho75fbx',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-482-0202',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอังคณา'
  AND m.lastName = 'ยานะตระกูล'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 612: นางสาวศิริพร   สวัสดิ์สุข | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1791bqjcxhkb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-388-2581',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริพร'
  AND m.lastName = 'สวัสดิ์สุข'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 613: นางสาวเวฬุวัน   ดีศรี | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14d2q05fbf55',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-493-3990',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเวฬุวัน'
  AND m.lastName = 'ดีศรี'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 614: นางสาวภัควลัญชน์ ผาบพิชวงศ์ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11vkcl6o9lxh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-1897-672',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภัควลัญชน์'
  AND m.lastName = 'ผาบพิชวงศ์'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 615: นางสาวรัตนวดี   ศรีมา | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1nbq4e6steem',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 083-082-2669',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวรัตนวดี'
  AND m.lastName = 'ศรีมา'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 616: นายจิรภัทร   แสนศักดิ์หาญ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ivl4lvwy5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 099-237-7972',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายจิรภัทร'
  AND m.lastName = 'แสนศักดิ์หาญ'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 617: นางสาวสุธารทิพย์   วุยแบ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10265ln4k5ktk',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 097-302-2584',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุธารทิพย์'
  AND m.lastName = 'วุยแบ'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 618: นายชนนภูมิ   เดชเดิม | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10wgocoz95ks',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 084-725-6724',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชนนภูมิ'
  AND m.lastName = 'เดชเดิม'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 619: นายวรภัทร   จันทร์สิริทอง | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1e47cqelk4bg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 098-416-6648',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวรภัทร'
  AND m.lastName = 'จันทร์สิริทอง'
  AND (s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 620: นายยุทธนา   	กันทาเดช | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gwrf2br510l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายยุทธนา'
  AND m.lastName = 'กันทาเดช'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 621: นายธีร์วรา    	ใจเย็น | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jv71c20nk4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธีร์วรา'
  AND m.lastName = 'ใจเย็น'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 622: นางสาวสุวิมล ศรีคำ | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w194emdrqpaea',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุวิมล'
  AND m.lastName = 'ศรีคำ'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 623: นางสาวอรอุมา ไชยชิน | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1f8pw06c1qfs',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรอุมา'
  AND m.lastName = 'ไชยชิน'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 624: นางสาวอาคิรา อุทธิยา | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12w5dvrhqoaj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอาคิรา'
  AND m.lastName = 'อุทธิยา'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 625: นายอัฒชัย    ใจเผิน | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zia3lowj3mb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอัฒชัย'
  AND m.lastName = 'ใจเผิน'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 626: นางสาวเก็จมณี กวางกระโดด | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17evtoml6kff',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเก็จมณี'
  AND m.lastName = 'กวางกระโดด'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 627: นายสุรศักดิ์   	กานิล | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1xc81fheigi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูวิกฤต',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุรศักดิ์'
  AND m.lastName = 'กานิล'
  AND (s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%' OR s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 628: โรเรียนบ้านใหม่สันติ  กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10k59ma91g0c',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  NULL,
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'โรเรียนบ้านใหม่สันติ'
  AND m.lastName = 'กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 629: นายเอกชัย  ใจอ้าย | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1psyhjyaua8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผอ.',
  m.joinDate,
  'โทร 087-2028762',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกชัย'
  AND m.lastName = 'ใจอ้าย'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 630: นายเอกรัฐ  น้อยมา | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w13bjo9sfqbat',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-6867133',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกรัฐ'
  AND m.lastName = 'น้อยมา'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 631: นางสาวกะรัต รัตนจำเริญ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14p5qkdw7e3a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-9944408',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกะรัต'
  AND m.lastName = 'รัตนจำเริญ'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 632: นางสาวชนัญธิดา  นุธรรม | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1poxeoz2z7qm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 080-9941949',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวชนัญธิดา'
  AND m.lastName = 'นุธรรม'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 633: นายธนรัฐ  วรรณดี | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1rofjrzx79za',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 082-8646492',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนรัฐ'
  AND m.lastName = 'วรรณดี'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 634: นางสาวปัฐภัธ ญาณพันธ์ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z0mpepk6sxp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 062-1742238',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปัฐภัธ'
  AND m.lastName = 'ญาณพันธ์'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 635: นางสาวอริญช์ณิชา  เดชธนาอัครพงศ์ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10uv8keqs24s',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 098-3397721',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอริญช์ณิชา'
  AND m.lastName = 'เดชธนาอัครพงศ์'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 636: นางสาววรรณกานต์  กะโพ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1uqd7fqlhqr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 080-0780092',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววรรณกานต์'
  AND m.lastName = 'กะโพ'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 637: ว่าที่ร้อยตรีเนติพงษ์  จักรดี | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w14taeasyv4ya',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 093-2866528',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีเนติพงษ์'
  AND m.lastName = 'จักรดี'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 638: นายสมศักดิ์  อุดมประสิทธิ์ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1s30uw3d391',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 095-3315441',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสมศักดิ์'
  AND m.lastName = 'อุดมประสิทธิ์'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 639: นางสาวพิมพ์ภัช  แสงดาว | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w19boo0f2zj05',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการ',
  m.joinDate,
  'โทร 091-0730255',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์ภัช'
  AND m.lastName = 'แสงดาว'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 640: นายหล้า  พรมใจ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1g5ckkfsvkp8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 064-9950334',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายหล้า'
  AND m.lastName = 'พรมใจ'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 641: นางเงิน  พรใจ | รร.บ้านใหม่สันติ
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wsnnrq90mr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'แม่ครัว',
  m.joinDate,
  'โทร 093-3086084',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางเงิน'
  AND m.lastName = 'พรใจ'
  AND (s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%' OR s.code = 'SCH_026_รร.บ้านใหม่สันติ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 642: นายศุภโชค ปิยะสันติ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1kmsg5xq5qbo',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 084-1518181',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศุภโชค'
  AND m.lastName = 'ปิยะสันติ์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 643: นางสาวณัฐรดี สิทธิกัน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ya1cc0njbx',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'รองผู้อำนวยการ',
  m.joinDate,
  'โทร 086-1917156',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐรดี'
  AND m.lastName = 'สิทธิกัน'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 644: นางขวัญจิตร จันทิพย์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1hmdn40txiw4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 089-4290819',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางขวัญจิตร'
  AND m.lastName = 'จันทิพย์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 645: นางทศพร สมยง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1j8c4m301dx8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 083-2088349',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางทศพร'
  AND m.lastName = 'สมยง'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 646: นายพนม สมยง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w12kfdhfqnsh6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 089-5575037',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพนม'
  AND m.lastName = 'สมยง'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 647: นางสาววิลาวัลย์ อุ่นนันกาศ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vemfx2vbunn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 093-1515914',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววิลาวัลย์'
  AND m.lastName = 'อุ่นนันกาศ'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 648: นายชาญชัย ก้อใจ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1iggrxhag4e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 087-5048099',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชาญชัย'
  AND m.lastName = 'ก้อใจ'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 649: นางรุ่งทิวา จันทาพูน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w180ldxaypp2g',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 084-6093473',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางรุ่งทิวา'
  AND m.lastName = 'จันทาพูน'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 650: นางจันจิรา ชัยภูวนารถ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1ayo1w2wfadn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 093-2596868',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางจันจิรา'
  AND m.lastName = 'ชัยภูวนารถ'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 651: นางสาวธมลวรรณ มากปรางค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z17j20m398j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการพิเศษ',
  m.joinDate,
  'โทร 063-7959539',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธมลวรรณ'
  AND m.lastName = 'มากปรางค์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 652: นายวัชรินทร์ ฤทธิรักษ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1p20haxyelb8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 080-4915400',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวัชรินทร์'
  AND m.lastName = 'ฤทธิรักษ์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 653: นายอนุศักดิ์ ฮงประยูร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17ghwyvyqoa6',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 098-9020333',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอนุศักดิ์'
  AND m.lastName = 'ฮงประยูร'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 654: นางสาวณัฐชยา  ปันก่อ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1955e2ypbtn5',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 098-6454255',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐชยา'
  AND m.lastName = 'ปันก่อ'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 655: นางสาวภิญประภา  ใจทน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vd2uc966c3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 081-5152442',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวภิญประภา'
  AND m.lastName = 'ใจทน'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 656: นางสาวเสาวลักษณ์ นาใจ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1yq3rsn4p0t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 091-8565146',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวเสาวลักษณ์'
  AND m.lastName = 'นาใจ'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 657: นายมนตรี คำเงิน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11gu020blvpn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 063-6732191',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายมนตรี'
  AND m.lastName = 'คำเงิน'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 658: นายภาณุพงศ์ เปาวัลย์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1t2q8h08y99l',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 082-4829049',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายภาณุพงศ์'
  AND m.lastName = 'เปาวัลย์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 659: นายมงคล ดิลกอุดมฤกษ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wqiqiewo57',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูชำนาญการ',
  m.joinDate,
  'โทร 065-0101826',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายมงคล'
  AND m.lastName = 'ดิลกอุดมฤกษ์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 660: นางสาวกัลยารัตน์ อนุรุส | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w195vk2jfy4n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 097-2717693',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัลยารัตน์'
  AND m.lastName = 'อนุรุส'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 661: นางสาวกมลวรรณ สุวรรณมงคล | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w168icvkmgs9f',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 063-7844869',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกมลวรรณ'
  AND m.lastName = 'สุวรรณมงคล'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 662: นางสาวปวีณา คำฟู | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1n6yrumt5ib',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 084-1729446',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปวีณา'
  AND m.lastName = 'คำฟู'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 663: นางสาวนงลักษณ์ บุญระชัยสวรรค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wxdndnnsvja',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 086-4067520',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนงลักษณ์'
  AND m.lastName = 'บุญระชัยสวรรค์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 664: นางสาวกิตติลักษณ์ วงษาหาร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1367b03f5ttp',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 094-2631039',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกิตติลักษณ์'
  AND m.lastName = 'วงษาหาร'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 665: นายเกรียงไกร ไชยวงค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w186e0vf14d5w',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 081-4727141',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเกรียงไกร'
  AND m.lastName = 'ไชยวงค์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 666: นางสาวกนกวรรณ จันทร์เนตร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1gu2q6tdsus',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-0847565',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกนกวรรณ'
  AND m.lastName = 'จันทร์เนตร'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 667: นายพริษศ์ ไพรี | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1vz7wi90yhal',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู คศ.1',
  m.joinDate,
  'โทร 061-2687487',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายพริษศ์'
  AND m.lastName = 'ไพรี'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 668: นางสาวจิรัญญา ร่องตอง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1lwbcwy43rbj',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 062-9382151',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิรัญญา'
  AND m.lastName = 'ร่องตอง'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 669: นางสาวปียาภรณ์ กิ่งแก้ว | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1pjqts0k48x',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยงเด็กฯ',
  m.joinDate,
  'โทร 086-1952826',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปียาภรณ์'
  AND m.lastName = 'กิ่งแก้ว'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 670: นางลัดดาวัลย์ ไสยวรรณ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w17wss47k2iia',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 082-1851817',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางลัดดาวัลย์'
  AND m.lastName = 'ไสยวรรณ์'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 671: นายอานนท์ ทะนุตัน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1jfk1d8pcyu',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 096-6742702',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายอานนท์'
  AND m.lastName = 'ทะนุตัน'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 672: นางสาวมณีวรรณ ชมภูสมษา | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1tyli3hseqwn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 089-8526887',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมณีวรรณ'
  AND m.lastName = 'ชมภูสมษา'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 673: นายนัฝทาลี กิตติคุณรุ่งเรือง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1a7zrxb9ffac',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 086-3116735',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนัฝทาลี'
  AND m.lastName = 'กิตติคุณรุ่งเรือง'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 674: นางสาวจันจิรา พิมดี | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qmekcbwbo8j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูอัตราจ้าง',
  m.joinDate,
  'โทร 098-8434994',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจันจิรา'
  AND m.lastName = 'พิมดี'
  AND (s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%' OR s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 675: นางสาวศิริพร ดวงดี | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w11th6mui5bqv',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 096-2282643',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริพร'
  AND m.lastName = 'ดวงดี'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 676: นายไพรัช สุขเกษม | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1scaa9vr7lhe',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 065-2387935',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไพรัช'
  AND m.lastName = 'สุขเกษม'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 677: นางสาวอารียา วงค์วุฒิ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1d5rgfjom5yg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 096-7462365',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอารียา'
  AND m.lastName = 'วงค์วุฒิ'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 678: นางสาวจารุวรรณ จันวัน | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w18qcaex9ca6y',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 087-3578211',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'จันวัน'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 679: นางสาวสาริกา มาลา | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1zg5iii5onyi',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 0098-0348285',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสาริกา'
  AND m.lastName = 'มาลา'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 680: นางสาวปานทิพย์ จินะโกษฐ์ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1wwbk6ugfh8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 094-7571701',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวปานทิพย์'
  AND m.lastName = 'จินะโกษฐ์'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 681: นางสาวทิพย์อัปสร ลาวิชัย | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16zsdvhpc9zy',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  'โทร 095-1419444',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวทิพย์อัปสร'
  AND m.lastName = 'ลาวิชัย'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 682: นายไกรสร หลีทำ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1qq6ujgpszic',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'อัตราจ้าง',
  m.joinDate,
  'โทร 088-2951142',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายไกรสร'
  AND m.lastName = 'หลีทำ'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 683: นางสาวสุมาลัย อามอ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z4gckx3aut',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  'โทร 095-3547151',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุมาลัย'
  AND m.lastName = 'อามอ'
  AND (s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%' OR s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 684: นางสาวจิรัชญา  ผาลา | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1u2bekf625t8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจิรัชญา'
  AND m.lastName = 'ผาลา'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 685: นางสาวจารุวรรณ  สิงห์เชื้อ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1z7p676hw0cf',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวจารุวรรณ'
  AND m.lastName = 'สิงห์เชื้อ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 686: นางธนิดา  แก้วคำฟู | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w10114y0u0pjsb',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางธนิดา'
  AND m.lastName = 'แก้วคำฟู'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 687: นายนควัฒน์  กุณะด้วง | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w16urdgdw016m',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนควัฒน์'
  AND m.lastName = 'กุณะด้วง'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 688: นางสาวธิษตยา  ภิระบัน | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w1sd3id11l41r',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธิษตยา'
  AND m.lastName = 'ภิระบัน'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 689: นางสาวธิดาวรรณ  ทองใบ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2dqh0i51ttwm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวธิดาวรรณ'
  AND m.lastName = 'ทองใบ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 690: นางสาวณัฐชยา  สุริยะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2m5kh2jnfrn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวณัฐชยา'
  AND m.lastName = 'สุริยะ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 691: นางสาวสกุลรัตน์  โมงยาม | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w27fie6o6ndef',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสกุลรัตน์'
  AND m.lastName = 'โมงยาม'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 692: นางสาวศิริพร  พะเงาะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2ejjbmo0f73a',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศิริพร'
  AND m.lastName = 'พะเงาะ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 693: นางสาวนฤภร  ทามัน | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2k4ryzzb1zm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนฤภร'
  AND m.lastName = 'ทามัน'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 694: นายศิริมงคล  อูปคำ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2a7ylzh1ddff',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายศิริมงคล'
  AND m.lastName = 'อูปคำ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 695: นางสาวมุกดา  อศิกุล | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w29zr6rja030d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมุกดา'
  AND m.lastName = 'อศิกุล'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 696: นางสาวสรันดา  วงค์นาง | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2nn4ouojf4d',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสรันดา'
  AND m.lastName = 'วงค์นาง'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 697: ว่าที่ร้อยตรีหญิงอมรรัตน์  นันทิยา | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2woq89hg2wy',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'ว่าที่ร้อยตรีหญิงอมรรัตน์'
  AND m.lastName = 'นันทิยา'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 698: นางสาวศุภนิช   มูลทาศรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2tbeomrem61',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'พนักงานราชการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศุภนิช'
  AND m.lastName = 'มูลทาศรี'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 699: นางสาวประทุมพร  พรรณมณีพร | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2jjlm0g11a8',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูพี่เลี้ยงเด็กพิการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวประทุมพร'
  AND m.lastName = 'พรรณมณีพร'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 700: นางสาวนารี  ต้องสู้คีรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2hn27bge5xak',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ธุรการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนารี'
  AND m.lastName = 'ต้องสู้คีรี'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 701: นางสาวอัมพร  พร้อมชัยศรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2f7xn1wo5oim',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'เจ้าหน้าที่ USO Net',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอัมพร'
  AND m.lastName = 'พร้อมชัยศรี'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 702: นายนพฤทธิ์  มาเยอะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w24w7ft17y9kt',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนพฤทธิ์'
  AND m.lastName = 'มาเยอะ'
  AND (s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 703: นายนิรุตต์  ชัยมณี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2amhxpnt2wvm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนิรุตต์'
  AND m.lastName = 'ชัยมณี'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 704: นายสวาท  เย็นใจมา | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w20vro4gh230w',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสวาท'
  AND m.lastName = 'เย็นใจมา'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 705: นางอัมพร  วสันต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2whcbsm1q0j',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางอัมพร'
  AND m.lastName = 'วสันต์'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 706: นายสุทธิพันธ์  ดวงสุข | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2cfhgn99p4n',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายสุทธิพันธ์'
  AND m.lastName = 'ดวงสุข'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 707: นายวุฒิชัย  กันใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w24xljq27o2d4',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายวุฒิชัย'
  AND m.lastName = 'กันใจ'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 708: นายธนกฤต  วิริยะจิตต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w28mkwu8adj7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายธนกฤต'
  AND m.lastName = 'วิริยะจิตต์'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 709: นางสาวสุชาวดี  จิตต์ใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2ugfmn6yxatr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชาวดี'
  AND m.lastName = 'จิตต์ใจ'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 710: นางสาวอรสา ทะลิ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2x4tq758vjn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอรสา'
  AND m.lastName = 'ทะลิ'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 711: นายคณาวุฒิ  มูลทาศรี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2qfbagvy1jr9',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายคณาวุฒิ'
  AND m.lastName = 'มูลทาศรี'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 712: นางสาวสิริรัตน์  สุนสะดี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2b9i9caw5uov',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสิริรัตน์'
  AND m.lastName = 'สุนสะดี'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 713: นางสาวอำพร  อรหันต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w29ylhpfux57t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวอำพร'
  AND m.lastName = 'อรหันต์'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 714: นางกัญชริภา  ทะจันทร์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w20hlpjpzvssyh',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกัญชริภา'
  AND m.lastName = 'ทะจันทร์'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 715: นายนวมินตร์  ตาใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2x6yquhrkw4b',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายนวมินตร์'
  AND m.lastName = 'ตาใจ'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 716: นายชินกร  จองหนุ่ม | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2kirodm8c1z',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายชินกร'
  AND m.lastName = 'จองหนุ่ม'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 717: นางสาวมีนาร์  อารีย์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w29l788gk1bnm',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวมีนาร์'
  AND m.lastName = 'อารีย์'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 718: นายเอกพงษ์  กาแก้ว | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w210x94xicuwl',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ธุรการโรงเรียน',
  m.joinDate,
  NULL,
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายเอกพงษ์'
  AND m.lastName = 'กาแก้ว'
  AND (s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 719: นางกุลธิดา อดิลักษณ์ศิริ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w27y01yam2o7e',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ผู้อำนวยการ',
  m.joinDate,
  'โทร 081-1665565',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางกุลธิดา'
  AND m.lastName = 'อดิลักษณ์ศิริ'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 720: นางภาระวี อินนวล | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2w5juli2h8oq',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู ค.ศ.3',
  m.joinDate,
  'โทร 065-6322595',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางภาระวี'
  AND m.lastName = 'อินนวล'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 721: นางสาวทัศนีย์ โสภณอำนวยกิจ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w27hf174qq5x3',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู ค.ศ.3',
  m.joinDate,
  'โทร 082-1908315',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวทัศนีย์'
  AND m.lastName = 'โสภณอำนวยกิจ'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 722: นางสาววราภรณ์ ไชยานันตา | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2eg2vrbiru98',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-0107632',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาววราภรณ์'
  AND m.lastName = 'ไชยานันตา'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 723: นางสาวกัญญารัตน์ ตาโม่ง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2m5ck9o4ay7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-9314949',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกัญญารัตน์'
  AND m.lastName = 'ตาโม่ง'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 724: นางสาวกานติมา เกตสระไชย | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2xftsvxw8qdn',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 093-2397727',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวกานติมา'
  AND m.lastName = 'เกตสระไชย'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 725: นางสาวศศิกานต์ ดาชิต | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2b1hhgqwhu2t',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 092-7841523',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวศศิกานต์'
  AND m.lastName = 'ดาชิต'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 726: นางสาวสุชาดา เครือคำวัง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2rgfri3z9w1',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 080-6714082',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวสุชาดา'
  AND m.lastName = 'เครือคำวัง'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 727: นางสาวพัชรา บุญสุวรรณ์ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2g6m4tnempab',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครู',
  m.joinDate,
  'โทร 094-8401127',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพัชรา'
  AND m.lastName = 'บุญสุวรรณ์'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 728: นางสาวนิภาวรรณ การเจริญ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2bgnpkk687mr',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 099-9982065',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวนิภาวรรณ'
  AND m.lastName = 'การเจริญ'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 729: นางสาวฐิตาภรณ์ โยงยศ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2dtdfvid6r7',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 097-9471813',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวฐิตาภรณ์'
  AND m.lastName = 'โยงยศ'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 730: นางสาวพิมพ์จันทร์ ทานศิลา | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2e4imkzikcvg',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'ครูผู้ช่วย',
  m.joinDate,
  'โทร 096-2853002',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นางสาวพิมพ์จันทร์'
  AND m.lastName = 'ทานศิลา'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;

-- แถว 731: นายประทวน ขัดบุญเรือง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `AssociationMember` (`id`, `memberId`, `schoolId`, `memberTypeId`, `associationMemberNo`, `position`, `associationJoinDate`, `notes`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq0l8w2rhd5jcl4fso',
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  'นักการภารโรง',
  m.joinDate,
  'โทร 061-1530498',
  '2026-02-17 02:59:11',
  '2026-02-17 02:59:11'
FROM `Member` m
INNER JOIN `School` s ON m.schoolId = s.id
WHERE m.firstName = 'นายประทวน'
  AND m.lastName = 'ขัดบุญเรือง'
  AND (s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%' OR s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ')
  AND NOT EXISTS (SELECT 1 FROM `AssociationMember` am WHERE am.memberId = m.id)
LIMIT 1;
