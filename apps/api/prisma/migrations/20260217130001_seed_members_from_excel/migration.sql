-- Migration: Seed Member จาก doc/member_data.xlsx
-- สร้างโดย excel-to-migration.ts | รวมข้อมูลทุก sheet
-- จำนวน: 731 รายการ
-- หมายเหตุ: ต้องมี School และ MemberType แล้ว (รัน seed_schools และ prisma db seed ก่อน)

-- แถว 1: นางกรองแก้ว พรมรักษ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntezew2z95i74',
  'M00001',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกรองแก้ว',
  'พรมรักษ์',
  '085-6180464',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกรองแก้ว' AND m.lastName = 'พรมรักษ์'
  )
LIMIT 1;
-- แถว 2: นางสาวพัชรี สิงห์ฉลาด | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntec1dbvx1hsou',
  'M00002',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัชรี',
  'สิงห์ฉลาด',
  '091-0793411',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัชรี' AND m.lastName = 'สิงห์ฉลาด'
  )
LIMIT 1;
-- แถว 3: นางสาววนิดา อยู่อินทร์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntenwxfuiemc1',
  'M00003',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววนิดา',
  'อยู่อินทร์',
  '088-2945726',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววนิดา' AND m.lastName = 'อยู่อินทร์'
  )
LIMIT 1;
-- แถว 4: นายอนุรักษ์ ใจปัญธิ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte27m4k94tkpfj',
  'M00004',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอนุรักษ์',
  'ใจปัญธิ',
  '087-1757611',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอนุรักษ์' AND m.lastName = 'ใจปัญธิ'
  )
LIMIT 1;
-- แถว 5: นางสาวภัณฑิรา หวายคำ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntemgbbkxt64tr',
  'M00005',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัณฑิรา',
  'หวายคำ',
  '095-1274994',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัณฑิรา' AND m.lastName = 'หวายคำ'
  )
LIMIT 1;
-- แถว 6: นายสมทรัพย์ รัตตพิทักษ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntezvc69t1um5',
  'M00006',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมทรัพย์',
  'รัตตพิทักษ์',
  '083-7622879',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมทรัพย์' AND m.lastName = 'รัตตพิทักษ์'
  )
LIMIT 1;
-- แถว 7: นางสาวอรอนงค์ บุตรแสน | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntefcgrrkc33s5',
  'M00007',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรอนงค์',
  'บุตรแสน',
  '098-3294474',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรอนงค์' AND m.lastName = 'บุตรแสน'
  )
LIMIT 1;
-- แถว 8: นายพิชญ์ยุทธ์ นาวา | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntektq4wf6zz6p',
  'M00008',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิชญ์ยุทธ์',
  'นาวา',
  '061-3151418',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิชญ์ยุทธ์' AND m.lastName = 'นาวา'
  )
LIMIT 1;
-- แถว 9: นางสาวจิราวรรณ อภิรมย์ฤทัย | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteuefwswduicc',
  'M00009',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิราวรรณ',
  'อภิรมย์ฤทัย',
  '082-6989728',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิราวรรณ' AND m.lastName = 'อภิรมย์ฤทัย'
  )
LIMIT 1;
-- แถว 10: นางสาวนุชนาถ ศรีบัวบาน | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteql4286s51r',
  'M00010',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนุชนาถ',
  'ศรีบัวบาน',
  '091-7423271',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนุชนาถ' AND m.lastName = 'ศรีบัวบาน'
  )
LIMIT 1;
-- แถว 11: นายกันต์ณภัทร สิริโชติชัยกุล | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteafj5yo6g019',
  'M00011',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกันต์ณภัทร',
  'สิริโชติชัยกุล',
  '092-8955915',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกันต์ณภัทร' AND m.lastName = 'สิริโชติชัยกุล'
  )
LIMIT 1;
-- แถว 12: นายภาณุพงศ์ นภัสกรชัย | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntecocxlwl30c8',
  'M00012',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภาณุพงศ์',
  'นภัสกรชัย',
  '093-2707659',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภาณุพงศ์' AND m.lastName = 'นภัสกรชัย'
  )
LIMIT 1;
-- แถว 13: นางสาวอัญชลี โปทา | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte9hwdfg3bef',
  'M00013',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัญชลี',
  'โปทา',
  '065-2197838',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัญชลี' AND m.lastName = 'โปทา'
  )
LIMIT 1;
-- แถว 14: นางสาวอรจิรา สมบูรณ์ | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntelirst1yt7gh',
  'M00014',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรจิรา',
  'สมบูรณ์',
  '094-7040225',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรจิรา' AND m.lastName = 'สมบูรณ์'
  )
LIMIT 1;
-- แถว 15: นางสาวภารุจีร์ แซ่ลี | โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntey72mq69qd7f',
  'M00015',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภารุจีร์',
  'แซ่ลี',
  '093-7134791',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_001_ชุมชนศึกษา_บ้านแม่สะ' OR s.name = 'โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนชุมชนศึกษา (บ้านแม่สะแลป) กลุ่มเครือข่ายพั%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภารุจีร์' AND m.lastName = 'แซ่ลี'
  )
LIMIT 1;
-- แถว 16: นายกิตติกร   ต๊ะคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte7y9fauvngle',
  'M00016',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกิตติกร',
  'ต๊ะคำ',
  '085-6944424',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกิตติกร' AND m.lastName = 'ต๊ะคำ'
  )
LIMIT 1;
-- แถว 17: นายไกรวิชญ์  วงค์สุรินทร์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteisgqo3c4ow',
  'M00017',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไกรวิชญ์',
  'วงค์สุรินทร์',
  '834541701',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไกรวิชญ์' AND m.lastName = 'วงค์สุรินทร์'
  )
LIMIT 1;
-- แถว 18: นางพูลศิริ   เมธีรัตนกูล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntenxrxp7xlbda',
  'M00018',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางพูลศิริ',
  'เมธีรัตนกูล',
  '084-4613754',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางพูลศิริ' AND m.lastName = 'เมธีรัตนกูล'
  )
LIMIT 1;
-- แถว 19: นายพิพัฒน์   เมธีรัตนกูล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte1w30jp56rgu',
  'M00019',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิพัฒน์',
  'เมธีรัตนกูล',
  '093-2943690',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิพัฒน์' AND m.lastName = 'เมธีรัตนกูล'
  )
LIMIT 1;
-- แถว 20: นายสุรชัย   คำมงคล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntemv2pbel84k',
  'M00020',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรชัย',
  'คำมงคล',
  '083-7658902',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรชัย' AND m.lastName = 'คำมงคล'
  )
LIMIT 1;
-- แถว 21: นางสาวนิภาพร   ทองขันนาค | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteawm32k8055f',
  'M00021',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิภาพร',
  'ทองขันนาค',
  '091-3064674',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิภาพร' AND m.lastName = 'ทองขันนาค'
  )
LIMIT 1;
-- แถว 22: นางสาวพิมพ์ใจ   นารีรักษ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8r3nyfune1c',
  'M00022',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์ใจ',
  'นารีรักษ์',
  '096-8781849',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์ใจ' AND m.lastName = 'นารีรักษ์'
  )
LIMIT 1;
-- แถว 23: นางสาววัชรีพร   ก้อนคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntezepaz4z5pzh',
  'M00023',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววัชรีพร',
  'ก้อนคำ',
  '095-8584453',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววัชรีพร' AND m.lastName = 'ก้อนคำ'
  )
LIMIT 1;
-- แถว 24: นางสาวปฐมาภรณ์   เคร่งครัด | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntecjdy4mecowm',
  'M00024',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปฐมาภรณ์',
  'เคร่งครัด',
  '094-7029705',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปฐมาภรณ์' AND m.lastName = 'เคร่งครัด'
  )
LIMIT 1;
-- แถว 25: นางสาวนิชาภัทร   สว่างถาวรกุล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteb4iktxtnrwk',
  'M00025',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิชาภัทร',
  'สว่างถาวรกุล',
  '086-4296892',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิชาภัทร' AND m.lastName = 'สว่างถาวรกุล'
  )
LIMIT 1;
-- แถว 26: นางสาวดวงพร   สมเมือง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntefbnyvqfjoso',
  'M00026',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวดวงพร',
  'สมเมือง',
  '086-4984618',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวดวงพร' AND m.lastName = 'สมเมือง'
  )
LIMIT 1;
-- แถว 27: นางสาวชญาน์ทิพย์   กาสม | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8piyppypij4',
  'M00027',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชญาน์ทิพย์',
  'กาสม',
  '081-6716139',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชญาน์ทิพย์' AND m.lastName = 'กาสม'
  )
LIMIT 1;
-- แถว 28: นางสาวอัมพิกา   สมศักดิ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteglac3m3ji0s',
  'M00028',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัมพิกา',
  'สมศักดิ์',
  '081-1670232',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัมพิกา' AND m.lastName = 'สมศักดิ์'
  )
LIMIT 1;
-- แถว 29: นายณรงค์ฤทธิ์   ชัยประดล | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntenqnwnufyct9',
  'M00029',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณรงค์ฤทธิ์',
  'ชัยประดล',
  '083-8304969',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณรงค์ฤทธิ์' AND m.lastName = 'ชัยประดล'
  )
LIMIT 1;
-- แถว 30: นายรัฐพงศ์   สมทิพย์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntebm1yztb7pyb',
  'M00030',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายรัฐพงศ์',
  'สมทิพย์',
  '085-7147891',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายรัฐพงศ์' AND m.lastName = 'สมทิพย์'
  )
LIMIT 1;
-- แถว 31: นายอิทธิพัทธ์   นัยติ๊บ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntem0hy3iwhgk',
  'M00031',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอิทธิพัทธ์',
  'นัยติ๊บ',
  '090-3165159',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอิทธิพัทธ์' AND m.lastName = 'นัยติ๊บ'
  )
LIMIT 1;
-- แถว 32: นายชานนท์   วงศ์นันทเจริญ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteo0q19owtgw',
  'M00032',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชานนท์',
  'วงศ์นันทเจริญ',
  '084-7405243',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชานนท์' AND m.lastName = 'วงศ์นันทเจริญ'
  )
LIMIT 1;
-- แถว 33: นางสาวทองประกาย   ก้างออนตา | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntehd8sebmlijr',
  'M00033',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวทองประกาย',
  'ก้างออนตา',
  '091-0713306',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวทองประกาย' AND m.lastName = 'ก้างออนตา'
  )
LIMIT 1;
-- แถว 34: นางสาวพรรณนิกา เขื่อนเชียงสา | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntettd8fk4j00h',
  'M00034',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพรรณนิกา',
  'เขื่อนเชียงสา',
  '093-9458719',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพรรณนิกา' AND m.lastName = 'เขื่อนเชียงสา'
  )
LIMIT 1;
-- แถว 35: นางสาวธีร์จุฑา   แจ้งสว่าง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntesx88fewnmog',
  'M00035',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธีร์จุฑา',
  'แจ้งสว่าง',
  '095-1483399',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธีร์จุฑา' AND m.lastName = 'แจ้งสว่าง'
  )
LIMIT 1;
-- แถว 36: นางสาวเพชรา  คชเพชร | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteb7l5swozbok',
  'M00036',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเพชรา',
  'คชเพชร',
  '092-9946335',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเพชรา' AND m.lastName = 'คชเพชร'
  )
LIMIT 1;
-- แถว 37: นางสาวกัญจนพร มาเยอะ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntev2n5mk7kg9',
  'M00037',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญจนพร',
  'มาเยอะ',
  '061-3030116',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญจนพร' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 38: นางสาวเมขลา เยอะหนื่อ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntekz5gfj7g6r',
  'M00038',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเมขลา',
  'เยอะหนื่อ',
  '096-9021950',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเมขลา' AND m.lastName = 'เยอะหนื่อ'
  )
LIMIT 1;
-- แถว 39: นางสาวพัทธ์ธีรา  กิจตาวงค์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntempmuca469z',
  'M00039',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัทธ์ธีรา',
  'กิจตาวงค์',
  '096-8212649',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัทธ์ธีรา' AND m.lastName = 'กิจตาวงค์'
  )
LIMIT 1;
-- แถว 40: นางสาวศิริลักษณ์  งามหมู่ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte2664idbj76c',
  'M00040',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริลักษณ์',
  'งามหมู่',
  '091-1394423',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริลักษณ์' AND m.lastName = 'งามหมู่'
  )
LIMIT 1;
-- แถว 41: นายณัฐวุฒิ   เป็กยันเมือง | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte5nhl5eqocda',
  'M00041',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐวุฒิ',
  'เป็กยันเมือง',
  '084-1715006',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐวุฒิ' AND m.lastName = 'เป็กยันเมือง'
  )
LIMIT 1;
-- แถว 42: นางสาวมยุรฉัตร  ปรารมณ์ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntejomzkldjxac',
  'M00042',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมยุรฉัตร',
  'ปรารมณ์',
  '095-7120859',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมยุรฉัตร' AND m.lastName = 'ปรารมณ์'
  )
LIMIT 1;
-- แถว 43: นายศรายุทธ  บุญคำ | โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntexei3e5sy0b',
  'M00043',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศรายุทธ',
  'บุญคำ',
  '063-0616495',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_002_.ตชด.เจ้าพ่อหลวงอุปถ' OR s.name = 'โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอนุสรณ์ 4) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน.ตชด.เจ้าพ่อหลวงอุปถัมภ์ 3 (ช่างกลปทุมวันอ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศรายุทธ' AND m.lastName = 'บุญคำ'
  )
LIMIT 1;
-- แถว 44: นายสมจิตร คําปา | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8bnz3pnera6',
  'M00044',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมจิตร',
  'คําปา',
  '088-2526952',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมจิตร' AND m.lastName = 'คําปา'
  )
LIMIT 1;
-- แถว 45: นางสาวเมธิญา ยะขาว | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteymmx9pnj28e',
  'M00045',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเมธิญา',
  'ยะขาว',
  '097-9534613',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเมธิญา' AND m.lastName = 'ยะขาว'
  )
LIMIT 1;
-- แถว 46: นายคนองเมฆ ใจสุข | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntei121ls6syb',
  'M00046',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคนองเมฆ',
  'ใจสุข',
  '092-2684723',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคนองเมฆ' AND m.lastName = 'ใจสุข'
  )
LIMIT 1;
-- แถว 47: นายทรงกรด ทายะนา | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteox42ow5ud2',
  'M00047',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายทรงกรด',
  'ทายะนา',
  '087-3570552',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายทรงกรด' AND m.lastName = 'ทายะนา'
  )
LIMIT 1;
-- แถว 48: นางสาวณฐมน จิตรประสาร | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteo89aq6xzjd',
  'M00048',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณฐมน',
  'จิตรประสาร',
  '093-2392263',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณฐมน' AND m.lastName = 'จิตรประสาร'
  )
LIMIT 1;
-- แถว 49: นายนภจร โยธาภักดิ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteayxzystwaqs',
  'M00049',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนภจร',
  'โยธาภักดิ์',
  '085-8833667',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนภจร' AND m.lastName = 'โยธาภักดิ์'
  )
LIMIT 1;
-- แถว 50: นายธนาวุฒิ ศรีบริบูรณ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntelk76ot6qz3k',
  'M00050',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนาวุฒิ',
  'ศรีบริบูรณ์',
  '090-1025904',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนาวุฒิ' AND m.lastName = 'ศรีบริบูรณ์'
  )
LIMIT 1;
-- แถว 51: นางสาวนันทนา เสรีสวัสดิ์ศรี | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte3vbi7guj6al',
  'M00051',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนันทนา',
  'เสรีสวัสดิ์ศรี',
  '064-2103194',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนันทนา' AND m.lastName = 'เสรีสวัสดิ์ศรี'
  )
LIMIT 1;
-- แถว 52: นางสาววิมลสิริ เคนทรภักดิ์ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte98tu9aj2sl6',
  'M00052',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิมลสิริ',
  'เคนทรภักดิ์',
  '088-6608534',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิมลสิริ' AND m.lastName = 'เคนทรภักดิ์'
  )
LIMIT 1;
-- แถว 53: นางสาวศรสวรรค์ มาเยอ | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8i7io9lw6ot',
  'M00053',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศรสวรรค์',
  'มาเยอ',
  '088-2526952',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศรสวรรค์' AND m.lastName = 'มาเยอ'
  )
LIMIT 1;
-- แถว 54: นายฤทธี วังเอี่ยม | โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteek05klxsjaw',
  'M00054',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฤทธี',
  'วังเอี่ยม',
  '097-2407545',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_003_บ้านผาเดื่อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านผาเดื่อ กลุ่มเครือข่ายพัฒนาการศึกษาแม่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฤทธี' AND m.lastName = 'วังเอี่ยม'
  )
LIMIT 1;
-- แถว 55: นางสาวกมลลักษณ์ จันทร์หลวง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteu3w89roja8',
  'M00055',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกมลลักษณ์',
  'จันทร์หลวง',
  '082-1641455',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกมลลักษณ์' AND m.lastName = 'จันทร์หลวง'
  )
LIMIT 1;
-- แถว 56: นายสมชาย วจนะพระคุณไพศาล | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteita7g1a83v',
  'M00056',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมชาย',
  'วจนะพระคุณไพศาล',
  '061-3568852',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมชาย' AND m.lastName = 'วจนะพระคุณไพศาล'
  )
LIMIT 1;
-- แถว 57: นางสาวกาญจนาพร วงค์ชัย | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nted1cj2kjg1e',
  'M00057',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกาญจนาพร',
  'วงค์ชัย',
  '082-7819570',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกาญจนาพร' AND m.lastName = 'วงค์ชัย'
  )
LIMIT 1;
-- แถว 58: นายลิลิณชยา พราหมณ์แก้ว | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntewln9suhej6t',
  'M00058',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายลิลิณชยา',
  'พราหมณ์แก้ว',
  '080-1153822',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายลิลิณชยา' AND m.lastName = 'พราหมณ์แก้ว'
  )
LIMIT 1;
-- แถว 59: นายวงศกร หลวงสา | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntefv30xfuvzah',
  'M00059',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวงศกร',
  'หลวงสา',
  '087-1461928',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวงศกร' AND m.lastName = 'หลวงสา'
  )
LIMIT 1;
-- แถว 60: นายศุภณัฐ เม่นแย้ม | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntez5nvc9snoh',
  'M00060',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศุภณัฐ',
  'เม่นแย้ม',
  '087-5661741',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศุภณัฐ' AND m.lastName = 'เม่นแย้ม'
  )
LIMIT 1;
-- แถว 61: นายสิงหา ภูธิเบศน์ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteob1dwcb2lue',
  'M00061',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสิงหา',
  'ภูธิเบศน์',
  '083-9399255',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสิงหา' AND m.lastName = 'ภูธิเบศน์'
  )
LIMIT 1;
-- แถว 62: นางสาวเจนจิรา สีสะอาด | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte71nbn5cpenu',
  'M00062',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเจนจิรา',
  'สีสะอาด',
  '096-9688368',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเจนจิรา' AND m.lastName = 'สีสะอาด'
  )
LIMIT 1;
-- แถว 63: นายธีร์ โพธิ์เกตุ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteswf9a5mamqs',
  'M00063',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธีร์',
  'โพธิ์เกตุ',
  '062-3093830',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธีร์' AND m.lastName = 'โพธิ์เกตุ'
  )
LIMIT 1;
-- แถว 64: นายพิชญพันธ์ จันทรา | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteq6w5pi72jfp',
  'M00064',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิชญพันธ์',
  'จันทรา',
  '089-8523837',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิชญพันธ์' AND m.lastName = 'จันทรา'
  )
LIMIT 1;
-- แถว 65: นางสาวอัชชนา ศรีแก้ว | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteozyfg2m288',
  'M00065',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัชชนา',
  'ศรีแก้ว',
  '094-3988448',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัชชนา' AND m.lastName = 'ศรีแก้ว'
  )
LIMIT 1;
-- แถว 66: นายกันต์พล เชื้อเมืองพาน | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntej80c15myddg',
  'M00066',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกันต์พล',
  'เชื้อเมืองพาน',
  '082-4815753',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกันต์พล' AND m.lastName = 'เชื้อเมืองพาน'
  )
LIMIT 1;
-- แถว 67: นางสาวสุธาสินี คำเผ่า | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntexxx9oe5h3on',
  'M00067',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุธาสินี',
  'คำเผ่า',
  '085-5240673',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุธาสินี' AND m.lastName = 'คำเผ่า'
  )
LIMIT 1;
-- แถว 68: นางสาวณัฐชา วงค์แสง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntevz2h2jmarq',
  'M00068',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐชา',
  'วงค์แสง',
  '944422886',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐชา' AND m.lastName = 'วงค์แสง'
  )
LIMIT 1;
-- แถว 69: นางสาวลักขนา แซ่เติ๋น | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte35g78ilokma',
  'M00069',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวลักขนา',
  'แซ่เติ๋น',
  '093-2621893',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวลักขนา' AND m.lastName = 'แซ่เติ๋น'
  )
LIMIT 1;
-- แถว 70: นายอนุภัทร แซ่ฟุ้ง | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nternrhrw4hrnf',
  'M00070',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอนุภัทร',
  'แซ่ฟุ้ง',
  '083-0653216',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอนุภัทร' AND m.lastName = 'แซ่ฟุ้ง'
  )
LIMIT 1;
-- แถว 71: นางสาวพนิดา ขจรเจริญเดช | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteacpkq0nso2s',
  'M00071',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพนิดา',
  'ขจรเจริญเดช',
  '097-3216847',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพนิดา' AND m.lastName = 'ขจรเจริญเดช'
  )
LIMIT 1;
-- แถว 72: นางสาวพิมพร พัฒนพงษ์ธรรม | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteef639nw88f',
  'M00072',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพร',
  'พัฒนพงษ์ธรรม',
  '093-0421241',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพร' AND m.lastName = 'พัฒนพงษ์ธรรม'
  )
LIMIT 1;
-- แถว 73: นางสาวนภัสสร เมอโปดู่ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte0h6or7cb8ut',
  'M00073',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนภัสสร',
  'เมอโปดู่',
  '063-1521161',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนภัสสร' AND m.lastName = 'เมอโปดู่'
  )
LIMIT 1;
-- แถว 74: นางชมกนก รัตนจำรูญสกุล | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntew0yj0ndfh4k',
  'M00074',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางชมกนก',
  'รัตนจำรูญสกุล',
  '084-4956966',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางชมกนก' AND m.lastName = 'รัตนจำรูญสกุล'
  )
LIMIT 1;
-- แถว 75: นางสาวจิตรา ปาสาบุตร | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntegn0uxef8t56',
  'M00075',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิตรา',
  'ปาสาบุตร',
  '093-1560821',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิตรา' AND m.lastName = 'ปาสาบุตร'
  )
LIMIT 1;
-- แถว 76: นายพงศกร ใจโปธา(น้าสาม) | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntekrxxozdlvx',
  'M00076',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพงศกร',
  'ใจโปธา(น้าสาม)',
  '095-4681146',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพงศกร' AND m.lastName = 'ใจโปธา(น้าสาม)'
  )
LIMIT 1;
-- แถว 77: นางสาวบัวฟอง ไทยใหญ่ | โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntefexh9hiv51',
  'M00077',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวบัวฟอง',
  'ไทยใหญ่',
  '080-3975581',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_004__ตชด.บ้านนาโต่_วปอ.3' OR s.name = 'โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียน ตชด.บ้านนาโต่ (วปอ.344อุปถ์) กลุ่มเครือข่%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวบัวฟอง' AND m.lastName = 'ไทยใหญ่'
  )
LIMIT 1;
-- แถว 78: นายณัฐพล ศรีวิชัย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntebf43o94o597',
  'M00078',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐพล',
  'ศรีวิชัย',
  '0876841608',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐพล' AND m.lastName = 'ศรีวิชัย'
  )
LIMIT 1;
-- แถว 79: นางสาวเกศริน ธิยศ | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteif4xh3c1no',
  'M00079',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกศริน',
  'ธิยศ',
  '0882905507',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกศริน' AND m.lastName = 'ธิยศ'
  )
LIMIT 1;
-- แถว 80: นายวรายุทธ ไชยช่อฟ้า | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntexi72dnqu42c',
  'M00080',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวรายุทธ',
  'ไชยช่อฟ้า',
  '0828988922',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวรายุทธ' AND m.lastName = 'ไชยช่อฟ้า'
  )
LIMIT 1;
-- แถว 81: นางสาวสรัลชนา นันตา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntetiw0sxjouv',
  'M00081',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสรัลชนา',
  'นันตา',
  '0803796157',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสรัลชนา' AND m.lastName = 'นันตา'
  )
LIMIT 1;
-- แถว 82: นางสาวพรธิตา สีใจมา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte6ly40zypoh3',
  'M00082',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพรธิตา',
  'สีใจมา',
  '0820586956',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพรธิตา' AND m.lastName = 'สีใจมา'
  )
LIMIT 1;
-- แถว 83: นางสาวนฤมล อภิวงษา | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntex3chn4s0p8q',
  'M00083',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนฤมล',
  'อภิวงษา',
  '0842142591',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนฤมล' AND m.lastName = 'อภิวงษา'
  )
LIMIT 1;
-- แถว 84: นางสาวธัญญารักษ์ ไชยวงค์คำ | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte4yndimgots9',
  'M00084',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญญารักษ์',
  'ไชยวงค์คำ',
  '0971964847',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญญารักษ์' AND m.lastName = 'ไชยวงค์คำ'
  )
LIMIT 1;
-- แถว 85: นางสาวสุชาดา ก้อนทองไทย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntehks6p4rns25',
  'M00085',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชาดา',
  'ก้อนทองไทย',
  '0612138935',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชาดา' AND m.lastName = 'ก้อนทองไทย'
  )
LIMIT 1;
-- แถว 86: นายสมพร ประเสริฐไทย | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8e7htohbev',
  'M00086',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมพร',
  'ประเสริฐไทย',
  '0800734104',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมพร' AND m.lastName = 'ประเสริฐไทย'
  )
LIMIT 1;
-- แถว 87: นางสาวณัณภัส กันแก้ว | โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntefx5l1ffhxw',
  'M00087',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัณภัส',
  'กันแก้ว',
  '0624414689',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_005_บ้านห้วยหก_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหก กลุ่มเครือข่ายพัฒนาการศึกษาแม่ส%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัณภัส' AND m.lastName = 'กันแก้ว'
  )
LIMIT 1;
-- แถว 88: นางสาวธัญนันท์ สุขเกษม | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte388pl3zg81w',
  'M00088',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญนันท์',
  'สุขเกษม',
  '087-1601066',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญนันท์' AND m.lastName = 'สุขเกษม'
  )
LIMIT 1;
-- แถว 89: นางสาววรัญญา จันทร์พรมมา | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteiklg301bi2q',
  'M00089',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรัญญา',
  'จันทร์พรมมา',
  '088-2367147',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรัญญา' AND m.lastName = 'จันทร์พรมมา'
  )
LIMIT 1;
-- แถว 90: นางสาวนภาพร ปินทรายมูล | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteci4wc1j3nl',
  'M00090',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนภาพร',
  'ปินทรายมูล',
  '066-1426465',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนภาพร' AND m.lastName = 'ปินทรายมูล'
  )
LIMIT 1;
-- แถว 91: นางสาวจันทนี คำดี | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntelma1ab0qec',
  'M00091',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจันทนี',
  'คำดี',
  '086-6715489',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจันทนี' AND m.lastName = 'คำดี'
  )
LIMIT 1;
-- แถว 92: นางสาวภณิดา วังแก้ว | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte9oe9rjr6r0m',
  'M00092',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภณิดา',
  'วังแก้ว',
  '080-4612740',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภณิดา' AND m.lastName = 'วังแก้ว'
  )
LIMIT 1;
-- แถว 93: นายนนท์ ศรีวิชัย | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte8y29jndzfsm',
  'M00093',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนนท์',
  'ศรีวิชัย',
  '062-9459496',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนนท์' AND m.lastName = 'ศรีวิชัย'
  )
LIMIT 1;
-- แถว 94: นางชวัลลักษณ์ อินเรือง | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntekgtutst3i5',
  'M00094',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางชวัลลักษณ์',
  'อินเรือง',
  '061-0583883',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางชวัลลักษณ์' AND m.lastName = 'อินเรือง'
  )
LIMIT 1;
-- แถว 95: นางสาวสุชาดา ยานะ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntedbipwz649g',
  'M00095',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชาดา',
  'ยานะ',
  '097-4652963',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชาดา' AND m.lastName = 'ยานะ'
  )
LIMIT 1;
-- แถว 96: นางสาวนริศรา วงค์สุรินทร์ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteeo8290yd1cq',
  'M00096',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนริศรา',
  'วงค์สุรินทร์',
  '090-3240057',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนริศรา' AND m.lastName = 'วงค์สุรินทร์'
  )
LIMIT 1;
-- แถว 97: นายสุรพันธ์ วัฒนปัญญานนท์ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntebbbe9l6l9y',
  'M00097',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรพันธ์',
  'วัฒนปัญญานนท์',
  '087-0307021',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรพันธ์' AND m.lastName = 'วัฒนปัญญานนท์'
  )
LIMIT 1;
-- แถว 98: นายสุรชาติ อาหยิ | โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntekm2hhgszku8',
  'M00098',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรชาติ',
  'อาหยิ',
  '097-9538389',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_006_บ้านห้วยหยวกป่าโซ_กล' OR s.name = 'โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยหยวกป่าโซ กลุ่มเครือข่ายแม่สลองกาข%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรชาติ' AND m.lastName = 'อาหยิ'
  )
LIMIT 1;
-- แถว 99: นายภานุวัฒน์ นะที | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte738v2kkj5jo',
  'M00099',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภานุวัฒน์',
  'นะที',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภานุวัฒน์' AND m.lastName = 'นะที'
  )
LIMIT 1;
-- แถว 100: จ.ส.อ.นัทธพงศ์ คําแผ่นชัย | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntegkiybqt2pn',
  'M00100',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'จ.ส.อ.นัทธพงศ์',
  'คําแผ่นชัย',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'จ.ส.อ.นัทธพงศ์' AND m.lastName = 'คําแผ่นชัย'
  )
LIMIT 1;
-- แถว 101: นายวีระศักดิ์ อุดทา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntewtl23cctb2n',
  'M00101',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวีระศักดิ์',
  'อุดทา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวีระศักดิ์' AND m.lastName = 'อุดทา'
  )
LIMIT 1;
-- แถว 102: นาวสาวมานิดา เสาวรส | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntelwhuz0zv5jd',
  'M00102',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นาวสาวมานิดา',
  'เสาวรส',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นาวสาวมานิดา' AND m.lastName = 'เสาวรส'
  )
LIMIT 1;
-- แถว 103: นายฤทธิชัย ใหญ่พงค์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte7o9goa8dyxi',
  'M00103',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฤทธิชัย',
  'ใหญ่พงค์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฤทธิชัย' AND m.lastName = 'ใหญ่พงค์'
  )
LIMIT 1;
-- แถว 104: นายอัครา ปินตารักษ์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteem41sidxu2e',
  'M00104',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอัครา',
  'ปินตารักษ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอัครา' AND m.lastName = 'ปินตารักษ์'
  )
LIMIT 1;
-- แถว 105: นางสาวยุพาพร ถมหนวด | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte02j8kgys0m33',
  'M00105',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวยุพาพร',
  'ถมหนวด',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวยุพาพร' AND m.lastName = 'ถมหนวด'
  )
LIMIT 1;
-- แถว 106: นายพิรุฬห์วัฒน์ วัดคํา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntewtk1fbxrmia',
  'M00106',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิรุฬห์วัฒน์',
  'วัดคํา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิรุฬห์วัฒน์' AND m.lastName = 'วัดคํา'
  )
LIMIT 1;
-- แถว 107: นางสาวแสงเทียน คําน้อย | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntemg5mzxa3s7',
  'M00107',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวแสงเทียน',
  'คําน้อย',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวแสงเทียน' AND m.lastName = 'คําน้อย'
  )
LIMIT 1;
-- แถว 108: นางสาววารี ศรีวรนันท์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte6ciuwtfijfy',
  'M00108',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววารี',
  'ศรีวรนันท์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววารี' AND m.lastName = 'ศรีวรนันท์'
  )
LIMIT 1;
-- แถว 109: นายไกรสร แซ่ฟุ้ง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteeztouge3jq7',
  'M00109',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไกรสร',
  'แซ่ฟุ้ง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไกรสร' AND m.lastName = 'แซ่ฟุ้ง'
  )
LIMIT 1;
-- แถว 110: นางพัชรินทร์ คีรีแสนใจ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte5cgfsmzjymc',
  'M00110',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางพัชรินทร์',
  'คีรีแสนใจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางพัชรินทร์' AND m.lastName = 'คีรีแสนใจ'
  )
LIMIT 1;
-- แถว 111: นางสาวปวีณา จํามิ่ง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntek0mxbsmoepi',
  'M00111',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปวีณา',
  'จํามิ่ง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปวีณา' AND m.lastName = 'จํามิ่ง'
  )
LIMIT 1;
-- แถว 112: นายจิรภัทร ตันมา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntec7n2u1s1eis',
  'M00112',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิรภัทร',
  'ตันมา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิรภัทร' AND m.lastName = 'ตันมา'
  )
LIMIT 1;
-- แถว 113: นางสาวเกวลี พินิจ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte3hr1kbfomg2',
  'M00113',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกวลี',
  'พินิจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกวลี' AND m.lastName = 'พินิจ'
  )
LIMIT 1;
-- แถว 114: นางสาวปณิตา แสนปัญญา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntei8xt11c0hnh',
  'M00114',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปณิตา',
  'แสนปัญญา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปณิตา' AND m.lastName = 'แสนปัญญา'
  )
LIMIT 1;
-- แถว 115: นางสาววราพร ก๋าแปง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntevbbdvwkqsvb',
  'M00115',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววราพร',
  'ก๋าแปง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววราพร' AND m.lastName = 'ก๋าแปง'
  )
LIMIT 1;
-- แถว 116: นางสาวสุนิสา สุกุล | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteh3k0em45cya',
  'M00116',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุนิสา',
  'สุกุล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุนิสา' AND m.lastName = 'สุกุล'
  )
LIMIT 1;
-- แถว 117: นางสาวจิราพร  ปัญญาฟู | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntem2byjlyhgxm',
  'M00117',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิราพร',
  'ปัญญาฟู',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิราพร' AND m.lastName = 'ปัญญาฟู'
  )
LIMIT 1;
-- แถว 118: นางสาณัฐกาญ จันทะวงค์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteidzvqnkj72',
  'M00118',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาณัฐกาญ',
  'จันทะวงค์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาณัฐกาญ' AND m.lastName = 'จันทะวงค์'
  )
LIMIT 1;
-- แถว 119: นางสาวอัมรา นันท์โภคินวงษ์ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntep7ina377cp',
  'M00119',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัมรา',
  'นันท์โภคินวงษ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัมรา' AND m.lastName = 'นันท์โภคินวงษ์'
  )
LIMIT 1;
-- แถว 120: นางสาวอารีรัตน์ มณีจันทร์สุข | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteiig8b4vi5e',
  'M00120',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอารีรัตน์',
  'มณีจันทร์สุข',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอารีรัตน์' AND m.lastName = 'มณีจันทร์สุข'
  )
LIMIT 1;
-- แถว 121: นายวรเชษฐ ทิพย์ดวง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntemc4kr1zpzc',
  'M00121',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวรเชษฐ',
  'ทิพย์ดวง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวรเชษฐ' AND m.lastName = 'ทิพย์ดวง'
  )
LIMIT 1;
-- แถว 122: นางสาวมลธิรา  ใจปิง | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntedbgdvwh7h4u',
  'M00122',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมลธิรา',
  'ใจปิง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมลธิรา' AND m.lastName = 'ใจปิง'
  )
LIMIT 1;
-- แถว 123: นางสาววิไลรัตน์ มาเยอะ | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteotg1gn70r1p',
  'M00123',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิไลรัตน์',
  'มาเยอะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิไลรัตน์' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 124: นางภัทรวดี ชํานาญยา | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteth6uf5wpqt',
  'M00124',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางภัทรวดี',
  'ชํานาญยา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางภัทรวดี' AND m.lastName = 'ชํานาญยา'
  )
LIMIT 1;
-- แถว 125: นางสาวเอณิกา วงค์เมืองแล | โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntewmxk50u2fe',
  'M00125',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเอณิกา',
  'วงค์เมืองแล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_007_ดอยแสนใจ_ตชด.อนุสรณ์' OR s.name = 'โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนดอยแสนใจ (ตชด.อนุสรณ์) กลุ่มเครือข่ายพัฒนา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเอณิกา' AND m.lastName = 'วงค์เมืองแล'
  )
LIMIT 1;
-- แถว 126: นายธีรพล ทาใหม่ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte3u7hulnqycn',
  'M00126',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธีรพล',
  'ทาใหม่',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธีรพล' AND m.lastName = 'ทาใหม่'
  )
LIMIT 1;
-- แถว 127: นางรัตนา วะไลใจ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte54wlg7fnqls',
  'M00127',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางรัตนา',
  'วะไลใจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางรัตนา' AND m.lastName = 'วะไลใจ'
  )
LIMIT 1;
-- แถว 128: นางสาวบานเย็น ศรีคำ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteswiry652zr',
  'M00128',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวบานเย็น',
  'ศรีคำ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวบานเย็น' AND m.lastName = 'ศรีคำ'
  )
LIMIT 1;
-- แถว 129: นางสาวณปภัช ทองหลอม | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteytdlis4stwr',
  'M00129',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณปภัช',
  'ทองหลอม',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณปภัช' AND m.lastName = 'ทองหลอม'
  )
LIMIT 1;
-- แถว 130: นายฤทธินนท์ จันดีวันนา | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteg5ci1148mrc',
  'M00130',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฤทธินนท์',
  'จันดีวันนา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฤทธินนท์' AND m.lastName = 'จันดีวันนา'
  )
LIMIT 1;
-- แถว 131: นายธนาธิป อุทธิยา | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntex8iv9wxdaed',
  'M00131',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนาธิป',
  'อุทธิยา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนาธิป' AND m.lastName = 'อุทธิยา'
  )
LIMIT 1;
-- แถว 132: นายคมภูศิษฐ์ นัฐธนากาญจน์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntevp5ydggcl3m',
  'M00132',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคมภูศิษฐ์',
  'นัฐธนากาญจน์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคมภูศิษฐ์' AND m.lastName = 'นัฐธนากาญจน์'
  )
LIMIT 1;
-- แถว 133: นางสาวธัญสีนี ชูเพชรสมบูรณ์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte6ooifqn3lq3',
  'M00133',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญสีนี',
  'ชูเพชรสมบูรณ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญสีนี' AND m.lastName = 'ชูเพชรสมบูรณ์'
  )
LIMIT 1;
-- แถว 134: นางสาวภัทราพร โนจิตร | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte6d2d0cl0q7v',
  'M00134',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัทราพร',
  'โนจิตร',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัทราพร' AND m.lastName = 'โนจิตร'
  )
LIMIT 1;
-- แถว 135: นางสาวกานต์ชนิต แสงแก้ว | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteqshfrekw4z',
  'M00135',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกานต์ชนิต',
  'แสงแก้ว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกานต์ชนิต' AND m.lastName = 'แสงแก้ว'
  )
LIMIT 1;
-- แถว 136: นางสาวฐิตาพร ชูทอง | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte33aoe1t0kki',
  'M00136',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฐิตาพร',
  'ชูทอง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฐิตาพร' AND m.lastName = 'ชูทอง'
  )
LIMIT 1;
-- แถว 137: นางกรพันธุ์ จินะเทศ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntevmxdglh95np',
  'M00137',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกรพันธุ์',
  'จินะเทศ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกรพันธุ์' AND m.lastName = 'จินะเทศ'
  )
LIMIT 1;
-- แถว 138: นายยุทธติกาล มหายศกุล | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntemsr6sewzw1r',
  'M00138',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยุทธติกาล',
  'มหายศกุล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยุทธติกาล' AND m.lastName = 'มหายศกุล'
  )
LIMIT 1;
-- แถว 139: นางสาวอภิสรา อนันต์พระคุณ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte5nl4veqj9mp',
  'M00139',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอภิสรา',
  'อนันต์พระคุณ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอภิสรา' AND m.lastName = 'อนันต์พระคุณ'
  )
LIMIT 1;
-- แถว 140: นายอริญชย์ วะรีวะราช | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte1t96hnkaoj7',
  'M00140',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอริญชย์',
  'วะรีวะราช',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอริญชย์' AND m.lastName = 'วะรีวะราช'
  )
LIMIT 1;
-- แถว 141: นายธนฤทธิ์ ชัยวรรณ์ | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntetcugm23blxh',
  'M00141',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนฤทธิ์',
  'ชัยวรรณ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนฤทธิ์' AND m.lastName = 'ชัยวรรณ์'
  )
LIMIT 1;
-- แถว 142: นายบุญคง คืนมาเมือง | โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntec4fngg85b2o',
  'M00142',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายบุญคง',
  'คืนมาเมือง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_008_บ้านมนตรีวิทยา_กลุ่ม' OR s.name = 'โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านมนตรีวิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายบุญคง' AND m.lastName = 'คืนมาเมือง'
  )
LIMIT 1;
-- แถว 143: นายวันชัย ชื่นตา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntep6m6gvatnkk',
  'M00143',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวันชัย',
  'ชื่นตา',
  '085-7242631',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวันชัย' AND m.lastName = 'ชื่นตา'
  )
LIMIT 1;
-- แถว 144: นายปิยวัฒน์ ก๋าใจคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntepkhndbhzho',
  'M00144',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายปิยวัฒน์',
  'ก๋าใจคำ',
  '095-4489477',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายปิยวัฒน์' AND m.lastName = 'ก๋าใจคำ'
  )
LIMIT 1;
-- แถว 145: นายพิชัย ก่ำแก้ว | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nte5jobapl48nj',
  'M00145',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิชัย',
  'ก่ำแก้ว',
  '093-1457052',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิชัย' AND m.lastName = 'ก่ำแก้ว'
  )
LIMIT 1;
-- แถว 146: นายสงคราม กิตติกาจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntexzz4zxqcfme',
  'M00146',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสงคราม',
  'กิตติกาจ',
  '089-8531875',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสงคราม' AND m.lastName = 'กิตติกาจ'
  )
LIMIT 1;
-- แถว 147: นายประเชิญ ต๊ะวิชัย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nteefqz9q1v56w',
  'M00147',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายประเชิญ',
  'ต๊ะวิชัย',
  '097-3397205',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายประเชิญ' AND m.lastName = 'ต๊ะวิชัย'
  )
LIMIT 1;
-- แถว 148: นายพิทยุตม์ จุมปา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf96w6fzt5os9',
  'M00148',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิทยุตม์',
  'จุมปา',
  '097-9231010',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิทยุตม์' AND m.lastName = 'จุมปา'
  )
LIMIT 1;
-- แถว 149: นายพิเชษฐ์ แสนสุข | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhq579ifq45',
  'M00149',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิเชษฐ์',
  'แสนสุข',
  '061-6861222',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิเชษฐ์' AND m.lastName = 'แสนสุข'
  )
LIMIT 1;
-- แถว 150: นายทัศนัย ใจกาวิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfen8fxwtrphl',
  'M00150',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายทัศนัย',
  'ใจกาวิน',
  '093-1366939',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายทัศนัย' AND m.lastName = 'ใจกาวิน'
  )
LIMIT 1;
-- แถว 151: นายมาโนช สุวรรณ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfgluid65vs4',
  'M00151',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายมาโนช',
  'สุวรรณ',
  '094-6087718',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายมาโนช' AND m.lastName = 'สุวรรณ'
  )
LIMIT 1;
-- แถว 152: นางสาวดวงพิกุล ชัยวร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9gflw6r4qm',
  'M00152',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวดวงพิกุล',
  'ชัยวร',
  '093-1325068',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวดวงพิกุล' AND m.lastName = 'ชัยวร'
  )
LIMIT 1;
-- แถว 153: นางณัชชา ภูมิเรศสุนทร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqa00wphjpdk',
  'M00153',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางณัชชา',
  'ภูมิเรศสุนทร',
  '089-9525410',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางณัชชา' AND m.lastName = 'ภูมิเรศสุนทร'
  )
LIMIT 1;
-- แถว 154: นางรสรินทร์ กิตติกาจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9yobmvyor4j',
  'M00154',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางรสรินทร์',
  'กิตติกาจ',
  '087-1734667',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางรสรินทร์' AND m.lastName = 'กิตติกาจ'
  )
LIMIT 1;
-- แถว 155: นางกนกพร อานุ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvoa8lx72ae',
  'M00155',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกนกพร',
  'อานุ',
  '081-7467090',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกนกพร' AND m.lastName = 'อานุ'
  )
LIMIT 1;
-- แถว 156: นางสาวนิตยา สักแสน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmsrexno6k9e',
  'M00156',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิตยา',
  'สักแสน',
  '089-7563466',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิตยา' AND m.lastName = 'สักแสน'
  )
LIMIT 1;
-- แถว 157: นางสาวปัทมาภรณ์ ถิ่นการ์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf44qkoshjinn',
  'M00157',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปัทมาภรณ์',
  'ถิ่นการ์',
  '088-2250474',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปัทมาภรณ์' AND m.lastName = 'ถิ่นการ์'
  )
LIMIT 1;
-- แถว 158: นางสาวชยาภรณ์ แซ่เฮ่อ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzrisuwv9bt',
  'M00158',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชยาภรณ์',
  'แซ่เฮ่อ',
  '065-0316925',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชยาภรณ์' AND m.lastName = 'แซ่เฮ่อ'
  )
LIMIT 1;
-- แถว 159: นางสาวรุ่งทิวา ยวงอินแปลง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpr8vnce7rmk',
  'M00159',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรุ่งทิวา',
  'ยวงอินแปลง',
  '082-4809551',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรุ่งทิวา' AND m.lastName = 'ยวงอินแปลง'
  )
LIMIT 1;
-- แถว 160: นางสาวกนกอร จิตอ่อนน้อม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfoapxkzm6una',
  'M00160',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกอร',
  'จิตอ่อนน้อม',
  '086-1856195',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกอร' AND m.lastName = 'จิตอ่อนน้อม'
  )
LIMIT 1;
-- แถว 161: นางสาวเปรมยุดา รากะรินทร์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7kx1rnbsabd',
  'M00161',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเปรมยุดา',
  'รากะรินทร์',
  '091-7133870',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเปรมยุดา' AND m.lastName = 'รากะรินทร์'
  )
LIMIT 1;
-- แถว 162: นางสาวกนกพร ทิศเชย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7i5whnx6xts',
  'M00162',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกพร',
  'ทิศเชย',
  '083-9410364',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกพร' AND m.lastName = 'ทิศเชย'
  )
LIMIT 1;
-- แถว 163: นายกฤษขจร ฟ้าเลิศ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwx99sgd3ehm',
  'M00163',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกฤษขจร',
  'ฟ้าเลิศ',
  '082-4809288',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกฤษขจร' AND m.lastName = 'ฟ้าเลิศ'
  )
LIMIT 1;
-- แถว 164: นายภากร บัวทิม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzyjboq9qpt9',
  'M00164',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภากร',
  'บัวทิม',
  '658318851',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภากร' AND m.lastName = 'บัวทิม'
  )
LIMIT 1;
-- แถว 165: นางสาววันพร เขื่อนคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf6gbvuieiy04',
  'M00165',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววันพร',
  'เขื่อนคำ',
  '090-0542472',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววันพร' AND m.lastName = 'เขื่อนคำ'
  )
LIMIT 1;
-- แถว 166: นางสาวอาภัสรา วังทิพย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfgvbhnxzaat9',
  'M00166',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอาภัสรา',
  'วังทิพย์',
  '082-7646672',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอาภัสรา' AND m.lastName = 'วังทิพย์'
  )
LIMIT 1;
-- แถว 167: นางสาวพิมพ์พร ผัดขัน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf07yy4evt1n2',
  'M00167',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์พร',
  'ผัดขัน',
  '090-1320591',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์พร' AND m.lastName = 'ผัดขัน'
  )
LIMIT 1;
-- แถว 168: นางสาวกนกพิชญ์ กาญจนวาส | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmlh3g3hp3gq',
  'M00168',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกพิชญ์',
  'กาญจนวาส',
  '082-1602038',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกพิชญ์' AND m.lastName = 'กาญจนวาส'
  )
LIMIT 1;
-- แถว 169: นางสาวชวัลรัตน์ สุริยะ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfer04c951n4q',
  'M00169',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชวัลรัตน์',
  'สุริยะ',
  '061-2731683',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชวัลรัตน์' AND m.lastName = 'สุริยะ'
  )
LIMIT 1;
-- แถว 170: นางสาวนิตฐินันท์ สนธิคุณ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfq89yd5npwq',
  'M00170',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิตฐินันท์',
  'สนธิคุณ',
  '080-0412835',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิตฐินันท์' AND m.lastName = 'สนธิคุณ'
  )
LIMIT 1;
-- แถว 171: นางสาวภาณุมาศ พลวิทย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfj688ligxqh',
  'M00171',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภาณุมาศ',
  'พลวิทย์',
  '061-665-6996',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภาณุมาศ' AND m.lastName = 'พลวิทย์'
  )
LIMIT 1;
-- แถว 172: นายธนากร ทองเงา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0cm3occg09l9',
  'M00172',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนากร',
  'ทองเงา',
  '095-7524838',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนากร' AND m.lastName = 'ทองเงา'
  )
LIMIT 1;
-- แถว 173: นายพิสิทธิ์ โกเสนตอ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfe9ax3hp58cq',
  'M00173',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิสิทธิ์',
  'โกเสนตอ',
  '087 5447241',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิสิทธิ์' AND m.lastName = 'โกเสนตอ'
  )
LIMIT 1;
-- แถว 174: นายธวัชชัย จันติ๊บ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf86192kwevxu',
  'M00174',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธวัชชัย',
  'จันติ๊บ',
  '061-3472982',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธวัชชัย' AND m.lastName = 'จันติ๊บ'
  )
LIMIT 1;
-- แถว 175: นางสาวพิมวิไล ตาบุญใจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfq2rz7ta0pul',
  'M00175',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมวิไล',
  'ตาบุญใจ',
  '062-4872741',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมวิไล' AND m.lastName = 'ตาบุญใจ'
  )
LIMIT 1;
-- แถว 176: นางสาวสุทธิดา มุงเมือง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfc3ah1lx5pq7',
  'M00176',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุทธิดา',
  'มุงเมือง',
  '095-3287851',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุทธิดา' AND m.lastName = 'มุงเมือง'
  )
LIMIT 1;
-- แถว 177: นายนัทธวุฒิ โสรินทร์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwsy8fmkrsjg',
  'M00177',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนัทธวุฒิ',
  'โสรินทร์',
  '987538430',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนัทธวุฒิ' AND m.lastName = 'โสรินทร์'
  )
LIMIT 1;
-- แถว 178: นายเอกรินทร์ อิ่นคำ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfr23vz8m1zv9',
  'M00178',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกรินทร์',
  'อิ่นคำ',
  '931480700',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกรินทร์' AND m.lastName = 'อิ่นคำ'
  )
LIMIT 1;
-- แถว 179: นายศุภกฤต ฝั้นใจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfiak4d8zri8',
  'M00179',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศุภกฤต',
  'ฝั้นใจ',
  '814676177',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศุภกฤต' AND m.lastName = 'ฝั้นใจ'
  )
LIMIT 1;
-- แถว 180: นางสาวภาสินี ทองรอบพิทักษ์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf1ou3zjygnxe',
  'M00180',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภาสินี',
  'ทองรอบพิทักษ์',
  '093-1342911',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภาสินี' AND m.lastName = 'ทองรอบพิทักษ์'
  )
LIMIT 1;
-- แถว 181: นายสิงหา สุวรรณโค | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqr90nca4vtg',
  'M00181',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสิงหา',
  'สุวรรณโค',
  '931930759',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสิงหา' AND m.lastName = 'สุวรรณโค'
  )
LIMIT 1;
-- แถว 182: นายวิกาวี ชัยอารีย์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjg2fr3eotr',
  'M00182',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวิกาวี',
  'ชัยอารีย์',
  '636791988',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวิกาวี' AND m.lastName = 'ชัยอารีย์'
  )
LIMIT 1;
-- แถว 183: นายณัฐวุฒิ แดงปัดแหว๋ว | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntff2d2gmgmjw5',
  'M00183',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐวุฒิ',
  'แดงปัดแหว๋ว',
  '613734518',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐวุฒิ' AND m.lastName = 'แดงปัดแหว๋ว'
  )
LIMIT 1;
-- แถว 184: นางสาววรัญญา ทับทิมหิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfw6fkx2i72og',
  'M00184',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรัญญา',
  'ทับทิมหิน',
  '822538772',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรัญญา' AND m.lastName = 'ทับทิมหิน'
  )
LIMIT 1;
-- แถว 185: นางสาวพิชามญชุ์ สายเพียร | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntflgzkx0p6yn',
  'M00185',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิชามญชุ์',
  'สายเพียร',
  '655069062',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิชามญชุ์' AND m.lastName = 'สายเพียร'
  )
LIMIT 1;
-- แถว 186: นายเสกสรรค์ จันแปงเงิน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfulnguft4ued',
  'M00186',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเสกสรรค์',
  'จันแปงเงิน',
  '088-5564326',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเสกสรรค์' AND m.lastName = 'จันแปงเงิน'
  )
LIMIT 1;
-- แถว 187: นางสาวพิทยา พรรดา | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfibuj2kgw4fk',
  'M00187',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิทยา',
  'พรรดา',
  '638239692',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิทยา' AND m.lastName = 'พรรดา'
  )
LIMIT 1;
-- แถว 188: นายพิเชฐ พินิจ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfcptmtbgczw9',
  'M00188',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิเชฐ',
  'พินิจ',
  '091-2715313',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิเชฐ' AND m.lastName = 'พินิจ'
  )
LIMIT 1;
-- แถว 189: นางสาววริชญา ชาวน่าน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfujo7f8eb77o',
  'M00189',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววริชญา',
  'ชาวน่าน',
  '062-5165273',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววริชญา' AND m.lastName = 'ชาวน่าน'
  )
LIMIT 1;
-- แถว 190: นายชยากร อุ่นธง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfloz1sgzgprd',
  'M00190',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชยากร',
  'อุ่นธง',
  '803630998',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชยากร' AND m.lastName = 'อุ่นธง'
  )
LIMIT 1;
-- แถว 191: นางสาวศุภกานต์ ไชยโย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntforeidnmkcq',
  'M00191',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศุภกานต์',
  'ไชยโย',
  '092-2870976',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศุภกานต์' AND m.lastName = 'ไชยโย'
  )
LIMIT 1;
-- แถว 192: นายญาณัคร์พนิต คำผง | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpm92ejjyulo',
  'M00192',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายญาณัคร์พนิต',
  'คำผง',
  '957345731',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายญาณัคร์พนิต' AND m.lastName = 'คำผง'
  )
LIMIT 1;
-- แถว 193: นางสาวพัณณกร วังแจ่ม | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfneirgn9zq2',
  'M00193',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัณณกร',
  'วังแจ่ม',
  '650026013',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัณณกร' AND m.lastName = 'วังแจ่ม'
  )
LIMIT 1;
-- แถว 194: นายสมพร แสนก่อ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfsnrwy39df4',
  'M00194',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมพร',
  'แสนก่อ',
  '092-7954173',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมพร' AND m.lastName = 'แสนก่อ'
  )
LIMIT 1;
-- แถว 195: นายสายไทย สีอมย | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf4kohkt4zqtl',
  'M00195',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสายไทย',
  'สีอมย',
  '089-4318697',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสายไทย' AND m.lastName = 'สีอมย'
  )
LIMIT 1;
-- แถว 196: นางสาวนิตยา หน่อวัน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqgqrbj36go',
  'M00196',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิตยา',
  'หน่อวัน',
  '095-1341572',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิตยา' AND m.lastName = 'หน่อวัน'
  )
LIMIT 1;
-- แถว 197: นายศักดา ธนพชรรัชต์ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffoiprj48kst',
  'M00197',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศักดา',
  'ธนพชรรัชต์',
  '092-6997876',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศักดา' AND m.lastName = 'ธนพชรรัชต์'
  )
LIMIT 1;
-- แถว 198: นายภีรดาดลย์ ไชยพูน | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffmn5ku75sqa',
  'M00198',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภีรดาดลย์',
  'ไชยพูน',
  '093-1349584',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภีรดาดลย์' AND m.lastName = 'ไชยพูน'
  )
LIMIT 1;
-- แถว 199: น.ส.ประไพ เชอมือ | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7bbtyf4j3mk',
  'M00199',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'น.ส.ประไพ',
  'เชอมือ',
  '064-0173381',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'น.ส.ประไพ' AND m.lastName = 'เชอมือ'
  )
LIMIT 1;
-- แถว 200: นายนามติ๊บ ธรรมใส | โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfps3l7pvxj9',
  'M00200',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนามติ๊บ',
  'ธรรมใส',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_009_บ้านห้วยผึ้ง_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนบ้านห้วยผึ้ง กลุ่มเครือข่ายพัฒนาการศึกษาแม%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนามติ๊บ' AND m.lastName = 'ธรรมใส'
  )
LIMIT 1;
-- แถว 201: นางสาวมัญชุสา เพ็ชรชนะ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9pnknl9bzoi',
  'M00201',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมัญชุสา',
  'เพ็ชรชนะ',
  '093-1375973',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมัญชุสา' AND m.lastName = 'เพ็ชรชนะ'
  )
LIMIT 1;
-- แถว 202: นางสาววรรณภัทร วรวัฒน์รัชกุล | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf833ko0smkqq',
  'M00202',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรณภัทร',
  'วรวัฒน์รัชกุล',
  '084-6327587',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรณภัทร' AND m.lastName = 'วรวัฒน์รัชกุล'
  )
LIMIT 1;
-- แถว 203: นายรุ่งโรจน์ ร้องสาคร | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf6wn7400u5dj',
  'M00203',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายรุ่งโรจน์',
  'ร้องสาคร',
  '080-8503403',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายรุ่งโรจน์' AND m.lastName = 'ร้องสาคร'
  )
LIMIT 1;
-- แถว 204: นายสมเกียรติ กิติคำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfphbctb8d4ea',
  'M00204',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมเกียรติ',
  'กิติคำ',
  '098-7791219',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมเกียรติ' AND m.lastName = 'กิติคำ'
  )
LIMIT 1;
-- แถว 205: นางสาววิรัญชนา พระคุณวรกาญจน์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8zydvq0j0u',
  'M00205',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิรัญชนา',
  'พระคุณวรกาญจน์',
  '089-5583213',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิรัญชนา' AND m.lastName = 'พระคุณวรกาญจน์'
  )
LIMIT 1;
-- แถว 206: นางสาวอมรรัตน์ ปนคำปิน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfccjdkem6fcv',
  'M00206',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอมรรัตน์',
  'ปนคำปิน',
  '082-6652962',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอมรรัตน์' AND m.lastName = 'ปนคำปิน'
  )
LIMIT 1;
-- แถว 207: นายธนาวุธ นามวงค์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfsuwrbzqzlr',
  'M00207',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนาวุธ',
  'นามวงค์',
  '081-3772842',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนาวุธ' AND m.lastName = 'นามวงค์'
  )
LIMIT 1;
-- แถว 208: นายไกรระวี จันต๊ะคาด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfygeimbpswm',
  'M00208',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไกรระวี',
  'จันต๊ะคาด',
  '091-0712316',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไกรระวี' AND m.lastName = 'จันต๊ะคาด'
  )
LIMIT 1;
-- แถว 209: นางสาวธณัชชา ใจอารีย์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfth5ximb52jg',
  'M00209',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธณัชชา',
  'ใจอารีย์',
  '086-4291972',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธณัชชา' AND m.lastName = 'ใจอารีย์'
  )
LIMIT 1;
-- แถว 210: นางสาววรัชยาสิริ บัวผัด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhvx13qyflu5',
  'M00210',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรัชยาสิริ',
  'บัวผัด',
  '092-8328981',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรัชยาสิริ' AND m.lastName = 'บัวผัด'
  )
LIMIT 1;
-- แถว 211: นางสาวสิรินันท์ แก้วยองผาง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf66op0doej1',
  'M00211',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิรินันท์',
  'แก้วยองผาง',
  '095-6786501',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิรินันท์' AND m.lastName = 'แก้วยองผาง'
  )
LIMIT 1;
-- แถว 212: นางสาวจริยา เอกจันทร์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfs9r9lw6ny4o',
  'M00212',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจริยา',
  'เอกจันทร์',
  '097-9309385',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจริยา' AND m.lastName = 'เอกจันทร์'
  )
LIMIT 1;
-- แถว 213: นางสาวฐิติรัตน์ ใจอ้าย | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf6v35qmbg1kd',
  'M00213',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฐิติรัตน์',
  'ใจอ้าย',
  '094-9408349',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฐิติรัตน์' AND m.lastName = 'ใจอ้าย'
  )
LIMIT 1;
-- แถว 214: นายสุวิจักขณ์ บุญวงศ์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfj9356z78wqq',
  'M00214',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุวิจักขณ์',
  'บุญวงศ์',
  '097-9787832',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุวิจักขณ์' AND m.lastName = 'บุญวงศ์'
  )
LIMIT 1;
-- แถว 215: นายภานุพงศ์ แจขจัด | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfq312lvdvwqc',
  'M00215',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภานุพงศ์',
  'แจขจัด',
  '061-745-4678',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภานุพงศ์' AND m.lastName = 'แจขจัด'
  )
LIMIT 1;
-- แถว 216: นางอักษรา ตาลำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfw6ny0qdez8',
  'M00216',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางอักษรา',
  'ตาลำ',
  '086-1885482',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางอักษรา' AND m.lastName = 'ตาลำ'
  )
LIMIT 1;
-- แถว 217: นางสาวธัญญารัตน์ ยาวิละ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfp4g78w6js',
  'M00217',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญญารัตน์',
  'ยาวิละ',
  '096-7369826',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญญารัตน์' AND m.lastName = 'ยาวิละ'
  )
LIMIT 1;
-- แถว 218: นายนิธิศ จะตุแสน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7awckd5bzeu',
  'M00218',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนิธิศ',
  'จะตุแสน',
  '061-3765364',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนิธิศ' AND m.lastName = 'จะตุแสน'
  )
LIMIT 1;
-- แถว 219: นางสาวปัทมา สุวรรณ์ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7kscokgjfzt',
  'M00219',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปัทมา',
  'สุวรรณ์',
  '080-4426048',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปัทมา' AND m.lastName = 'สุวรรณ์'
  )
LIMIT 1;
-- แถว 220: นางสาวการต์พิชชา ขันโท | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhuhp1j6svr8',
  'M00220',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวการต์พิชชา',
  'ขันโท',
  '093-2652647',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวการต์พิชชา' AND m.lastName = 'ขันโท'
  )
LIMIT 1;
-- แถว 221: นางสาวนิรมล ศรีทอง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfgm4tk21adf',
  'M00221',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิรมล',
  'ศรีทอง',
  '090-3232994',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิรมล' AND m.lastName = 'ศรีทอง'
  )
LIMIT 1;
-- แถว 222: นางสาวนภัสสร อรุณฟอง | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfc30xrgg248m',
  'M00222',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนภัสสร',
  'อรุณฟอง',
  '096-9047069',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนภัสสร' AND m.lastName = 'อรุณฟอง'
  )
LIMIT 1;
-- แถว 223: นางสาวเจนจิรา จันทาพูน | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf5k2c1ksxjgy',
  'M00223',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเจนจิรา',
  'จันทาพูน',
  '082-0950255',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเจนจิรา' AND m.lastName = 'จันทาพูน'
  )
LIMIT 1;
-- แถว 224: นางสาวทิพวรรณ์ จันทร์เพ็ญ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf02i85htk57bw',
  'M00224',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวทิพวรรณ์',
  'จันทร์เพ็ญ',
  '062-5303267',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวทิพวรรณ์' AND m.lastName = 'จันทร์เพ็ญ'
  )
LIMIT 1;
-- แถว 225: นางสาวเมธยา ทะคำ | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfh7fviztirlr',
  'M00225',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเมธยา',
  'ทะคำ',
  '095-6751661',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเมธยา' AND m.lastName = 'ทะคำ'
  )
LIMIT 1;
-- แถว 226: นางสาวพิยดา ไชยลังกา | โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwchdbg7poy',
  'M00226',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิยดา',
  'ไชยลังกา',
  '096-2109750',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_010_รัฐราษฎร์วิทยา_กลุ่ม' OR s.name = 'โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษาแม่สลองกาขาว' OR s.name LIKE '%โรงเรียนรัฐราษฎร์วิทยา กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิยดา' AND m.lastName = 'ไชยลังกา'
  )
LIMIT 1;
-- แถว 227: นางสาวศศิกานต์ เตจ๊ะวันดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf42mjr44k0rm',
  'M00227',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศศิกานต์',
  'เตจ๊ะวันดี',
  '088-2667412',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศศิกานต์' AND m.lastName = 'เตจ๊ะวันดี'
  )
LIMIT 1;
-- แถว 228: นายเสน่ห์ สุธรรม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvl38c4tit5',
  'M00228',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเสน่ห์',
  'สุธรรม',
  '091-8593405',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเสน่ห์' AND m.lastName = 'สุธรรม'
  )
LIMIT 1;
-- แถว 229: นางสาวจิราภรณ์ มงคลดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8uxpy8a4isr',
  'M00229',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิราภรณ์',
  'มงคลดี',
  '083-5700850',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิราภรณ์' AND m.lastName = 'มงคลดี'
  )
LIMIT 1;
-- แถว 230: นายสุรศักดิ์ นารี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfim40e3895ge',
  'M00230',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรศักดิ์',
  'นารี',
  '064-4746342',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรศักดิ์' AND m.lastName = 'นารี'
  )
LIMIT 1;
-- แถว 231: นางสาวปทมา ชัยโรจน์วงศ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfdscbhiu2jfm',
  'M00231',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปทมา',
  'ชัยโรจน์วงศ์',
  '098-7592028',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปทมา' AND m.lastName = 'ชัยโรจน์วงศ์'
  )
LIMIT 1;
-- แถว 232: นางสาวนฤมล โนฤทธิ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfd1u84g9yvn',
  'M00232',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนฤมล',
  'โนฤทธิ',
  '065-4966704',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนฤมล' AND m.lastName = 'โนฤทธิ'
  )
LIMIT 1;
-- แถว 233: นางสาวสิริรัตน์ พันธ์วิไล | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf90bydublmm',
  'M00233',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิริรัตน์',
  'พันธ์วิไล',
  '082-0967132',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิริรัตน์' AND m.lastName = 'พันธ์วิไล'
  )
LIMIT 1;
-- แถว 234: นางสาววดี ดีปัญญา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqhprzz8ctr',
  'M00234',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววดี',
  'ดีปัญญา',
  '064-2538600',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววดี' AND m.lastName = 'ดีปัญญา'
  )
LIMIT 1;
-- แถว 235: นางสาวสุจิตรา กว้าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf571crmhxa08',
  'M00235',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุจิตรา',
  'กว้าง',
  '097-0841022',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุจิตรา' AND m.lastName = 'กว้าง'
  )
LIMIT 1;
-- แถว 236: นางสาวอัญชลี สุธีราช | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7ps86io61ml',
  'M00236',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัญชลี',
  'สุธีราช',
  '082-5411047',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัญชลี' AND m.lastName = 'สุธีราช'
  )
LIMIT 1;
-- แถว 237: นายอภิรักษ์ สุวรรณ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjsxf8cl1joh',
  'M00237',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอภิรักษ์',
  'สุวรรณ',
  '098-7582878',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอภิรักษ์' AND m.lastName = 'สุวรรณ'
  )
LIMIT 1;
-- แถว 238: นายพิทักษ์ วงศ์บุญมา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfo8508x8y1m',
  'M00238',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิทักษ์',
  'วงศ์บุญมา',
  '091-8581370',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิทักษ์' AND m.lastName = 'วงศ์บุญมา'
  )
LIMIT 1;
-- แถว 239: นางสาวณัฏฐินดา สีปโภคา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfp3ulp3x5dmk',
  'M00239',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฏฐินดา',
  'สีปโภคา',
  '083-0508745',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฏฐินดา' AND m.lastName = 'สีปโภคา'
  )
LIMIT 1;
-- แถว 240: นางสาวกรกฏ อินทร์การทุม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf1v4i4tld0ga',
  'M00240',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกรกฏ',
  'อินทร์การทุม',
  '083-4418019',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกรกฏ' AND m.lastName = 'อินทร์การทุม'
  )
LIMIT 1;
-- แถว 241: นายปรีชา เชยบุญเรือง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfecf8u9yrwlf',
  'M00241',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายปรีชา',
  'เชยบุญเรือง',
  '089-2662066',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายปรีชา' AND m.lastName = 'เชยบุญเรือง'
  )
LIMIT 1;
-- แถว 242: นางสาวพัชรา ทะยืน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhkpbuxpqwmr',
  'M00242',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัชรา',
  'ทะยืน',
  '097-9264119',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัชรา' AND m.lastName = 'ทะยืน'
  )
LIMIT 1;
-- แถว 243: นายชัชชุพงศ์ กรรณิกา | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfu862rlkgw8',
  'M00243',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชัชชุพงศ์',
  'กรรณิกา',
  '096-2847278',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชัชชุพงศ์' AND m.lastName = 'กรรณิกา'
  )
LIMIT 1;
-- แถว 244: นางสาวกรกนก สัญเพ็ชร | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf45p3k5urep7',
  'M00244',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกรกนก',
  'สัญเพ็ชร',
  '088-2317990',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกรกนก' AND m.lastName = 'สัญเพ็ชร'
  )
LIMIT 1;
-- แถว 245: นางสาวรุ่งนภา รินแก้ว | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfxm09xijpmes',
  'M00245',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรุ่งนภา',
  'รินแก้ว',
  '094-9316397',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรุ่งนภา' AND m.lastName = 'รินแก้ว'
  )
LIMIT 1;
-- แถว 246: นางสาววรรณพร รักห้วม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfs4y1wb6fs4',
  'M00246',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรณพร',
  'รักห้วม',
  '098-8907202',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรณพร' AND m.lastName = 'รักห้วม'
  )
LIMIT 1;
-- แถว 247: นางสาววาสินี สุวรรณกาน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf4cry7jtbzm4',
  'M00247',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววาสินี',
  'สุวรรณกาน',
  '082-5701616',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววาสินี' AND m.lastName = 'สุวรรณกาน'
  )
LIMIT 1;
-- แถว 248: นางสาวชมนุษย์ สวัสดิ์กิจ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf4frpaoxavaw',
  'M00248',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชมนุษย์',
  'สวัสดิ์กิจ',
  '065-2561519',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชมนุษย์' AND m.lastName = 'สวัสดิ์กิจ'
  )
LIMIT 1;
-- แถว 249: นางสาวอภิญญา เกิดสกล | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf6j7rnp8aan8',
  'M00249',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอภิญญา',
  'เกิดสกล',
  '096-1699616',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอภิญญา' AND m.lastName = 'เกิดสกล'
  )
LIMIT 1;
-- แถว 250: นายสมเกตุ แสงจันทร์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfrxb9hk19u3h',
  'M00250',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมเกตุ',
  'แสงจันทร์',
  '094-6383385',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมเกตุ' AND m.lastName = 'แสงจันทร์'
  )
LIMIT 1;
-- แถว 251: นางสาวไอรดา ศรีสวัสดิ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf04ljaw7zmfde',
  'M00251',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวไอรดา',
  'ศรีสวัสดิ์',
  '082-6285268',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวไอรดา' AND m.lastName = 'ศรีสวัสดิ์'
  )
LIMIT 1;
-- แถว 252: นางสาวภัทรศิริ หอมดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfh43yqh8w2op',
  'M00252',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัทรศิริ',
  'หอมดี',
  '096-6437882',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัทรศิริ' AND m.lastName = 'หอมดี'
  )
LIMIT 1;
-- แถว 253: นางสาววิญญา อินต๊ะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjz31we93knc',
  'M00253',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิญญา',
  'อินต๊ะ',
  '086-1817961',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิญญา' AND m.lastName = 'อินต๊ะ'
  )
LIMIT 1;
-- แถว 254: นายศราวุธ ยิ้มงาม | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfyql3tg7638p',
  'M00254',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศราวุธ',
  'ยิ้มงาม',
  '063-5955841',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศราวุธ' AND m.lastName = 'ยิ้มงาม'
  )
LIMIT 1;
-- แถว 255: นายเกริกพล ชัตตะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntff8yqgcs5fk4',
  'M00255',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเกริกพล',
  'ชัตตะ',
  '091-4837306',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเกริกพล' AND m.lastName = 'ชัตตะ'
  )
LIMIT 1;
-- แถว 256: นายสรชัย แซ่ห้าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8bktfdtgb89',
  'M00256',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสรชัย',
  'แซ่ห้าง',
  '086-1849819',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสรชัย' AND m.lastName = 'แซ่ห้าง'
  )
LIMIT 1;
-- แถว 257: นางสาวณัสสร แซ่ย่าง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf48hsrge9k32',
  'M00257',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัสสร',
  'แซ่ย่าง',
  '080-8541343',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัสสร' AND m.lastName = 'แซ่ย่าง'
  )
LIMIT 1;
-- แถว 258: นางสาวนิกาพร มีชัย | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffz5hkzcmn3a',
  'M00258',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิกาพร',
  'มีชัย',
  '090-3268944',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิกาพร' AND m.lastName = 'มีชัย'
  )
LIMIT 1;
-- แถว 259: นางสาวกรกัญญา ชมภูเกตุ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfju35z9lho9d',
  'M00259',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกรกัญญา',
  'ชมภูเกตุ',
  '090-3161901',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกรกัญญา' AND m.lastName = 'ชมภูเกตุ'
  )
LIMIT 1;
-- แถว 260: นางสาวปริชาติ งานดี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqlk2jga87vf',
  'M00260',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปริชาติ',
  'งานดี',
  '090-3192619',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปริชาติ' AND m.lastName = 'งานดี'
  )
LIMIT 1;
-- แถว 261: นายทศพล สุคำ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7s6l5nsgd2m',
  'M00261',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายทศพล',
  'สุคำ',
  '087-5661321',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายทศพล' AND m.lastName = 'สุคำ'
  )
LIMIT 1;
-- แถว 262: นางสาวมาลินี รักษ์อินทร์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqx529fcqv9',
  'M00262',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมาลินี',
  'รักษ์อินทร์',
  '097-9956706',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมาลินี' AND m.lastName = 'รักษ์อินทร์'
  )
LIMIT 1;
-- แถว 263: นางสาวมณีรัตน์ สมฤทธิ์ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfdirm3ovlei7',
  'M00263',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมณีรัตน์',
  'สมฤทธิ์',
  '087-3593789',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมณีรัตน์' AND m.lastName = 'สมฤทธิ์'
  )
LIMIT 1;
-- แถว 264: นางสาวภัทรา ใจผ่อง | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpm27a9txcm',
  'M00264',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัทรา',
  'ใจผ่อง',
  '087-5654822',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัทรา' AND m.lastName = 'ใจผ่อง'
  )
LIMIT 1;
-- แถว 265: นางสาวอรุณนาท ตั้งศิริ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwtmc22q881h',
  'M00265',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรุณนาท',
  'ตั้งศิริ',
  '065-0284281',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรุณนาท' AND m.lastName = 'ตั้งศิริ'
  )
LIMIT 1;
-- แถว 266: นายวชิรชัย มีบุญ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvle3b285nfl',
  'M00266',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวชิรชัย',
  'มีบุญ',
  '089-8521980',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวชิรชัย' AND m.lastName = 'มีบุญ'
  )
LIMIT 1;
-- แถว 267: นางสาวพิมพ์รัตน์ เชื้อเมืองพาน | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf1vkysgrf7qx',
  'M00267',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์รัตน์',
  'เชื้อเมืองพาน',
  '086-9181624',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์รัตน์' AND m.lastName = 'เชื้อเมืองพาน'
  )
LIMIT 1;
-- แถว 268: นายพรรษา ทำโมนะ | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfh1jbjg45d25',
  'M00268',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพรรษา',
  'ทำโมนะ',
  '083-2657809',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพรรษา' AND m.lastName = 'ทำโมนะ'
  )
LIMIT 1;
-- แถว 269: นางสาวโชตินภา สมองฟ้าไกร | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf5uamv93wwp5',
  'M00269',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวโชตินภา',
  'สมองฟ้าไกร',
  '093-3614188',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวโชตินภา' AND m.lastName = 'สมองฟ้าไกร'
  )
LIMIT 1;
-- แถว 270: นายจิราวุฒิ แก้วสี | โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmtzwq5y77gb',
  'M00270',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิราวุฒิ',
  'แก้วสี',
  '065-2718358',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_011_สามัคคีพัฒนา_กลุ่มเค' OR s.name = 'โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนสามัคคีพัฒนา   กลุ่มเครือข่ายพัฒนาการศึกษา%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิราวุฒิ' AND m.lastName = 'แก้วสี'
  )
LIMIT 1;
-- แถว 271: นายพิชชากร  อานุ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfffmprepfaed',
  'M00271',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิชชากร',
  'อานุ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิชชากร' AND m.lastName = 'อานุ'
  )
LIMIT 1;
-- แถว 272: นางกฤษกร เรืองวิทยนันท์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfcpcs1nbg5vc',
  'M00272',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกฤษกร',
  'เรืองวิทยนันท์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกฤษกร' AND m.lastName = 'เรืองวิทยนันท์'
  )
LIMIT 1;
-- แถว 273: นางสาววรรนิสา กุญชร | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntflm1jf8m6v9d',
  'M00273',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรนิสา',
  'กุญชร',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรนิสา' AND m.lastName = 'กุญชร'
  )
LIMIT 1;
-- แถว 274: นางสาวณัฐิภา  ปัญญาแก้ว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf5leqzfzurkj',
  'M00274',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐิภา',
  'ปัญญาแก้ว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐิภา' AND m.lastName = 'ปัญญาแก้ว'
  )
LIMIT 1;
-- แถว 275: นางสาวภัควลัญจน์ จันทร์ไชยวงศ์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhzdxgdqmdvg',
  'M00275',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัควลัญจน์',
  'จันทร์ไชยวงศ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัควลัญจน์' AND m.lastName = 'จันทร์ไชยวงศ์'
  )
LIMIT 1;
-- แถว 276: นางสาวขวัญมนัส  ทำทาน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpmhpm9v5od',
  'M00276',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวขวัญมนัส',
  'ทำทาน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวขวัญมนัส' AND m.lastName = 'ทำทาน'
  )
LIMIT 1;
-- แถว 277: นายสุธินันท์  คำแสน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf845t8y3gimd',
  'M00277',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุธินันท์',
  'คำแสน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุธินันท์' AND m.lastName = 'คำแสน'
  )
LIMIT 1;
-- แถว 278: นางประภัสวรรณ เชื้อเมืองพาน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfbti757w4ip',
  'M00278',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางประภัสวรรณ',
  'เชื้อเมืองพาน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางประภัสวรรณ' AND m.lastName = 'เชื้อเมืองพาน'
  )
LIMIT 1;
-- แถว 279: นายเดชณรงค์  คบลา | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfszu5j94znhr',
  'M00279',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเดชณรงค์',
  'คบลา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเดชณรงค์' AND m.lastName = 'คบลา'
  )
LIMIT 1;
-- แถว 280: นางสาวอชิรญา  ช่างเขียน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvajajk0rjvs',
  'M00280',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอชิรญา',
  'ช่างเขียน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอชิรญา' AND m.lastName = 'ช่างเขียน'
  )
LIMIT 1;
-- แถว 281: นางธารทิพย์  นรรัตน์ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7kpwgyhw3sw',
  'M00281',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางธารทิพย์',
  'นรรัตน์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางธารทิพย์' AND m.lastName = 'นรรัตน์'
  )
LIMIT 1;
-- แถว 282: นางสาวณัฐณิชา แสงนิล | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfyymjl2c6p2',
  'M00282',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐณิชา',
  'แสงนิล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐณิชา' AND m.lastName = 'แสงนิล'
  )
LIMIT 1;
-- แถว 283: นางสาวปรารถนา สร้างโศรก | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwbwabzdkz6',
  'M00283',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปรารถนา',
  'สร้างโศรก',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปรารถนา' AND m.lastName = 'สร้างโศรก'
  )
LIMIT 1;
-- แถว 284: นายสุทิน เขื่อนคำแสน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfuljxq5bbfn',
  'M00284',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุทิน',
  'เขื่อนคำแสน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุทิน' AND m.lastName = 'เขื่อนคำแสน'
  )
LIMIT 1;
-- แถว 285: นายยศพล ศรีอัญชลีกร | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfu3df6gcu6w',
  'M00285',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยศพล',
  'ศรีอัญชลีกร',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยศพล' AND m.lastName = 'ศรีอัญชลีกร'
  )
LIMIT 1;
-- แถว 286: นางสาววิเศษลักษณ์  วงศ์เป็ง | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvc7iwe47qs8',
  'M00286',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิเศษลักษณ์',
  'วงศ์เป็ง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิเศษลักษณ์' AND m.lastName = 'วงศ์เป็ง'
  )
LIMIT 1;
-- แถว 287: นางสาวเจษสุภาภรณ์ คำปวน | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfxrtw7k46sr',
  'M00287',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเจษสุภาภรณ์',
  'คำปวน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเจษสุภาภรณ์' AND m.lastName = 'คำปวน'
  )
LIMIT 1;
-- แถว 288: นายภูริทัต  อินทรประเสริฐ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfc2ijn0lgsut',
  'M00288',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภูริทัต',
  'อินทรประเสริฐ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภูริทัต' AND m.lastName = 'อินทรประเสริฐ'
  )
LIMIT 1;
-- แถว 289: นางสาวสุภนุช จิตสวา | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjlxiprtk5bn',
  'M00289',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุภนุช',
  'จิตสวา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุภนุช' AND m.lastName = 'จิตสวา'
  )
LIMIT 1;
-- แถว 290: นายอะแล  มาเยอะ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfulcfoteaor',
  'M00290',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอะแล',
  'มาเยอะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอะแล' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 291: นางสาวหมี่ตุ แซ่จ๋าว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfgq845qwirvv',
  'M00291',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหมี่ตุ',
  'แซ่จ๋าว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหมี่ตุ' AND m.lastName = 'แซ่จ๋าว'
  )
LIMIT 1;
-- แถว 292: นางวิรศรา  แซ่ฮ่อ | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfq0z6f92oyy8',
  'M00292',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางวิรศรา',
  'แซ่ฮ่อ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางวิรศรา' AND m.lastName = 'แซ่ฮ่อ'
  )
LIMIT 1;
-- แถว 293: นางสาวหมี่โผ่ แซ่จ๋าว | โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfytczben363d',
  'M00293',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหมี่โผ่',
  'แซ่จ๋าว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_012_บ้านแม่หม้อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านแม่หม้อ   กลุ่มเครือข่ายพัฒนาการศึกษาเ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหมี่โผ่' AND m.lastName = 'แซ่จ๋าว'
  )
LIMIT 1;
-- แถว 294: นายชำนาญ บอแฉ่ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfk8wjt768c8h',
  'M00294',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชำนาญ',
  'บอแฉ่',
  '0807905583',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชำนาญ' AND m.lastName = 'บอแฉ่'
  )
LIMIT 1;
-- แถว 295: นางสาวชามรี ระวังทรัพย์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjg9qsm11hm',
  'M00295',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชามรี',
  'ระวังทรัพย์',
  '0834799281',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชามรี' AND m.lastName = 'ระวังทรัพย์'
  )
LIMIT 1;
-- แถว 296: นางสาวสุพรรณษา คอง | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfdn8ujobecgo',
  'M00296',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุพรรณษา',
  'คอง',
  '0882242395',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุพรรณษา' AND m.lastName = 'คอง'
  )
LIMIT 1;
-- แถว 297: นายกฤษฎาภูมิ ไชยภูมิ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfsagdqc4g7dm',
  'M00297',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกฤษฎาภูมิ',
  'ไชยภูมิ',
  '0869239061',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกฤษฎาภูมิ' AND m.lastName = 'ไชยภูมิ'
  )
LIMIT 1;
-- แถว 298: นางสาวปิ่นทิพย์ ผาสุวรรณ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf5kwqdxf6mgt',
  'M00298',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปิ่นทิพย์',
  'ผาสุวรรณ',
  '0645432664',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปิ่นทิพย์' AND m.lastName = 'ผาสุวรรณ'
  )
LIMIT 1;
-- แถว 299: นางสาวชญานี โพธิ์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfsz5z1tp8m5',
  'M00299',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชญานี',
  'โพธิ์',
  '0972989779',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชญานี' AND m.lastName = 'โพธิ์'
  )
LIMIT 1;
-- แถว 300: นางสาวเบญจวรรณ เตปินใจ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0vi08cj8bci',
  'M00300',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเบญจวรรณ',
  'เตปินใจ',
  '0887741277',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเบญจวรรณ' AND m.lastName = 'เตปินใจ'
  )
LIMIT 1;
-- แถว 301: นางสาวธัญญพัทธ์ ธนกฤษไพศย์ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfufm7pgq1uos',
  'M00301',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญญพัทธ์',
  'ธนกฤษไพศย์',
  '0863675280',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญญพัทธ์' AND m.lastName = 'ธนกฤษไพศย์'
  )
LIMIT 1;
-- แถว 302: นางสาวตุ๊ดนันท์ ชาวเหนือ | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfn8te3eibp5',
  'M00302',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวตุ๊ดนันท์',
  'ชาวเหนือ',
  '0910710952',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวตุ๊ดนันท์' AND m.lastName = 'ชาวเหนือ'
  )
LIMIT 1;
-- แถว 303: นางวิชญาดา จันลา | โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntftv4vhkwkz5',
  'M00303',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางวิชญาดา',
  'จันลา',
  '0817844584',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_013_บ้านผาจี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านผาจี กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางวิชญาดา' AND m.lastName = 'จันลา'
  )
LIMIT 1;
-- แถว 304: นายดนัยวัฒน์  มณี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf2fni776gztk',
  'M00304',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายดนัยวัฒน์',
  'มณี',
  '082-5915326',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายดนัยวัฒน์' AND m.lastName = 'มณี'
  )
LIMIT 1;
-- แถว 305: นายภูมินทร์ แสงสร้อย | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfrfu7k2dkp3',
  'M00305',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภูมินทร์',
  'แสงสร้อย',
  '097-9251551',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภูมินทร์' AND m.lastName = 'แสงสร้อย'
  )
LIMIT 1;
-- แถว 306: นายสหัสวรรษ ศักภิวัล | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmduhl8b3z5l',
  'M00306',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสหัสวรรษ',
  'ศักภิวัล',
  '094-7194151',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสหัสวรรษ' AND m.lastName = 'ศักภิวัล'
  )
LIMIT 1;
-- แถว 307: นางสาวสุดา พรมตา | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3f73qftdm59',
  'M00307',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุดา',
  'พรมตา',
  '061-5929222',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุดา' AND m.lastName = 'พรมตา'
  )
LIMIT 1;
-- แถว 308: นายยุทธพงษ์ สุยะ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfoitmvob2p1',
  'M00308',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยุทธพงษ์',
  'สุยะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยุทธพงษ์' AND m.lastName = 'สุยะ'
  )
LIMIT 1;
-- แถว 309: นายภัทรพล ศรีผาย | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpvfbhqcjqtp',
  'M00309',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภัทรพล',
  'ศรีผาย',
  '081-3572080',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภัทรพล' AND m.lastName = 'ศรีผาย'
  )
LIMIT 1;
-- แถว 310: นางสาวภัณฑิรา ยอดคีรี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwtsd1h85ysf',
  'M00310',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัณฑิรา',
  'ยอดคีรี',
  '087-5752946',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัณฑิรา' AND m.lastName = 'ยอดคีรี'
  )
LIMIT 1;
-- แถว 311: นางสาวชลธิชา เขื่อนปัญญา | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfz4v0tcb2t3',
  'M00311',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชลธิชา',
  'เขื่อนปัญญา',
  '095-6919918',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชลธิชา' AND m.lastName = 'เขื่อนปัญญา'
  )
LIMIT 1;
-- แถว 312: นางสาวรมณีย์  หล้าธิ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfz11nw0ygpv',
  'M00312',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรมณีย์',
  'หล้าธิ',
  '095-8840785',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรมณีย์' AND m.lastName = 'หล้าธิ'
  )
LIMIT 1;
-- แถว 313: นางสาวไหนจ้อย  แซ่ลี | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8yf8ceke6sa',
  'M00313',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวไหนจ้อย',
  'แซ่ลี',
  '093-1577858',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวไหนจ้อย' AND m.lastName = 'แซ่ลี'
  )
LIMIT 1;
-- แถว 314: นายชยาวุธ ปิติว่าเจริญ | โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfj0498v5w0o',
  'M00314',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชยาวุธ',
  'ปิติว่าเจริญ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_014_บ้านปางมะหัน_กลุ่มเค' OR s.name = 'โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านปางมะหัน กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชยาวุธ' AND m.lastName = 'ปิติว่าเจริญ'
  )
LIMIT 1;
-- แถว 315: วาที่รอยเอกบรรจงฤทธิ์  สุทธสม | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzsyirgakwwd',
  'M00315',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'วาที่รอยเอกบรรจงฤทธิ์',
  'สุทธสม',
  '918400071',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'วาที่รอยเอกบรรจงฤทธิ์' AND m.lastName = 'สุทธสม'
  )
LIMIT 1;
-- แถว 316: นายสุทิวัส ตติยะตนตระกูล | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmfeakptsn7e',
  'M00316',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุทิวัส',
  'ตติยะตนตระกูล',
  '997598441',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุทิวัส' AND m.lastName = 'ตติยะตนตระกูล'
  )
LIMIT 1;
-- แถว 317: นางสาวกานทชญา พรมเสน | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfh8yoatxes3',
  'M00317',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกานทชญา',
  'พรมเสน',
  '858685977',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกานทชญา' AND m.lastName = 'พรมเสน'
  )
LIMIT 1;
-- แถว 318: นายชัยกาญจน นวลกําแหง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf85bvxvmtbr3',
  'M00318',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชัยกาญจน',
  'นวลกําแหง',
  '927692833',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชัยกาญจน' AND m.lastName = 'นวลกําแหง'
  )
LIMIT 1;
-- แถว 319: นางสาวธาดารัตน อุดมปละ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf6hgaq9vh3vu',
  'M00319',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธาดารัตน',
  'อุดมปละ',
  '651141704',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธาดารัตน' AND m.lastName = 'อุดมปละ'
  )
LIMIT 1;
-- แถว 320: นางสาวกังสดาล ใจกลา | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzwhoni5ns1',
  'M00320',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกังสดาล',
  'ใจกลา',
  '928294215',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกังสดาล' AND m.lastName = 'ใจกลา'
  )
LIMIT 1;
-- แถว 321: นางสาวเกศินี วิชัยเนตร | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfdr5nq1eox6l',
  'M00321',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกศินี',
  'วิชัยเนตร',
  '982950564',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกศินี' AND m.lastName = 'วิชัยเนตร'
  )
LIMIT 1;
-- แถว 322: นางสาวจารุวรรณ คําเหล็ก | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfckum3m7u40o',
  'M00322',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'คําเหล็ก',
  '993780418',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'คําเหล็ก'
  )
LIMIT 1;
-- แถว 323: นายกิตติภพ แซตัง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfw6g6plbw4g',
  'M00323',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกิตติภพ',
  'แซตัง',
  '941419092',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกิตติภพ' AND m.lastName = 'แซตัง'
  )
LIMIT 1;
-- แถว 324: นายวรเชษฐ แววสี | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf265crsebgnl',
  'M00324',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวรเชษฐ',
  'แววสี',
  '808245547',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวรเชษฐ' AND m.lastName = 'แววสี'
  )
LIMIT 1;
-- แถว 325: นางสาวศันสนา ปวกหลวง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9iwodagoobk',
  'M00325',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศันสนา',
  'ปวกหลวง',
  '844865092',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศันสนา' AND m.lastName = 'ปวกหลวง'
  )
LIMIT 1;
-- แถว 326: นางสาวปยะนุช สุนาโท | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfz88tklmizf9',
  'M00326',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปยะนุช',
  'สุนาโท',
  '879653814',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปยะนุช' AND m.lastName = 'สุนาโท'
  )
LIMIT 1;
-- แถว 327: นางสาวรัชฎา ตาฮง | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfcqcukkamuia',
  'M00327',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัชฎา',
  'ตาฮง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัชฎา' AND m.lastName = 'ตาฮง'
  )
LIMIT 1;
-- แถว 328: นายสมศักดิ์ แซหมื่อ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntftavxn9e4fr',
  'M00328',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมศักดิ์',
  'แซหมื่อ',
  '828312471',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมศักดิ์' AND m.lastName = 'แซหมื่อ'
  )
LIMIT 1;
-- แถว 329: นายธนาพล มาเยอะ | โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntftppqwie8gfb',
  'M00329',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนาพล',
  'มาเยอะ',
  '625707424',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_015_ตํารวจตระเวนชายแดนบํ' OR s.name = 'โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนตํารวจตระเวนชายแดนบํารุงที่  87 กลุ่มเครือ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนาพล' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 330: นางสาวสุดารัตน์ ปัญญาศิริวงศ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhnzec0lzm1r',
  'M00330',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุดารัตน์',
  'ปัญญาศิริวงศ์',
  '086 395 1946',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุดารัตน์' AND m.lastName = 'ปัญญาศิริวงศ์'
  )
LIMIT 1;
-- แถว 331: นางจีราพร อินทะนิล | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfaxnie37wgvu',
  'M00331',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางจีราพร',
  'อินทะนิล',
  '085 723 5256',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางจีราพร' AND m.lastName = 'อินทะนิล'
  )
LIMIT 1;
-- แถว 332: นายพงศ์พันธ์ โพธิ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7r7u59dqls4',
  'M00332',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพงศ์พันธ์',
  'โพธิ์',
  '087 786 6616',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพงศ์พันธ์' AND m.lastName = 'โพธิ์'
  )
LIMIT 1;
-- แถว 333: นายเนตรศักดิ์ เชียงเครือ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffkb7fsnlklp',
  'M00333',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเนตรศักดิ์',
  'เชียงเครือ',
  '095 290 8637',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเนตรศักดิ์' AND m.lastName = 'เชียงเครือ'
  )
LIMIT 1;
-- แถว 334: นางสาวจินดารัตน์ บุปผฤกษ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfqk0d7fjdlfh',
  'M00334',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจินดารัตน์',
  'บุปผฤกษ์',
  '092 896 5315',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจินดารัตน์' AND m.lastName = 'บุปผฤกษ์'
  )
LIMIT 1;
-- แถว 335: นางสาวกาญจนา บุตรี | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfoph92plr2tj',
  'M00335',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกาญจนา',
  'บุตรี',
  '090 215 6584',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกาญจนา' AND m.lastName = 'บุตรี'
  )
LIMIT 1;
-- แถว 336: นางสาวชมพร ติตนากาศ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfakkicwo1k7o',
  'M00336',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชมพร',
  'ติตนากาศ',
  '062 075 3430',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชมพร' AND m.lastName = 'ติตนากาศ'
  )
LIMIT 1;
-- แถว 337: นางสาววิภาภัค กันตะยา | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfx1u5mqot0tl',
  'M00337',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิภาภัค',
  'กันตะยา',
  '089 665 1664',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิภาภัค' AND m.lastName = 'กันตะยา'
  )
LIMIT 1;
-- แถว 338: นางสาวเขมิกา เตมูลละ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffsvaw8oj57t',
  'M00338',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเขมิกา',
  'เตมูลละ',
  '094 613 4046',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเขมิกา' AND m.lastName = 'เตมูลละ'
  )
LIMIT 1;
-- แถว 339: นางสาวสิเรชา รุ่งกานภาค | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfhqt4qtb6tku',
  'M00339',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิเรชา',
  'รุ่งกานภาค',
  '085 189 8192',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิเรชา' AND m.lastName = 'รุ่งกานภาค'
  )
LIMIT 1;
-- แถว 340: นายคณภัณฑ์ หมั่นสมบัติ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfo6rcc9ppa8b',
  'M00340',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคณภัณฑ์',
  'หมั่นสมบัติ',
  '088 236 7367',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคณภัณฑ์' AND m.lastName = 'หมั่นสมบัติ'
  )
LIMIT 1;
-- แถว 341: นางสาวธัญชนรี แก้วนภรสิการ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf1fbvlkl085r',
  'M00341',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญชนรี',
  'แก้วนภรสิการ',
  '096 345 8861',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญชนรี' AND m.lastName = 'แก้วนภรสิการ'
  )
LIMIT 1;
-- แถว 342: นางสาวปรียลักษณ์ โภคาร | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzpk47jkl69',
  'M00342',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปรียลักษณ์',
  'โภคาร',
  '096 329 3591',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปรียลักษณ์' AND m.lastName = 'โภคาร'
  )
LIMIT 1;
-- แถว 343: นางสาวชนากานต์ อภิสริประภา | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf80gn0jqxer9',
  'M00343',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชนากานต์',
  'อภิสริประภา',
  '064 738 4502',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชนากานต์' AND m.lastName = 'อภิสริประภา'
  )
LIMIT 1;
-- แถว 344: นางสาวรัตตกาล ยาธรงษ์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfkrxbj56v0ef',
  'M00344',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัตตกาล',
  'ยาธรงษ์',
  '081 029 9962',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัตตกาล' AND m.lastName = 'ยาธรงษ์'
  )
LIMIT 1;
-- แถว 345: นายมล คำจันทร์ | โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf87x3v8ej9h',
  'M00345',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายมล',
  'คำจันทร์',
  '082 606 0137',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_016_บ้านห้วยอื้น_กลุ่มเค' OR s.name = 'โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านห้วยอื้น กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายมล' AND m.lastName = 'คำจันทร์'
  )
LIMIT 1;
-- แถว 346: นายบัญญัติ ยานะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfdvkq7b3anvu',
  'M00346',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายบัญญัติ',
  'ยานะ',
  '828892454',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายบัญญัติ' AND m.lastName = 'ยานะ'
  )
LIMIT 1;
-- แถว 347: นายวุฒิชัย กันสุธรรม | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfc3rvzuk6jf',
  'M00347',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวุฒิชัย',
  'กันสุธรรม',
  '858636619',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวุฒิชัย' AND m.lastName = 'กันสุธรรม'
  )
LIMIT 1;
-- แถว 348: นางสาวธนารัตน์ ลือชัย | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfv2j8dhnvqw',
  'M00348',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธนารัตน์',
  'ลือชัย',
  '9552744645',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธนารัตน์' AND m.lastName = 'ลือชัย'
  )
LIMIT 1;
-- แถว 349: นางสาวพิมบุญ แสนมงคล | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntff3vndo86j7d',
  'M00349',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมบุญ',
  'แสนมงคล',
  '911396631',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมบุญ' AND m.lastName = 'แสนมงคล'
  )
LIMIT 1;
-- แถว 350: นางสาวกัลยรัตน์ ชัยธรรม | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3leraqgcrbp',
  'M00350',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัลยรัตน์',
  'ชัยธรรม',
  '875441721',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัลยรัตน์' AND m.lastName = 'ชัยธรรม'
  )
LIMIT 1;
-- แถว 351: นางสาวชญานี คันทะเนตร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfi3drbzrdjmn',
  'M00351',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชญานี',
  'คันทะเนตร',
  '956808218',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชญานี' AND m.lastName = 'คันทะเนตร'
  )
LIMIT 1;
-- แถว 352: ว่าที่ ร.ต.ภูวดล กุญชร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfxxq4po0g5vn',
  'M00352',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่',
  'ร.ต.ภูวดล กุญชร',
  '835673282',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่' AND m.lastName = 'ร.ต.ภูวดล กุญชร'
  )
LIMIT 1;
-- แถว 353: นางสาวอัญชลี หาทองคำ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfur3q7v8xfiq',
  'M00353',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัญชลี',
  'หาทองคำ',
  '931722192',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัญชลี' AND m.lastName = 'หาทองคำ'
  )
LIMIT 1;
-- แถว 354: นางสาวปฐมาวดี แมตสอง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfenrkj89tn5',
  'M00354',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปฐมาวดี',
  'แมตสอง',
  '958359428',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปฐมาวดี' AND m.lastName = 'แมตสอง'
  )
LIMIT 1;
-- แถว 355: นายคชศักดิ์ ต่างเพ็ชร | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9xpbwzwhfq',
  'M00355',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคชศักดิ์',
  'ต่างเพ็ชร',
  '639685911',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคชศักดิ์' AND m.lastName = 'ต่างเพ็ชร'
  )
LIMIT 1;
-- แถว 356: นายณัฐภูมิ มาแว่น | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjnkrewk163',
  'M00356',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐภูมิ',
  'มาแว่น',
  '987698276',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐภูมิ' AND m.lastName = 'มาแว่น'
  )
LIMIT 1;
-- แถว 357: นางสาวปรีณาภา คำภิละ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfrxk99ocdmzt',
  'M00357',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปรีณาภา',
  'คำภิละ',
  '931626490',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปรีณาภา' AND m.lastName = 'คำภิละ'
  )
LIMIT 1;
-- แถว 358: นางสาวสุชานันท์ ภักดีบุรี | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfsybvi4lvcbq',
  'M00358',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชานันท์',
  'ภักดีบุรี',
  '931683389',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชานันท์' AND m.lastName = 'ภักดีบุรี'
  )
LIMIT 1;
-- แถว 359: นางสาวยุพิน คำแก้ว | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfluujvdo723',
  'M00359',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวยุพิน',
  'คำแก้ว',
  '824156084',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวยุพิน' AND m.lastName = 'คำแก้ว'
  )
LIMIT 1;
-- แถว 360: นายธีรทัช บุญทา | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpyd0rootxhr',
  'M00360',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธีรทัช',
  'บุญทา',
  '912979799',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธีรทัช' AND m.lastName = 'บุญทา'
  )
LIMIT 1;
-- แถว 361: นางสาวอริศรา พิธีเรือง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvtm54npzh1',
  'M00361',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอริศรา',
  'พิธีเรือง',
  '957284987',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอริศรา' AND m.lastName = 'พิธีเรือง'
  )
LIMIT 1;
-- แถว 362: นางสาวสุพัตรา คำสุ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3nodq69aupu',
  'M00362',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุพัตรา',
  'คำสุ',
  '623098815',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุพัตรา' AND m.lastName = 'คำสุ'
  )
LIMIT 1;
-- แถว 363: นางสาววิลาวรรณ อินตา | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmr5ngdn26ln',
  'M00363',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิลาวรรณ',
  'อินตา',
  '813940907',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิลาวรรณ' AND m.lastName = 'อินตา'
  )
LIMIT 1;
-- แถว 364: นายอนุชิต แข็งแรง | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0lgyxo5q4jc',
  'M00364',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอนุชิต',
  'แข็งแรง',
  '612674790',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอนุชิต' AND m.lastName = 'แข็งแรง'
  )
LIMIT 1;
-- แถว 365: นางสาวฐิตาภรณ์ สายอิ่นแก้ว | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf32ys51e27w5',
  'M00365',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฐิตาภรณ์',
  'สายอิ่นแก้ว',
  '063-7272518',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฐิตาภรณ์' AND m.lastName = 'สายอิ่นแก้ว'
  )
LIMIT 1;
-- แถว 366: นายกรกฎ โรจนนิจ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf15aszmx27gc',
  'M00366',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกรกฎ',
  'โรจนนิจ',
  '095-8064029',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกรกฎ' AND m.lastName = 'โรจนนิจ'
  )
LIMIT 1;
-- แถว 367: นางสาวศิรินกรณ์  สุยะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfwkqxmuv4b4e',
  'M00367',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิรินกรณ์',
  'สุยะ',
  '061-2850050',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิรินกรณ์' AND m.lastName = 'สุยะ'
  )
LIMIT 1;
-- แถว 368: นางสาวสุจินดา ใจกล้า | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0aulg120db4k',
  'M00368',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุจินดา',
  'ใจกล้า',
  '087-5774566',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุจินดา' AND m.lastName = 'ใจกล้า'
  )
LIMIT 1;
-- แถว 369: นายพุฒิชัย  ไฝเครือ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfw7hx2k9nklp',
  'M00369',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพุฒิชัย',
  'ไฝเครือ',
  '086-4308642',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพุฒิชัย' AND m.lastName = 'ไฝเครือ'
  )
LIMIT 1;
-- แถว 370: นายภาณุพงค์  ยาจันทร์ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0hwv5uk8ndkl',
  'M00370',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภาณุพงค์',
  'ยาจันทร์',
  '095-2427771',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภาณุพงค์' AND m.lastName = 'ยาจันทร์'
  )
LIMIT 1;
-- แถว 371: นายฉัตรดนัย  ใยญาติ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf28rw94bgnh1',
  'M00371',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฉัตรดนัย',
  'ใยญาติ',
  '085-8789838',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฉัตรดนัย' AND m.lastName = 'ใยญาติ'
  )
LIMIT 1;
-- แถว 372: นายเลอพงษ์  ปัญญาดี | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntffj7g32brhtq',
  'M00372',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเลอพงษ์',
  'ปัญญาดี',
  '087-1878403',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเลอพงษ์' AND m.lastName = 'ปัญญาดี'
  )
LIMIT 1;
-- แถว 373: นางสาวจารุวรรณ กันทะ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfb73uvahtai9',
  'M00373',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'กันทะ',
  '080-6029200',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'กันทะ'
  )
LIMIT 1;
-- แถว 374: นายจายแสง  มอญคำ | โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf06tn76ig3a2q',
  'M00374',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจายแสง',
  'มอญคำ',
  '081-1611905',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_017_พญาไพรไตรมิตร_กลุ่มเ' OR s.name = 'โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย' OR s.name LIKE '%โรงเรียนพญาไพรไตรมิตร กลุ่มเครือข่ายเทอดไทย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจายแสง' AND m.lastName = 'มอญคำ'
  )
LIMIT 1;
-- แถว 375: นายเกรียงศักดิ์  ฝึกฝน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfu04iddbo5hk',
  'M00375',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเกรียงศักดิ์',
  'ฝึกฝน',
  '943645494',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเกรียงศักดิ์' AND m.lastName = 'ฝึกฝน'
  )
LIMIT 1;
-- แถว 376: นางสุรีย์พร  แข็งขันธ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfoty5seo1w3',
  'M00376',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสุรีย์พร',
  'แข็งขันธ์',
  '085-0331023',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสุรีย์พร' AND m.lastName = 'แข็งขันธ์'
  )
LIMIT 1;
-- แถว 377: นางนวนันท์  สิทธิวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfd0syb4tkro',
  'M00377',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางนวนันท์',
  'สิทธิวงศ์',
  '090-3186928',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางนวนันท์' AND m.lastName = 'สิทธิวงศ์'
  )
LIMIT 1;
-- แถว 378: นางสาวพิมพ์พิกา จันทร์เทพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfm51l5f98h5',
  'M00378',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์พิกา',
  'จันทร์เทพ',
  '093-3026863',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์พิกา' AND m.lastName = 'จันทร์เทพ'
  )
LIMIT 1;
-- แถว 379: นางสาวน้ำเพชร  ชัยชมภู | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfn307dtv7gmg',
  'M00379',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวน้ำเพชร',
  'ชัยชมภู',
  '095-6906952',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวน้ำเพชร' AND m.lastName = 'ชัยชมภู'
  )
LIMIT 1;
-- แถว 380: นางสาวพัชรา  สินธรมงคล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0dcgcs2qko4c',
  'M00380',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัชรา',
  'สินธรมงคล',
  '085-5737026',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัชรา' AND m.lastName = 'สินธรมงคล'
  )
LIMIT 1;
-- แถว 381: ว่าที่ร้อยตรีโสธร   ศรีอาวุธ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfnipov7aia3k',
  'M00381',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีโสธร',
  'ศรีอาวุธ',
  '096-2765061',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีโสธร' AND m.lastName = 'ศรีอาวุธ'
  )
LIMIT 1;
-- แถว 382: นางศรีจันทร์  กันทะนะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfgpkc37y88k',
  'M00382',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางศรีจันทร์',
  'กันทะนะ',
  '086-1900711',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางศรีจันทร์' AND m.lastName = 'กันทะนะ'
  )
LIMIT 1;
-- แถว 383: นางสาวอัญชลี  เมฆวิบูลย์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntftdlapntpd1',
  'M00383',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัญชลี',
  'เมฆวิบูลย์',
  '099-1545942',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัญชลี' AND m.lastName = 'เมฆวิบูลย์'
  )
LIMIT 1;
-- แถว 384: นางสาวฟ้าใส วิสารกาญจน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfg33nnl1k4gd',
  'M00384',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฟ้าใส',
  'วิสารกาญจน',
  '087-9362077',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฟ้าใส' AND m.lastName = 'วิสารกาญจน'
  )
LIMIT 1;
-- แถว 385: นายพีรกร  สมคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfnmtm2vgkffm',
  'M00385',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพีรกร',
  'สมคำ',
  '081-2872691',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพีรกร' AND m.lastName = 'สมคำ'
  )
LIMIT 1;
-- แถว 386: นางธรรยธรฐ์  ดวงสนิท | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmp59xxhjlqn',
  'M00386',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางธรรยธรฐ์',
  'ดวงสนิท',
  '062-0436223',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางธรรยธรฐ์' AND m.lastName = 'ดวงสนิท'
  )
LIMIT 1;
-- แถว 387: นางสาวฉัตรนิฏฐา   สุนันตา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfq9745uw2u2l',
  'M00387',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฉัตรนิฏฐา',
  'สุนันตา',
  '088-2686202',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฉัตรนิฏฐา' AND m.lastName = 'สุนันตา'
  )
LIMIT 1;
-- แถว 388: ว่าที่ร้อยตรีอนุรักษ์  มั่นอ่วม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8mmw3flbxjs',
  'M00388',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีอนุรักษ์',
  'มั่นอ่วม',
  '081-0450609',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีอนุรักษ์' AND m.lastName = 'มั่นอ่วม'
  )
LIMIT 1;
-- แถว 389: นางสาวศิริพร   เยอะหนื่อ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3ls487vctvb',
  'M00389',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริพร',
  'เยอะหนื่อ',
  '095-8324631',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริพร' AND m.lastName = 'เยอะหนื่อ'
  )
LIMIT 1;
-- แถว 390: นายทนงศักดิ์   หวานหอม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfcnrvx1m7m8u',
  'M00390',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายทนงศักดิ์',
  'หวานหอม',
  '087-5699698',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายทนงศักดิ์' AND m.lastName = 'หวานหอม'
  )
LIMIT 1;
-- แถว 391: นางสาวนิลรัตน์  ไชยรังสฤษดิ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfws07kxijw9o',
  'M00391',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิลรัตน์',
  'ไชยรังสฤษดิ์',
  '092-6857660',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิลรัตน์' AND m.lastName = 'ไชยรังสฤษดิ์'
  )
LIMIT 1;
-- แถว 392: นายไพชยนต์   สิทธิยศ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3n9cednacbw',
  'M00392',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไพชยนต์',
  'สิทธิยศ',
  '091-8505533',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไพชยนต์' AND m.lastName = 'สิทธิยศ'
  )
LIMIT 1;
-- แถว 393: นางสาวศรัญญา  เชื้อเมืองพาน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfy1kvv8dxd5g',
  'M00393',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศรัญญา',
  'เชื้อเมืองพาน',
  '098-2720503',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศรัญญา' AND m.lastName = 'เชื้อเมืองพาน'
  )
LIMIT 1;
-- แถว 394: นายพิรเศรษฐ์   จินะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf90e2peq4zfk',
  'M00394',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพิรเศรษฐ์',
  'จินะ',
  '095-9708458',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพิรเศรษฐ์' AND m.lastName = 'จินะ'
  )
LIMIT 1;
-- แถว 395: นายธนทรัพย์   รัตนไภ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf2pwx1t5yk46',
  'M00395',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนทรัพย์',
  'รัตนไภ',
  '085-6897599',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนทรัพย์' AND m.lastName = 'รัตนไภ'
  )
LIMIT 1;
-- แถว 396: นายศักดา  วันเพ็ญ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfmxpg5aj7s8',
  'M00396',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศักดา',
  'วันเพ็ญ',
  '063-1231439',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศักดา' AND m.lastName = 'วันเพ็ญ'
  )
LIMIT 1;
-- แถว 397: นางสาวภาสินี   ธิศรี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzyo7bkz8e1l',
  'M00397',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภาสินี',
  'ธิศรี',
  '084-0407484',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภาสินี' AND m.lastName = 'ธิศรี'
  )
LIMIT 1;
-- แถว 398: นางสาววรัชญ์ขวัญ  ปัญวิยะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfbiqzntrmx6h',
  'M00398',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรัชญ์ขวัญ',
  'ปัญวิยะ',
  '065-5354154',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรัชญ์ขวัญ' AND m.lastName = 'ปัญวิยะ'
  )
LIMIT 1;
-- แถว 399: นางสาวปวริศา   สุระจิตต์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfps4pht313t',
  'M00399',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปวริศา',
  'สุระจิตต์',
  '095-3516691',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปวริศา' AND m.lastName = 'สุระจิตต์'
  )
LIMIT 1;
-- แถว 400: นางรตีกานต์   เดินแปง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf687mp1eqgrn',
  'M00400',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางรตีกานต์',
  'เดินแปง',
  '084-1377508',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางรตีกานต์' AND m.lastName = 'เดินแปง'
  )
LIMIT 1;
-- แถว 401: นางสาววารุณี  หลวงไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfopkh5d8ns6s',
  'M00401',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววารุณี',
  'หลวงไชย',
  '087-3115318',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววารุณี' AND m.lastName = 'หลวงไชย'
  )
LIMIT 1;
-- แถว 402: นางสาวนพเก้า  นิพัฒน์ศิริผล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfujf5q4vecfg',
  'M00402',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนพเก้า',
  'นิพัฒน์ศิริผล',
  '097-9536835',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนพเก้า' AND m.lastName = 'นิพัฒน์ศิริผล'
  )
LIMIT 1;
-- แถว 403: นางสาวปุญญิสา ปงลังกา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfzna0wwdrr7q',
  'M00403',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปุญญิสา',
  'ปงลังกา',
  '080-5519466',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปุญญิสา' AND m.lastName = 'ปงลังกา'
  )
LIMIT 1;
-- แถว 404: นางสาวหนึ่งฤทัย  สุทธสม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf0g0j1ftfmqu',
  'M00404',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหนึ่งฤทัย',
  'สุทธสม',
  '088-9658379',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหนึ่งฤทัย' AND m.lastName = 'สุทธสม'
  )
LIMIT 1;
-- แถว 405: นายคามิน  คีรีอยู่ลือ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfadj355j0a9u',
  'M00405',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคามิน',
  'คีรีอยู่ลือ',
  '098-4097071',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคามิน' AND m.lastName = 'คีรีอยู่ลือ'
  )
LIMIT 1;
-- แถว 406: นายชัญญานุช  โพธิ์เงิน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfapfisu28c6g',
  'M00406',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชัญญานุช',
  'โพธิ์เงิน',
  '082-4044326',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชัญญานุช' AND m.lastName = 'โพธิ์เงิน'
  )
LIMIT 1;
-- แถว 407: นางสาวรัชนี สุทธิประภา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfu21dlx22m0n',
  'M00407',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัชนี',
  'สุทธิประภา',
  '087-8500503',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัชนี' AND m.lastName = 'สุทธิประภา'
  )
LIMIT 1;
-- แถว 408: นายเชนร์   อุดอ้าย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfkadw17a46i',
  'M00408',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเชนร์',
  'อุดอ้าย',
  '081-1119039',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเชนร์' AND m.lastName = 'อุดอ้าย'
  )
LIMIT 1;
-- แถว 409: นายศิวกร  มูลละ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9pxziuyuavl',
  'M00409',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศิวกร',
  'มูลละ',
  '091-8089098',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศิวกร' AND m.lastName = 'มูลละ'
  )
LIMIT 1;
-- แถว 410: นางสาวชนันท์ธิดา  สิริวสุพงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfey5gzbsw9l',
  'M00410',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชนันท์ธิดา',
  'สิริวสุพงศ์',
  '085-7210100',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชนันท์ธิดา' AND m.lastName = 'สิริวสุพงศ์'
  )
LIMIT 1;
-- แถว 411: นางสาวเนตรนภัทร  แก้วแดง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfvkk3i2dy24a',
  'M00411',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเนตรนภัทร',
  'แก้วแดง',
  '097-1211162',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเนตรนภัทร' AND m.lastName = 'แก้วแดง'
  )
LIMIT 1;
-- แถว 412: นายภูบดินทร์  อินรส | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf8a2etwhzfb6',
  'M00412',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภูบดินทร์',
  'อินรส',
  '084-3638896',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภูบดินทร์' AND m.lastName = 'อินรส'
  )
LIMIT 1;
-- แถว 413: นางสาวกัญญารัตน์  ยะกับ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7z2a6p04fpq',
  'M00413',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญญารัตน์',
  'ยะกับ',
  '088-4137508',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญญารัตน์' AND m.lastName = 'ยะกับ'
  )
LIMIT 1;
-- แถว 414: นางสาวกัญญารัตน์  วงศ์หลวง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfib6in6klxm',
  'M00414',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญญารัตน์',
  'วงศ์หลวง',
  '096 - 5298809',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญญารัตน์' AND m.lastName = 'วงศ์หลวง'
  )
LIMIT 1;
-- แถว 415: นายจิรายุทธ  ศรีคำเทียม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfynxela0faar',
  'M00415',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิรายุทธ',
  'ศรีคำเทียม',
  '096-2496238',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิรายุทธ' AND m.lastName = 'ศรีคำเทียม'
  )
LIMIT 1;
-- แถว 416: นางสาวรุ้งทราย  ลูนปัน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf7ef9otz99iu',
  'M00416',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรุ้งทราย',
  'ลูนปัน',
  '082-1601810',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรุ้งทราย' AND m.lastName = 'ลูนปัน'
  )
LIMIT 1;
-- แถว 417: นางสาวกัญจนพร  อภัยกาวี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfyn4hzyq917',
  'M00417',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญจนพร',
  'อภัยกาวี',
  '084-6113901',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญจนพร' AND m.lastName = 'อภัยกาวี'
  )
LIMIT 1;
-- แถว 418: นางสาวพิมพ์พิจิตร ศรีสงค์ใจ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfkco2sbzguw',
  'M00418',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์พิจิตร',
  'ศรีสงค์ใจ',
  '082-3855528',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์พิจิตร' AND m.lastName = 'ศรีสงค์ใจ'
  )
LIMIT 1;
-- แถว 419: นางสาวรติมา  ภาวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3skjhsvme8w',
  'M00419',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรติมา',
  'ภาวงศ์',
  '087-6586388',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรติมา' AND m.lastName = 'ภาวงศ์'
  )
LIMIT 1;
-- แถว 420: นายศุภกฤต  อภิไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfaef8noy35je',
  'M00420',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศุภกฤต',
  'อภิไชย',
  '082-4839323',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศุภกฤต' AND m.lastName = 'อภิไชย'
  )
LIMIT 1;
-- แถว 421: นางสาวรุ่งทิวา  กาศมณี | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfyonwjc06b6',
  'M00421',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรุ่งทิวา',
  'กาศมณี',
  '087-3593592',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรุ่งทิวา' AND m.lastName = 'กาศมณี'
  )
LIMIT 1;
-- แถว 422: นางสาวศิรินันท์ อรัญวาส | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfx1uwikenygr',
  'M00422',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิรินันท์',
  'อรัญวาส',
  '093-2752375',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิรินันท์' AND m.lastName = 'อรัญวาส'
  )
LIMIT 1;
-- แถว 423: นางสาวชลิดา  ปินคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf3z0o97t9dqf',
  'M00423',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชลิดา',
  'ปินคำ',
  '087-3593315',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชลิดา' AND m.lastName = 'ปินคำ'
  )
LIMIT 1;
-- แถว 424: นางสาวพุทธกาล บัณฑิตเทอดสกุล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfjxtfclbm3w',
  'M00424',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพุทธกาล',
  'บัณฑิตเทอดสกุล',
  '093-1530774',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพุทธกาล' AND m.lastName = 'บัณฑิตเทอดสกุล'
  )
LIMIT 1;
-- แถว 425: นายยชญ์วิวรรธน์  ชมภูชนะภัย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpkbgheudusg',
  'M00425',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยชญ์วิวรรธน์',
  'ชมภูชนะภัย',
  '062-3790096',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยชญ์วิวรรธน์' AND m.lastName = 'ชมภูชนะภัย'
  )
LIMIT 1;
-- แถว 426: นายณัฐวัฒน์  ภูริธิติมา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfpvkneo9vxcr',
  'M00426',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐวัฒน์',
  'ภูริธิติมา',
  '097-9539821',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐวัฒน์' AND m.lastName = 'ภูริธิติมา'
  )
LIMIT 1;
-- แถว 427: นายณัฐพล  วัฒนาชัยมงคล | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfz88gt3xib7',
  'M00427',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐพล',
  'วัฒนาชัยมงคล',
  '089-8531344',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐพล' AND m.lastName = 'วัฒนาชัยมงคล'
  )
LIMIT 1;
-- แถว 428: นายสัภยา  ตาลำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfny6to2tkwhe',
  'M00428',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสัภยา',
  'ตาลำ',
  '097-9238579',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสัภยา' AND m.lastName = 'ตาลำ'
  )
LIMIT 1;
-- แถว 429: นางสาวศรัณย์ธร สังข์เมือง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfv3tzswjtzj',
  'M00429',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศรัณย์ธร',
  'สังข์เมือง',
  '095-2342389',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศรัณย์ธร' AND m.lastName = 'สังข์เมือง'
  )
LIMIT 1;
-- แถว 430: นางสาวจิราพร  ระคาไพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfznsd22rgg2g',
  'M00430',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิราพร',
  'ระคาไพ',
  '093-3083925',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิราพร' AND m.lastName = 'ระคาไพ'
  )
LIMIT 1;
-- แถว 431: นางสาวกฤษณา ธรรมศร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntfns8faek6z8d',
  'M00431',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกฤษณา',
  'ธรรมศร',
  '094-6250412',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกฤษณา' AND m.lastName = 'ธรรมศร'
  )
LIMIT 1;
-- แถว 432: นางสาวรัญชิดา  พรมมินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntf9q9mlxzymvu',
  'M00432',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัญชิดา',
  'พรมมินทร์',
  '098-5854171',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัญชิดา' AND m.lastName = 'พรมมินทร์'
  )
LIMIT 1;
-- แถว 433: นางสาววาริกา  แดนช่างคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntghmv7x0jhosc',
  'M00433',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววาริกา',
  'แดนช่างคำ',
  '093-9100030',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววาริกา' AND m.lastName = 'แดนช่างคำ'
  )
LIMIT 1;
-- แถว 434: นางสาวจุฑามาศ  ไชยพูน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgbojfecjp0lj',
  'M00434',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจุฑามาศ',
  'ไชยพูน',
  '065-4341799',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจุฑามาศ' AND m.lastName = 'ไชยพูน'
  )
LIMIT 1;
-- แถว 435: นางสาวยลลดา  สารบัว | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg6ga8c7mv9dm',
  'M00435',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวยลลดา',
  'สารบัว',
  '062-3097516',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวยลลดา' AND m.lastName = 'สารบัว'
  )
LIMIT 1;
-- แถว 436: นางสาวรัฐพร  หมั่นแสวง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgc4gdlz4pcvg',
  'M00436',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัฐพร',
  'หมั่นแสวง',
  '084-0435968',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัฐพร' AND m.lastName = 'หมั่นแสวง'
  )
LIMIT 1;
-- แถว 437: นางสาวศุภลักษณ์  โพธิ์ทองพร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgtbzz48wwemm',
  'M00437',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศุภลักษณ์',
  'โพธิ์ทองพร',
  '099-1415093',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศุภลักษณ์' AND m.lastName = 'โพธิ์ทองพร'
  )
LIMIT 1;
-- แถว 438: นางสาวณัฐธิชา ศรีเพชร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgypdaxd2oar9',
  'M00438',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐธิชา',
  'ศรีเพชร',
  '062-0347251',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐธิชา' AND m.lastName = 'ศรีเพชร'
  )
LIMIT 1;
-- แถว 439: นางสาวนภัสสร  คำลือ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg8j2qhdnknj',
  'M00439',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนภัสสร',
  'คำลือ',
  '095-4521619',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนภัสสร' AND m.lastName = 'คำลือ'
  )
LIMIT 1;
-- แถว 440: นางสาวชลลดา  แข่งขัน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfcn9qzjqy6',
  'M00440',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชลลดา',
  'แข่งขัน',
  '095-1867266',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชลลดา' AND m.lastName = 'แข่งขัน'
  )
LIMIT 1;
-- แถว 441: นางสาวจันทิมา  รอบรู้ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg1gbu5ub5mfz',
  'M00441',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจันทิมา',
  'รอบรู้',
  '084-3678991',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจันทิมา' AND m.lastName = 'รอบรู้'
  )
LIMIT 1;
-- แถว 442: นายธัชกร  ปัญญาอินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmrmp8d9bw1',
  'M00442',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธัชกร',
  'ปัญญาอินทร์',
  '091-4824232',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธัชกร' AND m.lastName = 'ปัญญาอินทร์'
  )
LIMIT 1;
-- แถว 443: นางสาวสกาวเดือน  งามพิง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg1wx09mrwuwm',
  'M00443',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสกาวเดือน',
  'งามพิง',
  '098-6720717',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสกาวเดือน' AND m.lastName = 'งามพิง'
  )
LIMIT 1;
-- แถว 444: นางสาวเสาวนีย์  นามอ้าย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgn4ldfk1uut',
  'M00444',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเสาวนีย์',
  'นามอ้าย',
  '088-5991930',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเสาวนีย์' AND m.lastName = 'นามอ้าย'
  )
LIMIT 1;
-- แถว 445: นางสาวสุพัตรา  ฉางข้าวไชย | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgkyjektz1vor',
  'M00445',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุพัตรา',
  'ฉางข้าวไชย',
  '095-9765687',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุพัตรา' AND m.lastName = 'ฉางข้าวไชย'
  )
LIMIT 1;
-- แถว 446: นางสาวหนึ่งฤทัย  พนาแสนใจ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgsap5gdat1xa',
  'M00446',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหนึ่งฤทัย',
  'พนาแสนใจ',
  '097-9242108',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหนึ่งฤทัย' AND m.lastName = 'พนาแสนใจ'
  )
LIMIT 1;
-- แถว 447: นางสาววราพร  สุยะ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjx2u4z3w1ga',
  'M00447',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววราพร',
  'สุยะ',
  '063-7848586',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววราพร' AND m.lastName = 'สุยะ'
  )
LIMIT 1;
-- แถว 448: นายจักรพงษ์  ติ๊บเหล็ก | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqrkr2zk3chf',
  'M00448',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจักรพงษ์',
  'ติ๊บเหล็ก',
  '088-5789492',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจักรพงษ์' AND m.lastName = 'ติ๊บเหล็ก'
  )
LIMIT 1;
-- แถว 449: นายรัฐพล  คำพงษ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmfp05xmekj8',
  'M00449',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายรัฐพล',
  'คำพงษ์',
  '087-3599828',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายรัฐพล' AND m.lastName = 'คำพงษ์'
  )
LIMIT 1;
-- แถว 450: นางสาวจุฑานาถ  ทองล้วน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnnccxuvhug',
  'M00450',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจุฑานาถ',
  'ทองล้วน',
  '093-1611796',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจุฑานาถ' AND m.lastName = 'ทองล้วน'
  )
LIMIT 1;
-- แถว 451: นางสาวณิชกานต์  ดีคำ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgc4rmpmq79kr',
  'M00451',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณิชกานต์',
  'ดีคำ',
  '096-2876432',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณิชกานต์' AND m.lastName = 'ดีคำ'
  )
LIMIT 1;
-- แถว 452: นายเอกรัตน์  อายุยืน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgbvimnay501e',
  'M00452',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกรัตน์',
  'อายุยืน',
  '095-2949470',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกรัตน์' AND m.lastName = 'อายุยืน'
  )
LIMIT 1;
-- แถว 453: นางสาววรรณวิสา  กันทา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmigslwqkubr',
  'M00453',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรณวิสา',
  'กันทา',
  '082-5301310',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรณวิสา' AND m.lastName = 'กันทา'
  )
LIMIT 1;
-- แถว 454: นายจักรรินทร์    โฆษิตมุธากร | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgvzd7sy11tz',
  'M00454',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจักรรินทร์',
  'โฆษิตมุธากร',
  '093-1349014',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจักรรินทร์' AND m.lastName = 'โฆษิตมุธากร'
  )
LIMIT 1;
-- แถว 455: นางสางธัญธิญาพร  ก๋องแก้ว | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgig0q60zaeb',
  'M00455',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสางธัญธิญาพร',
  'ก๋องแก้ว',
  '061-3215181',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสางธัญธิญาพร' AND m.lastName = 'ก๋องแก้ว'
  )
LIMIT 1;
-- แถว 456: นางสาวสุชัญญา  ทาทอง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg58emuq19ahs',
  'M00456',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชัญญา',
  'ทาทอง',
  '064-5169867',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชัญญา' AND m.lastName = 'ทาทอง'
  )
LIMIT 1;
-- แถว 457: นายนัทธพงศ์  ยศวงศ์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg3zprmacos5i',
  'M00457',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนัทธพงศ์',
  'ยศวงศ์',
  '098-4197698',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนัทธพงศ์' AND m.lastName = 'ยศวงศ์'
  )
LIMIT 1;
-- แถว 458: นางสาวประพิมพ์พร  แก้วมาเมือง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnzw3ag406ai',
  'M00458',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวประพิมพ์พร',
  'แก้วมาเมือง',
  '082-1854015',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวประพิมพ์พร' AND m.lastName = 'แก้วมาเมือง'
  )
LIMIT 1;
-- แถว 459: นางสาวกนกวรรณ  ธีรโฆษิต | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7zet880wumt',
  'M00459',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกวรรณ',
  'ธีรโฆษิต',
  '095-6754401',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกวรรณ' AND m.lastName = 'ธีรโฆษิต'
  )
LIMIT 1;
-- แถว 460: นายนิธิรัตน์   สุดสม | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg5nf4ov82cs',
  'M00460',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนิธิรัตน์',
  'สุดสม',
  '064-0689008',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนิธิรัตน์' AND m.lastName = 'สุดสม'
  )
LIMIT 1;
-- แถว 461: นางสาวเสาวลักษณ์  บานเย็น | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgbfd5k0apfqe',
  'M00461',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเสาวลักษณ์',
  'บานเย็น',
  '098-7741335',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเสาวลักษณ์' AND m.lastName = 'บานเย็น'
  )
LIMIT 1;
-- แถว 462: นางสาวมาลิสา  คำเงิน | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg277co1jqa3s',
  'M00462',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมาลิสา',
  'คำเงิน',
  '082-3852997',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมาลิสา' AND m.lastName = 'คำเงิน'
  )
LIMIT 1;
-- แถว 463: นายวิสาร  โลบันลือภพ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgn0y2hq4cnur',
  'M00463',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวิสาร',
  'โลบันลือภพ',
  '096-3452163',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวิสาร' AND m.lastName = 'โลบันลือภพ'
  )
LIMIT 1;
-- แถว 464: นางสาวจารุวรรณ  แซ่ฟุ้ง | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgwxftug17ff9',
  'M00464',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'แซ่ฟุ้ง',
  '096-0763293',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'แซ่ฟุ้ง'
  )
LIMIT 1;
-- แถว 465: นางสาวศศิธร  เชียวตา | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgydrw1ebc14j',
  'M00465',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศศิธร',
  'เชียวตา',
  '098-3936698',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศศิธร' AND m.lastName = 'เชียวตา'
  )
LIMIT 1;
-- แถว 466: นายศราวุฒิ   ฝั้นก๋า | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg9lha2gu10t9',
  'M00466',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศราวุฒิ',
  'ฝั้นก๋า',
  '082-7818713',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศราวุฒิ' AND m.lastName = 'ฝั้นก๋า'
  )
LIMIT 1;
-- แถว 467: นายจิรวัฒน์  วงศ์ประเสริฐ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxc1r7uv3lr',
  'M00467',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิรวัฒน์',
  'วงศ์ประเสริฐ',
  '093 - 5456470',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิรวัฒน์' AND m.lastName = 'วงศ์ประเสริฐ'
  )
LIMIT 1;
-- แถว 468: นางสาวมณีวรรณ  คันธวังอินทร์ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgn4g30rw4wpn',
  'M00468',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมณีวรรณ',
  'คันธวังอินทร์',
  '098-7626563',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมณีวรรณ' AND m.lastName = 'คันธวังอินทร์'
  )
LIMIT 1;
-- แถว 469: นางกษมา  ทองสุวรรณ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnfxwlmzzt5h',
  'M00469',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกษมา',
  'ทองสุวรรณ',
  '061-8939459',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกษมา' AND m.lastName = 'ทองสุวรรณ'
  )
LIMIT 1;
-- แถว 470: นางสาวศรีวรรณ   ปอแฉ่ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2xrb7ha5h7m',
  'M00470',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศรีวรรณ',
  'ปอแฉ่',
  '080-5020642',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศรีวรรณ' AND m.lastName = 'ปอแฉ่'
  )
LIMIT 1;
-- แถว 471: นายยี่  คำอู๋ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7xktqv3kcsg',
  'M00471',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยี่',
  'คำอู๋',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยี่' AND m.lastName = 'คำอู๋'
  )
LIMIT 1;
-- แถว 472: นายแสง บุญธีราโชติ | โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgzdl47eljga',
  'M00472',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายแสง',
  'บุญธีราโชติ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_018_บ้านเทอดไทย_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านเทอดไทย  กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายแสง' AND m.lastName = 'บุญธีราโชติ'
  )
LIMIT 1;
-- แถว 473: นายชัชวาลย์ ใจอินทร์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg9npbycgc9f',
  'M00473',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชัชวาลย์',
  'ใจอินทร์',
  '084-1768959',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชัชวาลย์' AND m.lastName = 'ใจอินทร์'
  )
LIMIT 1;
-- แถว 474: นายสุริยา วงษ์ตา | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgv4brag08zog',
  'M00474',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุริยา',
  'วงษ์ตา',
  '093-2912629',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุริยา' AND m.lastName = 'วงษ์ตา'
  )
LIMIT 1;
-- แถว 475: นางสาวเบญจพร พันธะเกษม | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgckqzy4hbho',
  'M00475',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเบญจพร',
  'พันธะเกษม',
  '087-6561310',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเบญจพร' AND m.lastName = 'พันธะเกษม'
  )
LIMIT 1;
-- แถว 476: นายกิตติพงษ์ ไชยลังการ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg4c74n1naysg',
  'M00476',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกิตติพงษ์',
  'ไชยลังการ',
  '093-1370151',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกิตติพงษ์' AND m.lastName = 'ไชยลังการ'
  )
LIMIT 1;
-- แถว 477: นางสาวอัจรียา นนท์ศรี | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2xtj58sorlg',
  'M00477',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัจรียา',
  'นนท์ศรี',
  '063-9808306',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัจรียา' AND m.lastName = 'นนท์ศรี'
  )
LIMIT 1;
-- แถว 478: นางสาวจุฑารัตน์ คันทะเสน | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgax2hm6orl95',
  'M00478',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจุฑารัตน์',
  'คันทะเสน',
  '086-3686080',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจุฑารัตน์' AND m.lastName = 'คันทะเสน'
  )
LIMIT 1;
-- แถว 479: นางสาวเนตรนภา เชื้อหมอ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntghrosojn38mc',
  'M00479',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเนตรนภา',
  'เชื้อหมอ',
  '097-2391601',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเนตรนภา' AND m.lastName = 'เชื้อหมอ'
  )
LIMIT 1;
-- แถว 480: นางสาวเมธาวี ขัติพรหม | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfadmdm2nkd',
  'M00480',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเมธาวี',
  'ขัติพรหม',
  '093-2798273',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเมธาวี' AND m.lastName = 'ขัติพรหม'
  )
LIMIT 1;
-- แถว 481: นางสาวธิติยา ลก | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfp91jhwwgy',
  'M00481',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธิติยา',
  'ลก',
  '096-8649139',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธิติยา' AND m.lastName = 'ลก'
  )
LIMIT 1;
-- แถว 482: นางสาวชินาทร บัวแดง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmgnw4sq5jci',
  'M00482',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชินาทร',
  'บัวแดง',
  '090-3198085',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชินาทร' AND m.lastName = 'บัวแดง'
  )
LIMIT 1;
-- แถว 483: นายเนติพงศ์ เสาร์จันทร์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq0diwjqz48g',
  'M00483',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเนติพงศ์',
  'เสาร์จันทร์',
  '064-9832103',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเนติพงศ์' AND m.lastName = 'เสาร์จันทร์'
  )
LIMIT 1;
-- แถว 484: นายอนุชิต ตันวงค์ษา | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgc2cgl2ufuzq',
  'M00484',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอนุชิต',
  'ตันวงค์ษา',
  '087-6600953',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอนุชิต' AND m.lastName = 'ตันวงค์ษา'
  )
LIMIT 1;
-- แถว 485: นางสาววรรณวลี ดิถีเพ็ง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgrdoemp9raie',
  'M00485',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรณวลี',
  'ดิถีเพ็ง',
  '064-0976548',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรณวลี' AND m.lastName = 'ดิถีเพ็ง'
  )
LIMIT 1;
-- แถว 486: นายชุติพนธ์ สมบูรณ์วงษ์ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqw2vau5ph2e',
  'M00486',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชุติพนธ์',
  'สมบูรณ์วงษ์',
  '062-3975171',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชุติพนธ์' AND m.lastName = 'สมบูรณ์วงษ์'
  )
LIMIT 1;
-- แถว 487: นายภาณุพงศ์ กาสอน | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgsqooyvkq2a',
  'M00487',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภาณุพงศ์',
  'กาสอน',
  '095-5677288',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภาณุพงศ์' AND m.lastName = 'กาสอน'
  )
LIMIT 1;
-- แถว 488: นางสาวภัสปชธร แสนเป็ง | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjlyw4ne3n1',
  'M00488',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัสปชธร',
  'แสนเป็ง',
  '095-9470659',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัสปชธร' AND m.lastName = 'แสนเป็ง'
  )
LIMIT 1;
-- แถว 489: นางสาวพัชรินธรณ์ รวมสุข | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnpi26ahsf6q',
  'M00489',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัชรินธรณ์',
  'รวมสุข',
  '080-0590433',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัชรินธรณ์' AND m.lastName = 'รวมสุข'
  )
LIMIT 1;
-- แถว 490: นางสาวเปมิกา เมอแล | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntghj51fgwjulb',
  'M00490',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเปมิกา',
  'เมอแล',
  '097-9937905',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเปมิกา' AND m.lastName = 'เมอแล'
  )
LIMIT 1;
-- แถว 491: นางสาวอำพร แลเชอะ | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntge1qbduyrbsf',
  'M00491',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอำพร',
  'แลเชอะ',
  '093-1137875',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอำพร' AND m.lastName = 'แลเชอะ'
  )
LIMIT 1;
-- แถว 492: นายจะแฮ มูยี | โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgaugtf610t1g',
  'M00492',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจะแฮ',
  'มูยี',
  '097-9929437',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_019_บ้านจะตี_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านจะตี  กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจะแฮ' AND m.lastName = 'มูยี'
  )
LIMIT 1;
-- แถว 493: นายสุขสันต์  สอนนวล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgy81tp2t0nil',
  'M00493',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุขสันต์',
  'สอนนวล',
  '081-2771948',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุขสันต์' AND m.lastName = 'สอนนวล'
  )
LIMIT 1;
-- แถว 494: นางสาวปรียนันท์ ทิพากร | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqsw77prtyy',
  'M00494',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปรียนันท์',
  'ทิพากร',
  '089-8501524',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปรียนันท์' AND m.lastName = 'ทิพากร'
  )
LIMIT 1;
-- แถว 495: นายขวัญชัย  โกแสนตอ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq2f83z8qh5n',
  'M00495',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายขวัญชัย',
  'โกแสนตอ',
  '080-1201701',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายขวัญชัย' AND m.lastName = 'โกแสนตอ'
  )
LIMIT 1;
-- แถว 496: นายชานนท์  จันต๊ะคาด | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgu21p81sv129',
  'M00496',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชานนท์',
  'จันต๊ะคาด',
  '087-1939121',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชานนท์' AND m.lastName = 'จันต๊ะคาด'
  )
LIMIT 1;
-- แถว 497: นางรพีพรรณ  มาลารัตน์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgem3ctaz0i0u',
  'M00497',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางรพีพรรณ',
  'มาลารัตน์',
  '882350984',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางรพีพรรณ' AND m.lastName = 'มาลารัตน์'
  )
LIMIT 1;
-- แถว 498: นางสาวภัณฑิรา  เมืองปัญโญ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgr6mp6jtzo9e',
  'M00498',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัณฑิรา',
  'เมืองปัญโญ',
  '062-3606360',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัณฑิรา' AND m.lastName = 'เมืองปัญโญ'
  )
LIMIT 1;
-- แถว 499: นายชาญณรงค์  โลดแจ้ง | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgpbxrtj5ngjm',
  'M00499',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชาญณรงค์',
  'โลดแจ้ง',
  '095-9646886',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชาญณรงค์' AND m.lastName = 'โลดแจ้ง'
  )
LIMIT 1;
-- แถว 500: ว่าที่ ร.ต.หญิงวิจิตรา  เย็นจิตต์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfl14p3l05db',
  'M00500',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่',
  'ร.ต.หญิงวิจิตรา เย็นจิตต์',
  '095-8706560',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่' AND m.lastName = 'ร.ต.หญิงวิจิตรา เย็นจิตต์'
  )
LIMIT 1;
-- แถว 501: นางสาวมาลินี ดอนมูล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgd2v7dvqa2uk',
  'M00501',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมาลินี',
  'ดอนมูล',
  '064-5052248',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมาลินี' AND m.lastName = 'ดอนมูล'
  )
LIMIT 1;
-- แถว 502: นายสุรศักดิ์  เนตรทิพย์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgcxa4lgv5hla',
  'M00502',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรศักดิ์',
  'เนตรทิพย์',
  '081-0297031',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรศักดิ์' AND m.lastName = 'เนตรทิพย์'
  )
LIMIT 1;
-- แถว 503: นางสาวศุภกานต์ ชื่นจิต | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg51fwnbk93wt',
  'M00503',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศุภกานต์',
  'ชื่นจิต',
  '080-1265649',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศุภกานต์' AND m.lastName = 'ชื่นจิต'
  )
LIMIT 1;
-- แถว 504: นางสาวอรปรียา  กาแก้ว | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgr0rlgprxwf',
  'M00504',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรปรียา',
  'กาแก้ว',
  '088-4092760',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรปรียา' AND m.lastName = 'กาแก้ว'
  )
LIMIT 1;
-- แถว 505: นางสาวนิลาวรรณ สายพรหม | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgh13mia0pu6',
  'M00505',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิลาวรรณ',
  'สายพรหม',
  '098-1962334',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิลาวรรณ' AND m.lastName = 'สายพรหม'
  )
LIMIT 1;
-- แถว 506: นายจารุกิตติ์ ยิ่งสมบูรณ์ชัย | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg3ujp1mg7q33',
  'M00506',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจารุกิตติ์',
  'ยิ่งสมบูรณ์ชัย',
  '063-1862235',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจารุกิตติ์' AND m.lastName = 'ยิ่งสมบูรณ์ชัย'
  )
LIMIT 1;
-- แถว 507: นายเอกพงศ์  ใจต๊ะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgubi6fbxm2d',
  'M00507',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกพงศ์',
  'ใจต๊ะ',
  '093-0517458',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกพงศ์' AND m.lastName = 'ใจต๊ะ'
  )
LIMIT 1;
-- แถว 508: นายชัชพล  ลำดวน | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgzml4tz5vsig',
  'M00508',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชัชพล',
  'ลำดวน',
  '062-3579987',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชัชพล' AND m.lastName = 'ลำดวน'
  )
LIMIT 1;
-- แถว 509: นางสาวกัญญาวีร์  เวียงมูล | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg0mp4m4t5ig8e',
  'M00509',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญญาวีร์',
  'เวียงมูล',
  '082-7815307',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญญาวีร์' AND m.lastName = 'เวียงมูล'
  )
LIMIT 1;
-- แถว 510: นายปฏิภาณ สมฟองทอง | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgsd6gq3rpn79',
  'M00510',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายปฏิภาณ',
  'สมฟองทอง',
  '098-5164323',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายปฏิภาณ' AND m.lastName = 'สมฟองทอง'
  )
LIMIT 1;
-- แถว 511: นายณัฐพล  เหม็งทะเหล็ก | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgb5es96z0klc',
  'M00511',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐพล',
  'เหม็งทะเหล็ก',
  '088-6587110',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐพล' AND m.lastName = 'เหม็งทะเหล็ก'
  )
LIMIT 1;
-- แถว 512: นางสาวฐิตาภรณ์ สายอิ่นแก้ว | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgtdw0tbf7at',
  'M00512',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฐิตาภรณ์',
  'สายอิ่นแก้ว',
  '063-7272518',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฐิตาภรณ์' AND m.lastName = 'สายอิ่นแก้ว'
  )
LIMIT 1;
-- แถว 513: นายกรกฎ โรจนนิจ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgdy455ijzk7q',
  'M00513',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกรกฎ',
  'โรจนนิจ',
  '095-8064029',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกรกฎ' AND m.lastName = 'โรจนนิจ'
  )
LIMIT 1;
-- แถว 514: นางสาวศิรินกรณ์  สุยะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7a991qwms4w',
  'M00514',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิรินกรณ์',
  'สุยะ',
  '061-2850050',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิรินกรณ์' AND m.lastName = 'สุยะ'
  )
LIMIT 1;
-- แถว 515: นางสาวสุจินดา ใจกล้า | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg04z7xtoimh6',
  'M00515',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุจินดา',
  'ใจกล้า',
  '087-5774566',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุจินดา' AND m.lastName = 'ใจกล้า'
  )
LIMIT 1;
-- แถว 516: นายพุฒิชัย  ไฝเครือ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntge2lpdtm5xu',
  'M00516',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพุฒิชัย',
  'ไฝเครือ',
  '086-4308642',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพุฒิชัย' AND m.lastName = 'ไฝเครือ'
  )
LIMIT 1;
-- แถว 517: นายภาณุพงค์  ยาจันทร์ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgsx2viaq705',
  'M00517',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภาณุพงค์',
  'ยาจันทร์',
  '095-2427771',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภาณุพงค์' AND m.lastName = 'ยาจันทร์'
  )
LIMIT 1;
-- แถว 518: นายฉัตรดนัย  ใยญาติ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgui4z9o0z3rp',
  'M00518',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฉัตรดนัย',
  'ใยญาติ',
  '085-8789838',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฉัตรดนัย' AND m.lastName = 'ใยญาติ'
  )
LIMIT 1;
-- แถว 519: นายเลอพงษ์  ปัญญาดี | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2cqc24mmu6x',
  'M00519',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเลอพงษ์',
  'ปัญญาดี',
  '087-1878403',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเลอพงษ์' AND m.lastName = 'ปัญญาดี'
  )
LIMIT 1;
-- แถว 520: นางสาวจารุวรรณ กันทะ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg6jdxuo7jvh4',
  'M00520',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'กันทะ',
  '080-6029200',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'กันทะ'
  )
LIMIT 1;
-- แถว 521: นายจายแสง  มอญคำ | โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgcwp1qke74n',
  'M00521',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจายแสง',
  'มอญคำ',
  '081-1611905',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_020_บ้านพญาไพร_กลุ่มเครื' OR s.name = 'โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเทอดไทย' OR s.name LIKE '%โรงเรียนบ้านพญาไพร   กลุ่มเครือข่ายพัฒนาการศึกษาเท%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจายแสง' AND m.lastName = 'มอญคำ'
  )
LIMIT 1;
-- แถว 522: นายบรรหาญ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntge5iqe69cmxe',
  'M00522',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายบรรหาญ',
  '—',
  'ผู้อำนวยการโรงเรียน',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายบรรหาญ' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 523: นางสาวพิมพ์พิชมญชุ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgivwidm82m9a',
  'M00523',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์พิชมญชุ์',
  '—',
  'ครูชำนาญการ',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์พิชมญชุ์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 524: นางสาวอัญชลี | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgvwpji1q0d88',
  'M00524',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัญชลี',
  '—',
  'ครูชำนาญการ',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัญชลี' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 525: นางสาวชไมพร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg9rwe09yiz8',
  'M00525',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชไมพร',
  '—',
  'ครูชำนาญการ',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชไมพร' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 526: นางสาวสุพิชชา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgk5bs29ax2vs',
  'M00526',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุพิชชา',
  '—',
  'ครูชำนาญการ',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุพิชชา' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 527: นายสมรัตชัย | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg12agxiv9we8s',
  'M00527',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมรัตชัย',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมรัตชัย' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 528: นางสาวจันทรา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntggzokp90kt9q',
  'M00528',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจันทรา',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจันทรา' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 529: นางสาวพรอภิมล | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgf0qxudw70z',
  'M00529',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพรอภิมล',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพรอภิมล' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 530: นางสาวสโรชา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjp1dcek23o9',
  'M00530',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสโรชา',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสโรชา' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 531: นางสาวสุรีย์รัตน์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgpxssfofo3bn',
  'M00531',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุรีย์รัตน์',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุรีย์รัตน์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 532: นายจักรกฤษณ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgl2eviqil2d',
  'M00532',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจักรกฤษณ์',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจักรกฤษณ์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 533: นายวรรณ์ธนัย | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq06zdlum39c',
  'M00533',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวรรณ์ธนัย',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวรรณ์ธนัย' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 534: นางสาวสิริยากร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7e98exjr5w9',
  'M00534',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิริยากร',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิริยากร' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 535: นางสาวลัดดาวัลย์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7387tmiewau',
  'M00535',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวลัดดาวัลย์',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวลัดดาวัลย์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 536: นายนิคม | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnpwmwyr64hb',
  'M00536',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนิคม',
  '—',
  'ครู',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนิคม' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 537: นางสาวณัจฉรียา | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgozeab2ycfe',
  'M00537',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัจฉรียา',
  '—',
  'ครูผู้ช่วย',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัจฉรียา' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 538: นายวีระพงษ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgojzlam001l',
  'M00538',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวีระพงษ์',
  '—',
  'ครูผู้ช่วย',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวีระพงษ์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 539: นายกิตติพงษ์ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgi394haif0mh',
  'M00539',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายกิตติพงษ์',
  '—',
  'ครูผู้ช่วย',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายกิตติพงษ์' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 540: นางสาวชโลทร | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxaqekp9bm5d',
  'M00540',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชโลทร',
  '—',
  'ครูผู้ช่วย',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชโลทร' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 541: นางนายยาแบ | โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgiftib78z8z',
  'M00541',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางนายยาแบ',
  '—',
  'นักการภารโรง',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_021_บ้านกลาง_กลุ่มเครือข' OR s.name = 'โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านกลาง   กลุ่มเครือข่ายพัฒนาการศึกษาดอยแ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางนายยาแบ' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 542: นายสมคิด อนุเคราะห์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg182q3va7gyg',
  'M00542',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมคิด',
  'อนุเคราะห์',
  '090-3320944',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมคิด' AND m.lastName = 'อนุเคราะห์'
  )
LIMIT 1;
-- แถว 543: นายศรายุทธ อุ่นใจ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg18onf3vrtms',
  'M00543',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศรายุทธ',
  'อุ่นใจ',
  '095-2412225',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศรายุทธ' AND m.lastName = 'อุ่นใจ'
  )
LIMIT 1;
-- แถว 544: นายจิตอิสรภาพ ใจอารีย์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgcc1ur1osdw7',
  'M00544',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิตอิสรภาพ',
  'ใจอารีย์',
  '097-9472832',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิตอิสรภาพ' AND m.lastName = 'ใจอารีย์'
  )
LIMIT 1;
-- แถว 545: นายชญตว์ ปานนับร้อย | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntguncypuhnze',
  'M00545',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชญตว์',
  'ปานนับร้อย',
  '089-7011404',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชญตว์' AND m.lastName = 'ปานนับร้อย'
  )
LIMIT 1;
-- แถว 546: นางสาวเกศรา อินตาพรม | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgj7l4xfrtfcj',
  'M00546',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกศรา',
  'อินตาพรม',
  '091-0784225',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกศรา' AND m.lastName = 'อินตาพรม'
  )
LIMIT 1;
-- แถว 547: นางสาวมุกดา วารีขจร | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgseqgzb18g2r',
  'M00547',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมุกดา',
  'วารีขจร',
  '082-9764261',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมุกดา' AND m.lastName = 'วารีขจร'
  )
LIMIT 1;
-- แถว 548: นางสาววิรรณ อย่างวรโชติ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxv4fd69loc',
  'M00548',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิรรณ',
  'อย่างวรโชติ',
  '090-4731329',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิรรณ' AND m.lastName = 'อย่างวรโชติ'
  )
LIMIT 1;
-- แถว 549: นางสาวมาติกา จิระณชานนท์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgt0mdy02ygaf',
  'M00549',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมาติกา',
  'จิระณชานนท์',
  '096-2596616',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมาติกา' AND m.lastName = 'จิระณชานนท์'
  )
LIMIT 1;
-- แถว 550: นางสาวริศรา กรสวรรค์ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg5uz1049wp0u',
  'M00550',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวริศรา',
  'กรสวรรค์',
  '096-3723135',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวริศรา' AND m.lastName = 'กรสวรรค์'
  )
LIMIT 1;
-- แถว 551: นางสาวหมี่ซาง มาเยอะ | โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntge1t4gibvjns',
  'M00551',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหมี่ซาง',
  'มาเยอะ',
  '089-8527465',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_022_บ้านพนาสวรรค์_กลุ่มเ' OR s.name = 'โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านพนาสวรรค์ กลุ่มเครือข่ายพัฒนาการศึกษาด%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหมี่ซาง' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 552: นายศิวนาถ  ประสาวะถา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgk11f47q9ruc',
  'M00552',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศิวนาถ',
  'ประสาวะถา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศิวนาถ' AND m.lastName = 'ประสาวะถา'
  )
LIMIT 1;
-- แถว 553: นายธนันชัย  พิพิธพงศ์สันต์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgipermhaq37n',
  'M00553',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนันชัย',
  'พิพิธพงศ์สันต์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนันชัย' AND m.lastName = 'พิพิธพงศ์สันต์'
  )
LIMIT 1;
-- แถว 554: นางสาวปภัสสร จงตรอง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgenft90lvnqd',
  'M00554',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปภัสสร',
  'จงตรอง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปภัสสร' AND m.lastName = 'จงตรอง'
  )
LIMIT 1;
-- แถว 555: นางสาวศิริลักษณ์ สุดแสวง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg4epidmapeux',
  'M00555',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริลักษณ์',
  'สุดแสวง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริลักษณ์' AND m.lastName = 'สุดแสวง'
  )
LIMIT 1;
-- แถว 556: นางสาวศันสนีย์ เทพคำ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgnenyiesfyb',
  'M00556',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศันสนีย์',
  'เทพคำ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศันสนีย์' AND m.lastName = 'เทพคำ'
  )
LIMIT 1;
-- แถว 557: นางพิชาภัส วงค์จรณบูรณ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgkav1cr8nq9j',
  'M00557',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางพิชาภัส',
  'วงค์จรณบูรณ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางพิชาภัส' AND m.lastName = 'วงค์จรณบูรณ์'
  )
LIMIT 1;
-- แถว 558: นางสาวสุธัมวดี ใจยะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntggz3bb8dn7wl',
  'M00558',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุธัมวดี',
  'ใจยะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุธัมวดี' AND m.lastName = 'ใจยะ'
  )
LIMIT 1;
-- แถว 559: นางสาวกนกพร ชุมภู | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg1egnqldnc7',
  'M00559',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกพร',
  'ชุมภู',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกพร' AND m.lastName = 'ชุมภู'
  )
LIMIT 1;
-- แถว 560: ว่าที่ร้อยตรีหญิงอชิรญาณ์ สีชา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg52kuqxdopsc',
  'M00560',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีหญิงอชิรญาณ์',
  'สีชา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีหญิงอชิรญาณ์' AND m.lastName = 'สีชา'
  )
LIMIT 1;
-- แถว 561: นายนิวัฒ บัวติ๊บ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgtmqmvsxrb3l',
  'M00561',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนิวัฒ',
  'บัวติ๊บ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนิวัฒ' AND m.lastName = 'บัวติ๊บ'
  )
LIMIT 1;
-- แถว 562: นางสาวกิ่งกาญจน์ สายสูงเนิน | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq3v5af0fwle',
  'M00562',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกิ่งกาญจน์',
  'สายสูงเนิน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกิ่งกาญจน์' AND m.lastName = 'สายสูงเนิน'
  )
LIMIT 1;
-- แถว 563: นายเอกภพ คำรส | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgj2pf5uzfgus',
  'M00563',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกภพ',
  'คำรส',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกภพ' AND m.lastName = 'คำรส'
  )
LIMIT 1;
-- แถว 564: นายศุภการ แก้วรากมุข | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqgwhdwddlkc',
  'M00564',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศุภการ',
  'แก้วรากมุข',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศุภการ' AND m.lastName = 'แก้วรากมุข'
  )
LIMIT 1;
-- แถว 565: นางสาวณัฐวลัญช์ เรือนสอน | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntggz8c3unir58',
  'M00565',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐวลัญช์',
  'เรือนสอน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐวลัญช์' AND m.lastName = 'เรือนสอน'
  )
LIMIT 1;
-- แถว 566: นางสาวณัฏฐนันท์ บำเพ็ญกุล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgipxijzodg5f',
  'M00566',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฏฐนันท์',
  'บำเพ็ญกุล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฏฐนันท์' AND m.lastName = 'บำเพ็ญกุล'
  )
LIMIT 1;
-- แถว 567: นางสาวนภาพร สุขธงไชยกูล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg4umifgw5m56',
  'M00567',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนภาพร',
  'สุขธงไชยกูล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนภาพร' AND m.lastName = 'สุขธงไชยกูล'
  )
LIMIT 1;
-- แถว 568: นางสาวปาริชาติ เพ็ชรพลอย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgi2u2kq26t69',
  'M00568',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปาริชาติ',
  'เพ็ชรพลอย',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปาริชาติ' AND m.lastName = 'เพ็ชรพลอย'
  )
LIMIT 1;
-- แถว 569: นางสาวชบาไพร ปัญโญ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg6oomxbp2f3a',
  'M00569',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชบาไพร',
  'ปัญโญ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชบาไพร' AND m.lastName = 'ปัญโญ'
  )
LIMIT 1;
-- แถว 570: นางสาวสุฎาพร ธนสารพิพัฒน์คุณ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgj5phsohc2es',
  'M00570',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุฎาพร',
  'ธนสารพิพัฒน์คุณ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุฎาพร' AND m.lastName = 'ธนสารพิพัฒน์คุณ'
  )
LIMIT 1;
-- แถว 571: นางสาวภิญญดา ไชยวัง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgaznbpn46kkd',
  'M00571',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภิญญดา',
  'ไชยวัง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภิญญดา' AND m.lastName = 'ไชยวัง'
  )
LIMIT 1;
-- แถว 572: นางสาวชรินทร์รัตน์ บุญเลา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgbe5pnpmjc8l',
  'M00572',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชรินทร์รัตน์',
  'บุญเลา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชรินทร์รัตน์' AND m.lastName = 'บุญเลา'
  )
LIMIT 1;
-- แถว 573: นายฌัชวิทย์ รัตนเดชา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg26zl2mbbegi',
  'M00573',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายฌัชวิทย์',
  'รัตนเดชา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายฌัชวิทย์' AND m.lastName = 'รัตนเดชา'
  )
LIMIT 1;
-- แถว 574: นางสาวเมธาพร ญาวิระ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgz4grfp3z9q',
  'M00574',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเมธาพร',
  'ญาวิระ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเมธาพร' AND m.lastName = 'ญาวิระ'
  )
LIMIT 1;
-- แถว 575: นายธนากร แสนคำมา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgub2xhoh6trs',
  'M00575',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนากร',
  'แสนคำมา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนากร' AND m.lastName = 'แสนคำมา'
  )
LIMIT 1;
-- แถว 576: นายทรงภพ ขุนยวมอนุรักษ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjwl8dydg6lg',
  'M00576',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายทรงภพ',
  'ขุนยวมอนุรักษ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายทรงภพ' AND m.lastName = 'ขุนยวมอนุรักษ์'
  )
LIMIT 1;
-- แถว 577: นางสาวกันติยา น่วมฟั่น | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgln02fx4q0wf',
  'M00577',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกันติยา',
  'น่วมฟั่น',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกันติยา' AND m.lastName = 'น่วมฟั่น'
  )
LIMIT 1;
-- แถว 578: นางสาวนันทวัน จันทรังษี | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgvfxcq82i90d',
  'M00578',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนันทวัน',
  'จันทรังษี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนันทวัน' AND m.lastName = 'จันทรังษี'
  )
LIMIT 1;
-- แถว 579: นายพงษ์สิทธิ์ นันต๊ะภูมิ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfna9svv6hfe',
  'M00579',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพงษ์สิทธิ์',
  'นันต๊ะภูมิ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพงษ์สิทธิ์' AND m.lastName = 'นันต๊ะภูมิ'
  )
LIMIT 1;
-- แถว 580: นางสาวจุฑาลักษณ์ ศักดิ์เรืองฤทธิ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg3b5532e6oau',
  'M00580',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจุฑาลักษณ์',
  'ศักดิ์เรืองฤทธิ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจุฑาลักษณ์' AND m.lastName = 'ศักดิ์เรืองฤทธิ์'
  )
LIMIT 1;
-- แถว 581: นางสาวธัญญาลักษณ์ จินะเขียว | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg515jo37sp1j',
  'M00581',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญญาลักษณ์',
  'จินะเขียว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญญาลักษณ์' AND m.lastName = 'จินะเขียว'
  )
LIMIT 1;
-- แถว 582: นางสาวสุภาวรรณ อ่อนนวล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg0dad2doioues',
  'M00582',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุภาวรรณ',
  'อ่อนนวล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุภาวรรณ' AND m.lastName = 'อ่อนนวล'
  )
LIMIT 1;
-- แถว 583: นางสาวเกศรินทร์ แสนคำหล่อ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg6vd9lkonwz8',
  'M00583',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกศรินทร์',
  'แสนคำหล่อ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกศรินทร์' AND m.lastName = 'แสนคำหล่อ'
  )
LIMIT 1;
-- แถว 584: นางสาวธัญญา แหวนเพชร | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgkz9jiu2wh8',
  'M00584',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธัญญา',
  'แหวนเพชร',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธัญญา' AND m.lastName = 'แหวนเพชร'
  )
LIMIT 1;
-- แถว 585: นางสาวศิริลักษณ์ วงศ์ไชย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg6qmormf9x74',
  'M00585',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริลักษณ์',
  'วงศ์ไชย',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริลักษณ์' AND m.lastName = 'วงศ์ไชย'
  )
LIMIT 1;
-- แถว 586: นางสาวนวลจันทร์ ชัยชนะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntga380xiw1w0i',
  'M00586',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนวลจันทร์',
  'ชัยชนะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนวลจันทร์' AND m.lastName = 'ชัยชนะ'
  )
LIMIT 1;
-- แถว 587: ว่าที่ร้อยตรีสุทธินันต์ สรรเสริญบุญ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgb402xba9pm',
  'M00587',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีสุทธินันต์',
  'สรรเสริญบุญ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีสุทธินันต์' AND m.lastName = 'สรรเสริญบุญ'
  )
LIMIT 1;
-- แถว 588: นางสาวสิริวิมล ปิ่นญาติ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgj5bvwwhika',
  'M00588',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิริวิมล',
  'ปิ่นญาติ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิริวิมล' AND m.lastName = 'ปิ่นญาติ'
  )
LIMIT 1;
-- แถว 589: นางสาวภูษณิศา ยะโหนด | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg5g87t4blvzh',
  'M00589',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภูษณิศา',
  'ยะโหนด',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภูษณิศา' AND m.lastName = 'ยะโหนด'
  )
LIMIT 1;
-- แถว 590: นางสาวอิชยา บุญอินเขียว | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgtkgyv5k9kv',
  'M00590',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอิชยา',
  'บุญอินเขียว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอิชยา' AND m.lastName = 'บุญอินเขียว'
  )
LIMIT 1;
-- แถว 591: นางสาวสุทามาศ สุริยะวงศ์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjm01ok0d84i',
  'M00591',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุทามาศ',
  'สุริยะวงศ์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุทามาศ' AND m.lastName = 'สุริยะวงศ์'
  )
LIMIT 1;
-- แถว 592: นางชนันทภรณ์ รูปะวิเชตร์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxcifrhd48si',
  'M00592',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางชนันทภรณ์',
  'รูปะวิเชตร์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางชนันทภรณ์' AND m.lastName = 'รูปะวิเชตร์'
  )
LIMIT 1;
-- แถว 593: นางสาวสุกัญญา แสงทอง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgydih0suletp',
  'M00593',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุกัญญา',
  'แสงทอง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุกัญญา' AND m.lastName = 'แสงทอง'
  )
LIMIT 1;
-- แถว 594: นายธีรวัฒน์  แสนคำ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntge0ouez05an7',
  'M00594',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธีรวัฒน์',
  'แสนคำ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธีรวัฒน์' AND m.lastName = 'แสนคำ'
  )
LIMIT 1;
-- แถว 595: นางสาวสุภัสสร  ทิพย์อุบล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgpkclq841ho',
  'M00595',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุภัสสร',
  'ทิพย์อุบล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุภัสสร' AND m.lastName = 'ทิพย์อุบล'
  )
LIMIT 1;
-- แถว 596: นางสาวเกษร  พิพิธพงศ์สันต์ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmzdlajcr4t',
  'M00596',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเกษร',
  'พิพิธพงศ์สันต์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเกษร' AND m.lastName = 'พิพิธพงศ์สันต์'
  )
LIMIT 1;
-- แถว 597: นางสาวแดงน้อย แซ่ย่าง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntggd82k9ihkhu',
  'M00597',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวแดงน้อย',
  'แซ่ย่าง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวแดงน้อย' AND m.lastName = 'แซ่ย่าง'
  )
LIMIT 1;
-- แถว 598: นางสาวเซียวกวง แซ่จาง | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgx65ms2wa0sg',
  'M00598',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเซียวกวง',
  'แซ่จาง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเซียวกวง' AND m.lastName = 'แซ่จาง'
  )
LIMIT 1;
-- แถว 599: นางอาเซียว มาเยอะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntged3gukv5ns',
  'M00599',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางอาเซียว',
  'มาเยอะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางอาเซียว' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 600: นายหล่อปา หวุ่ยเมียะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg5stlkj0j4pw',
  'M00600',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายหล่อปา',
  'หวุ่ยเมียะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายหล่อปา' AND m.lastName = 'หวุ่ยเมียะ'
  )
LIMIT 1;
-- แถว 601: นางสาวกัญญา ยาผ่า | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg0gzp3h9o9xzv',
  'M00601',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญญา',
  'ยาผ่า',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญญา' AND m.lastName = 'ยาผ่า'
  )
LIMIT 1;
-- แถว 602: นายหล่อโย | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg96z1vkvj8co',
  'M00602',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายหล่อโย',
  '—',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายหล่อโย' AND m.lastName = '—'
  )
LIMIT 1;
-- แถว 603: นางสาวหมี่ซอ  เชกอ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg105fp38rmvk',
  'M00603',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหมี่ซอ',
  'เชกอ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหมี่ซอ' AND m.lastName = 'เชกอ'
  )
LIMIT 1;
-- แถว 604: นายณัฐวุฒิ  ม่านอินทนิล | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq3tz6hcjxej',
  'M00604',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายณัฐวุฒิ',
  'ม่านอินทนิล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายณัฐวุฒิ' AND m.lastName = 'ม่านอินทนิล'
  )
LIMIT 1;
-- แถว 605: นางสาวพรทิพย์ หวุ่ยยือกู่ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgo49wzz4338k',
  'M00605',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพรทิพย์',
  'หวุ่ยยือกู่',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพรทิพย์' AND m.lastName = 'หวุ่ยยือกู่'
  )
LIMIT 1;
-- แถว 606: นางสาวจวงจันทร์ เชอมือ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg9ci1xpt4jcv',
  'M00606',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจวงจันทร์',
  'เชอมือ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจวงจันทร์' AND m.lastName = 'เชอมือ'
  )
LIMIT 1;
-- แถว 607: นายมานะ  เรืองสา | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgrbyobk3oe79',
  'M00607',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายมานะ',
  'เรืองสา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายมานะ' AND m.lastName = 'เรืองสา'
  )
LIMIT 1;
-- แถว 608: นางสาวหมี่จู  มาเยอะ | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg7foktjlfz9u',
  'M00608',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวหมี่จู',
  'มาเยอะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวหมี่จู' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 609: นางสาวฤดี โสเช | โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgrrujch81b9r',
  'M00609',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฤดี',
  'โสเช',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_023_บ้านสันติคีรี_กลุ่มเ' OR s.name = 'โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านสันติคีรี กลุ่มเครือข่ายดอยแม่สลอง%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฤดี' AND m.lastName = 'โสเช'
  )
LIMIT 1;
-- แถว 610: นางบุญชนิต   ธรรมสาร | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgtqz82g1dgg',
  'M00610',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางบุญชนิต',
  'ธรรมสาร',
  '091-853-7047',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางบุญชนิต' AND m.lastName = 'ธรรมสาร'
  )
LIMIT 1;
-- แถว 611: นางสาวอังคณา   ยานะตระกูล | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgevgx4wfqwku',
  'M00611',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอังคณา',
  'ยานะตระกูล',
  '094-482-0202',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอังคณา' AND m.lastName = 'ยานะตระกูล'
  )
LIMIT 1;
-- แถว 612: นางสาวศิริพร   สวัสดิ์สุข | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqadgqq3brhf',
  'M00612',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริพร',
  'สวัสดิ์สุข',
  '082-388-2581',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริพร' AND m.lastName = 'สวัสดิ์สุข'
  )
LIMIT 1;
-- แถว 613: นางสาวเวฬุวัน   ดีศรี | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgwojf86y2kjj',
  'M00613',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเวฬุวัน',
  'ดีศรี',
  '098-493-3990',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเวฬุวัน' AND m.lastName = 'ดีศรี'
  )
LIMIT 1;
-- แถว 614: นางสาวภัควลัญชน์ ผาบพิชวงศ์ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgp4y2reqd4l',
  'M00614',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภัควลัญชน์',
  'ผาบพิชวงศ์',
  '082-1897-672',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภัควลัญชน์' AND m.lastName = 'ผาบพิชวงศ์'
  )
LIMIT 1;
-- แถว 615: นางสาวรัตนวดี   ศรีมา | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgf5e8nphwt1',
  'M00615',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวรัตนวดี',
  'ศรีมา',
  '083-082-2669',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวรัตนวดี' AND m.lastName = 'ศรีมา'
  )
LIMIT 1;
-- แถว 616: นายจิรภัทร   แสนศักดิ์หาญ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgwsw4kxu3dto',
  'M00616',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายจิรภัทร',
  'แสนศักดิ์หาญ',
  '099-237-7972',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายจิรภัทร' AND m.lastName = 'แสนศักดิ์หาญ'
  )
LIMIT 1;
-- แถว 617: นางสาวสุธารทิพย์   วุยแบ | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgahcmxvy5v5v',
  'M00617',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุธารทิพย์',
  'วุยแบ',
  '097-302-2584',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุธารทิพย์' AND m.lastName = 'วุยแบ'
  )
LIMIT 1;
-- แถว 618: นายชนนภูมิ   เดชเดิม | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg1m7of99vbp1',
  'M00618',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชนนภูมิ',
  'เดชเดิม',
  '084-725-6724',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชนนภูมิ' AND m.lastName = 'เดชเดิม'
  )
LIMIT 1;
-- แถว 619: นายวรภัทร   จันทร์สิริทอง | โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg11l8011q8m5',
  'M00619',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวรภัทร',
  'จันทร์สิริทอง',
  '098-416-6648',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_024_ราษฎร์พัฒนา_กลุ่มเคร' OR s.name = 'โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนราษฎร์พัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวรภัทร' AND m.lastName = 'จันทร์สิริทอง'
  )
LIMIT 1;
-- แถว 620: นายยุทธนา   	กันทาเดช | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgq1b7u46e6l',
  'M00620',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายยุทธนา',
  'กันทาเดช',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายยุทธนา' AND m.lastName = 'กันทาเดช'
  )
LIMIT 1;
-- แถว 621: นายธีร์วรา    	ใจเย็น | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgfnm20fk6ccw',
  'M00621',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธีร์วรา',
  'ใจเย็น',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธีร์วรา' AND m.lastName = 'ใจเย็น'
  )
LIMIT 1;
-- แถว 622: นางสาวสุวิมล ศรีคำ | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgvvny7s56nb',
  'M00622',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุวิมล',
  'ศรีคำ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุวิมล' AND m.lastName = 'ศรีคำ'
  )
LIMIT 1;
-- แถว 623: นางสาวอรอุมา ไชยชิน | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2cnuocw0g23',
  'M00623',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรอุมา',
  'ไชยชิน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรอุมา' AND m.lastName = 'ไชยชิน'
  )
LIMIT 1;
-- แถว 624: นางสาวอาคิรา อุทธิยา | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2lw680c5u7o',
  'M00624',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอาคิรา',
  'อุทธิยา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอาคิรา' AND m.lastName = 'อุทธิยา'
  )
LIMIT 1;
-- แถว 625: นายอัฒชัย    ใจเผิน | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjazizodbqr',
  'M00625',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอัฒชัย',
  'ใจเผิน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอัฒชัย' AND m.lastName = 'ใจเผิน'
  )
LIMIT 1;
-- แถว 626: นางสาวเก็จมณี กวางกระโดด | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg4p066nmgu2m',
  'M00626',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเก็จมณี',
  'กวางกระโดด',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเก็จมณี' AND m.lastName = 'กวางกระโดด'
  )
LIMIT 1;
-- แถว 627: นายสุรศักดิ์   	กานิล | โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgg7o3xrlxek',
  'M00627',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุรศักดิ์',
  'กานิล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_025_บ้านแม่เต๋อ_กลุ่มเคร' OR s.name = 'โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง' OR s.name LIKE '%โรงเรียนบ้านแม่เต๋อ กลุ่มเครือข่ายพัฒนาการศึกษาดอย%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุรศักดิ์' AND m.lastName = 'กานิล'
  )
LIMIT 1;
-- แถว 628: โรเรียนบ้านใหม่สันติ  กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg8ih09kkur6g',
  'M00628',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'โรเรียนบ้านใหม่สันติ',
  'กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'โรเรียนบ้านใหม่สันติ' AND m.lastName = 'กลุ่มเครือข่ายพัฒนาการศึกษาดอยแม่สลอง'
  )
LIMIT 1;
-- แถว 629: นายเอกชัย  ใจอ้าย | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgf90bj2lb915',
  'M00629',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกชัย',
  'ใจอ้าย',
  '087-2028762',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกชัย' AND m.lastName = 'ใจอ้าย'
  )
LIMIT 1;
-- แถว 630: นายเอกรัฐ  น้อยมา | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgzkcj1zy2y7',
  'M00630',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกรัฐ',
  'น้อยมา',
  '093-6867133',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกรัฐ' AND m.lastName = 'น้อยมา'
  )
LIMIT 1;
-- แถว 631: นางสาวกะรัต รัตนจำเริญ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg008dniic1v37f',
  'M00631',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกะรัต',
  'รัตนจำเริญ',
  '082-9944408',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกะรัต' AND m.lastName = 'รัตนจำเริญ'
  )
LIMIT 1;
-- แถว 632: นางสาวชนัญธิดา  นุธรรม | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgawnzb5ldfpo',
  'M00632',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวชนัญธิดา',
  'นุธรรม',
  '080-9941949',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวชนัญธิดา' AND m.lastName = 'นุธรรม'
  )
LIMIT 1;
-- แถว 633: นายธนรัฐ  วรรณดี | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgwqt0tndg5f',
  'M00633',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนรัฐ',
  'วรรณดี',
  '082-8646492',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนรัฐ' AND m.lastName = 'วรรณดี'
  )
LIMIT 1;
-- แถว 634: นางสาวปัฐภัธ ญาณพันธ์ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgdxo29a8bt7k',
  'M00634',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปัฐภัธ',
  'ญาณพันธ์',
  '062-1742238',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปัฐภัธ' AND m.lastName = 'ญาณพันธ์'
  )
LIMIT 1;
-- แถว 635: นางสาวอริญช์ณิชา  เดชธนาอัครพงศ์ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgqdl6h7grcy',
  'M00635',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอริญช์ณิชา',
  'เดชธนาอัครพงศ์',
  '098-3397721',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอริญช์ณิชา' AND m.lastName = 'เดชธนาอัครพงศ์'
  )
LIMIT 1;
-- แถว 636: นางสาววรรณกานต์  กะโพ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntguxpz5sujgla',
  'M00636',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววรรณกานต์',
  'กะโพ',
  '080-0780092',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววรรณกานต์' AND m.lastName = 'กะโพ'
  )
LIMIT 1;
-- แถว 637: ว่าที่ร้อยตรีเนติพงษ์  จักรดี | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgx4an4dpfgk',
  'M00637',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีเนติพงษ์',
  'จักรดี',
  '093-2866528',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีเนติพงษ์' AND m.lastName = 'จักรดี'
  )
LIMIT 1;
-- แถว 638: นายสมศักดิ์  อุดมประสิทธิ์ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgdhp4ugdy9y8',
  'M00638',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสมศักดิ์',
  'อุดมประสิทธิ์',
  '095-3315441',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสมศักดิ์' AND m.lastName = 'อุดมประสิทธิ์'
  )
LIMIT 1;
-- แถว 639: นางสาวพิมพ์ภัช  แสงดาว | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg001tm50dedzeu',
  'M00639',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์ภัช',
  'แสงดาว',
  '091-0730255',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์ภัช' AND m.lastName = 'แสงดาว'
  )
LIMIT 1;
-- แถว 640: นายหล้า  พรมใจ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgy58xynirljr',
  'M00640',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายหล้า',
  'พรมใจ',
  '064-9950334',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายหล้า' AND m.lastName = 'พรมใจ'
  )
LIMIT 1;
-- แถว 641: นางเงิน  พรใจ | รร.บ้านใหม่สันติ
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgd0a8n2jxek',
  'M00641',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางเงิน',
  'พรใจ',
  '093-3086084',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_026_รร.บ้านใหม่สันติ' OR s.name = 'รร.บ้านใหม่สันติ' OR s.name LIKE '%รร.บ้านใหม่สันติ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางเงิน' AND m.lastName = 'พรใจ'
  )
LIMIT 1;
-- แถว 642: นายศุภโชค ปิยะสันติ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg10k4ddk51g',
  'M00642',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศุภโชค',
  'ปิยะสันติ์',
  '084-1518181',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศุภโชค' AND m.lastName = 'ปิยะสันติ์'
  )
LIMIT 1;
-- แถว 643: นางสาวณัฐรดี สิทธิกัน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgp7mdvmmitw',
  'M00643',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐรดี',
  'สิทธิกัน',
  '086-1917156',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐรดี' AND m.lastName = 'สิทธิกัน'
  )
LIMIT 1;
-- แถว 644: นางขวัญจิตร จันทิพย์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgat7gic5t8qn',
  'M00644',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางขวัญจิตร',
  'จันทิพย์',
  '089-4290819',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางขวัญจิตร' AND m.lastName = 'จันทิพย์'
  )
LIMIT 1;
-- แถว 645: นางทศพร สมยง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgekmosa95a15',
  'M00645',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางทศพร',
  'สมยง',
  '083-2088349',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางทศพร' AND m.lastName = 'สมยง'
  )
LIMIT 1;
-- แถว 646: นายพนม สมยง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgelva4y38ubq',
  'M00646',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพนม',
  'สมยง',
  '089-5575037',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพนม' AND m.lastName = 'สมยง'
  )
LIMIT 1;
-- แถว 647: นางสาววิลาวัลย์ อุ่นนันกาศ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg84zviy7m4zb',
  'M00647',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววิลาวัลย์',
  'อุ่นนันกาศ',
  '093-1515914',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววิลาวัลย์' AND m.lastName = 'อุ่นนันกาศ'
  )
LIMIT 1;
-- แถว 648: นายชาญชัย ก้อใจ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgn81wofh3ng',
  'M00648',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชาญชัย',
  'ก้อใจ',
  '087-5048099',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชาญชัย' AND m.lastName = 'ก้อใจ'
  )
LIMIT 1;
-- แถว 649: นางรุ่งทิวา จันทาพูน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg9l1t50gdmz8',
  'M00649',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางรุ่งทิวา',
  'จันทาพูน',
  '084-6093473',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางรุ่งทิวา' AND m.lastName = 'จันทาพูน'
  )
LIMIT 1;
-- แถว 650: นางจันจิรา ชัยภูวนารถ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgr3ot0oah53i',
  'M00650',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางจันจิรา',
  'ชัยภูวนารถ',
  '093-2596868',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางจันจิรา' AND m.lastName = 'ชัยภูวนารถ'
  )
LIMIT 1;
-- แถว 651: นางสาวธมลวรรณ มากปรางค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjm9tzoowilr',
  'M00651',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธมลวรรณ',
  'มากปรางค์',
  '063-7959539',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธมลวรรณ' AND m.lastName = 'มากปรางค์'
  )
LIMIT 1;
-- แถว 652: นายวัชรินทร์ ฤทธิรักษ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgakjquwre3u9',
  'M00652',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวัชรินทร์',
  'ฤทธิรักษ์',
  '080-4915400',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวัชรินทร์' AND m.lastName = 'ฤทธิรักษ์'
  )
LIMIT 1;
-- แถว 653: นายอนุศักดิ์ ฮงประยูร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntghjcgeipi8xe',
  'M00653',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอนุศักดิ์',
  'ฮงประยูร',
  '098-9020333',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอนุศักดิ์' AND m.lastName = 'ฮงประยูร'
  )
LIMIT 1;
-- แถว 654: นางสาวณัฐชยา  ปันก่อ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntggvcomua5pl',
  'M00654',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐชยา',
  'ปันก่อ',
  '098-6454255',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐชยา' AND m.lastName = 'ปันก่อ'
  )
LIMIT 1;
-- แถว 655: นางสาวภิญประภา  ใจทน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgbjrxf5sri3p',
  'M00655',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวภิญประภา',
  'ใจทน',
  '081-5152442',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวภิญประภา' AND m.lastName = 'ใจทน'
  )
LIMIT 1;
-- แถว 656: นางสาวเสาวลักษณ์ นาใจ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgy8re4na9ik',
  'M00656',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวเสาวลักษณ์',
  'นาใจ',
  '091-8565146',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวเสาวลักษณ์' AND m.lastName = 'นาใจ'
  )
LIMIT 1;
-- แถว 657: นายมนตรี คำเงิน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxxir70vrzqd',
  'M00657',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายมนตรี',
  'คำเงิน',
  '063-6732191',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายมนตรี' AND m.lastName = 'คำเงิน'
  )
LIMIT 1;
-- แถว 658: นายภาณุพงศ์ เปาวัลย์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgmlq1daoe7jk',
  'M00658',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายภาณุพงศ์',
  'เปาวัลย์',
  '082-4829049',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายภาณุพงศ์' AND m.lastName = 'เปาวัลย์'
  )
LIMIT 1;
-- แถว 659: นายมงคล ดิลกอุดมฤกษ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgejhug8sdat',
  'M00659',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายมงคล',
  'ดิลกอุดมฤกษ์',
  '065-0101826',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายมงคล' AND m.lastName = 'ดิลกอุดมฤกษ์'
  )
LIMIT 1;
-- แถว 660: นางสาวกัลยารัตน์ อนุรุส | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgjn39mu6ahun',
  'M00660',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัลยารัตน์',
  'อนุรุส',
  '097-2717693',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัลยารัตน์' AND m.lastName = 'อนุรุส'
  )
LIMIT 1;
-- แถว 661: นางสาวกมลวรรณ สุวรรณมงคล | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg2azki4c1xkr',
  'M00661',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกมลวรรณ',
  'สุวรรณมงคล',
  '063-7844869',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกมลวรรณ' AND m.lastName = 'สุวรรณมงคล'
  )
LIMIT 1;
-- แถว 662: นางสาวปวีณา คำฟู | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntg3wyoclm5o4q',
  'M00662',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปวีณา',
  'คำฟู',
  '084-1729446',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปวีณา' AND m.lastName = 'คำฟู'
  )
LIMIT 1;
-- แถว 663: นางสาวนงลักษณ์ บุญระชัยสวรรค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgpbmmi3v3vc',
  'M00663',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนงลักษณ์',
  'บุญระชัยสวรรค์',
  '086-4067520',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนงลักษณ์' AND m.lastName = 'บุญระชัยสวรรค์'
  )
LIMIT 1;
-- แถว 664: นางสาวกิตติลักษณ์ วงษาหาร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgc8u5dnba2ag',
  'M00664',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกิตติลักษณ์',
  'วงษาหาร',
  '094-2631039',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกิตติลักษณ์' AND m.lastName = 'วงษาหาร'
  )
LIMIT 1;
-- แถว 665: นายเกรียงไกร ไชยวงค์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgxgyd4jx2yqd',
  'M00665',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเกรียงไกร',
  'ไชยวงค์',
  '081-4727141',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเกรียงไกร' AND m.lastName = 'ไชยวงค์'
  )
LIMIT 1;
-- แถว 666: นางสาวกนกวรรณ จันทร์เนตร | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntguctcvw9kv9e',
  'M00666',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกนกวรรณ',
  'จันทร์เนตร',
  '061-0847565',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกนกวรรณ' AND m.lastName = 'จันทร์เนตร'
  )
LIMIT 1;
-- แถว 667: นายพริษศ์ ไพรี | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntgialxurur07n',
  'M00667',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายพริษศ์',
  'ไพรี',
  '061-2687487',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายพริษศ์' AND m.lastName = 'ไพรี'
  )
LIMIT 1;
-- แถว 668: นางสาวจิรัญญา ร่องตอง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthdk2hv7b5h6k',
  'M00668',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิรัญญา',
  'ร่องตอง',
  '062-9382151',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิรัญญา' AND m.lastName = 'ร่องตอง'
  )
LIMIT 1;
-- แถว 669: นางสาวปียาภรณ์ กิ่งแก้ว | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth448shpu5qyq',
  'M00669',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปียาภรณ์',
  'กิ่งแก้ว',
  '086-1952826',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปียาภรณ์' AND m.lastName = 'กิ่งแก้ว'
  )
LIMIT 1;
-- แถว 670: นางลัดดาวัลย์ ไสยวรรณ์ | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthik6tidpquy',
  'M00670',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางลัดดาวัลย์',
  'ไสยวรรณ์',
  '082-1851817',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางลัดดาวัลย์' AND m.lastName = 'ไสยวรรณ์'
  )
LIMIT 1;
-- แถว 671: นายอานนท์ ทะนุตัน | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthew9r9xilq8q',
  'M00671',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายอานนท์',
  'ทะนุตัน',
  '096-6742702',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายอานนท์' AND m.lastName = 'ทะนุตัน'
  )
LIMIT 1;
-- แถว 672: นางสาวมณีวรรณ ชมภูสมษา | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthrvm11j4xmxo',
  'M00672',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมณีวรรณ',
  'ชมภูสมษา',
  '089-8526887',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมณีวรรณ' AND m.lastName = 'ชมภูสมษา'
  )
LIMIT 1;
-- แถว 673: นายนัฝทาลี กิตติคุณรุ่งเรือง | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthcpy86w8um3n',
  'M00673',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนัฝทาลี',
  'กิตติคุณรุ่งเรือง',
  '086-3116735',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนัฝทาลี' AND m.lastName = 'กิตติคุณรุ่งเรือง'
  )
LIMIT 1;
-- แถว 674: นางสาวจันจิรา พิมดี | โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth932m6bzo0jv',
  'M00674',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจันจิรา',
  'พิมดี',
  '098-8434994',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_027_บ้านห้วยไร่สามัคคี_ก' OR s.name = 'โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศึกษาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านห้วยไร่สามัคคี กลุ่มเครือข่ายพัฒนาการศ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจันจิรา' AND m.lastName = 'พิมดี'
  )
LIMIT 1;
-- แถว 675: นางสาวศิริพร ดวงดี | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthqk1cv1etxdk',
  'M00675',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริพร',
  'ดวงดี',
  '096-2282643',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริพร' AND m.lastName = 'ดวงดี'
  )
LIMIT 1;
-- แถว 676: นายไพรัช สุขเกษม | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthyf6v60bcce',
  'M00676',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไพรัช',
  'สุขเกษม',
  '065-2387935',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไพรัช' AND m.lastName = 'สุขเกษม'
  )
LIMIT 1;
-- แถว 677: นางสาวอารียา วงค์วุฒิ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth7a3o0nz4t6l',
  'M00677',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอารียา',
  'วงค์วุฒิ',
  '096-7462365',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอารียา' AND m.lastName = 'วงค์วุฒิ'
  )
LIMIT 1;
-- แถว 678: นางสาวจารุวรรณ จันวัน | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth2d05f6emcox',
  'M00678',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'จันวัน',
  '087-3578211',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'จันวัน'
  )
LIMIT 1;
-- แถว 679: นางสาวสาริกา มาลา | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthhrz04zqt7ns',
  'M00679',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสาริกา',
  'มาลา',
  '0098-0348285',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสาริกา' AND m.lastName = 'มาลา'
  )
LIMIT 1;
-- แถว 680: นางสาวปานทิพย์ จินะโกษฐ์ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthnfb68wa60u',
  'M00680',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวปานทิพย์',
  'จินะโกษฐ์',
  '094-7571701',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวปานทิพย์' AND m.lastName = 'จินะโกษฐ์'
  )
LIMIT 1;
-- แถว 681: นางสาวทิพย์อัปสร ลาวิชัย | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthsfjj5m2loq',
  'M00681',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวทิพย์อัปสร',
  'ลาวิชัย',
  '095-1419444',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวทิพย์อัปสร' AND m.lastName = 'ลาวิชัย'
  )
LIMIT 1;
-- แถว 682: นายไกรสร หลีทำ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthvqyv0prkm6n',
  'M00682',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายไกรสร',
  'หลีทำ',
  '088-2951142',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายไกรสร' AND m.lastName = 'หลีทำ'
  )
LIMIT 1;
-- แถว 683: นางสาวสุมาลัย อามอ | โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthyioz9683p5',
  'M00683',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุมาลัย',
  'อามอ',
  '095-3547151',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_028_ตำรวจตระเวนชายแดนศรี' OR s.name = 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพ%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุมาลัย' AND m.lastName = 'อามอ'
  )
LIMIT 1;
-- แถว 684: นางสาวจิรัชญา  ผาลา | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthikswx6egj1',
  'M00684',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจิรัชญา',
  'ผาลา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจิรัชญา' AND m.lastName = 'ผาลา'
  )
LIMIT 1;
-- แถว 685: นางสาวจารุวรรณ  สิงห์เชื้อ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth5j1nm9mf3o8',
  'M00685',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวจารุวรรณ',
  'สิงห์เชื้อ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวจารุวรรณ' AND m.lastName = 'สิงห์เชื้อ'
  )
LIMIT 1;
-- แถว 686: นางธนิดา  แก้วคำฟู | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthaoff40kqhgn',
  'M00686',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางธนิดา',
  'แก้วคำฟู',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางธนิดา' AND m.lastName = 'แก้วคำฟู'
  )
LIMIT 1;
-- แถว 687: นายนควัฒน์  กุณะด้วง | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthypqq3rg4r6f',
  'M00687',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนควัฒน์',
  'กุณะด้วง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนควัฒน์' AND m.lastName = 'กุณะด้วง'
  )
LIMIT 1;
-- แถว 688: นางสาวธิษตยา  ภิระบัน | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthr03p1q20r8',
  'M00688',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธิษตยา',
  'ภิระบัน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธิษตยา' AND m.lastName = 'ภิระบัน'
  )
LIMIT 1;
-- แถว 689: นางสาวธิดาวรรณ  ทองใบ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthea5em2g8p2',
  'M00689',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวธิดาวรรณ',
  'ทองใบ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวธิดาวรรณ' AND m.lastName = 'ทองใบ'
  )
LIMIT 1;
-- แถว 690: นางสาวณัฐชยา  สุริยะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthd6kkhkwcrxf',
  'M00690',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวณัฐชยา',
  'สุริยะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวณัฐชยา' AND m.lastName = 'สุริยะ'
  )
LIMIT 1;
-- แถว 691: นางสาวสกุลรัตน์  โมงยาม | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth669ubh7cjio',
  'M00691',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสกุลรัตน์',
  'โมงยาม',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสกุลรัตน์' AND m.lastName = 'โมงยาม'
  )
LIMIT 1;
-- แถว 692: นางสาวศิริพร  พะเงาะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthbbmqvl4hs1f',
  'M00692',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศิริพร',
  'พะเงาะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศิริพร' AND m.lastName = 'พะเงาะ'
  )
LIMIT 1;
-- แถว 693: นางสาวนฤภร  ทามัน | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthy6p4upmwtu',
  'M00693',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนฤภร',
  'ทามัน',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนฤภร' AND m.lastName = 'ทามัน'
  )
LIMIT 1;
-- แถว 694: นายศิริมงคล  อูปคำ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth1t9i4vdh60i',
  'M00694',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายศิริมงคล',
  'อูปคำ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายศิริมงคล' AND m.lastName = 'อูปคำ'
  )
LIMIT 1;
-- แถว 695: นางสาวมุกดา  อศิกุล | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthznsecounnbo',
  'M00695',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมุกดา',
  'อศิกุล',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมุกดา' AND m.lastName = 'อศิกุล'
  )
LIMIT 1;
-- แถว 696: นางสาวสรันดา  วงค์นาง | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthmhe7lns658',
  'M00696',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสรันดา',
  'วงค์นาง',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสรันดา' AND m.lastName = 'วงค์นาง'
  )
LIMIT 1;
-- แถว 697: ว่าที่ร้อยตรีหญิงอมรรัตน์  นันทิยา | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth5x6yabz5kqg',
  'M00697',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'ว่าที่ร้อยตรีหญิงอมรรัตน์',
  'นันทิยา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'ว่าที่ร้อยตรีหญิงอมรรัตน์' AND m.lastName = 'นันทิยา'
  )
LIMIT 1;
-- แถว 698: นางสาวศุภนิช   มูลทาศรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthd1737y3v30e',
  'M00698',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศุภนิช',
  'มูลทาศรี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศุภนิช' AND m.lastName = 'มูลทาศรี'
  )
LIMIT 1;
-- แถว 699: นางสาวประทุมพร  พรรณมณีพร | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth7glo2qfwr7',
  'M00699',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวประทุมพร',
  'พรรณมณีพร',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวประทุมพร' AND m.lastName = 'พรรณมณีพร'
  )
LIMIT 1;
-- แถว 700: นางสาวนารี  ต้องสู้คีรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthf4uv199b2i4',
  'M00700',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนารี',
  'ต้องสู้คีรี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนารี' AND m.lastName = 'ต้องสู้คีรี'
  )
LIMIT 1;
-- แถว 701: นางสาวอัมพร  พร้อมชัยศรี | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth9khwkyrrg4o',
  'M00701',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอัมพร',
  'พร้อมชัยศรี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอัมพร' AND m.lastName = 'พร้อมชัยศรี'
  )
LIMIT 1;
-- แถว 702: นายนพฤทธิ์  มาเยอะ | โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth1bheu6r9j1x',
  'M00702',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนพฤทธิ์',
  'มาเยอะ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_029_บ้านป่าซางนาเงิน_กลุ' OR s.name = 'โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านป่าซางนาเงิน กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนพฤทธิ์' AND m.lastName = 'มาเยอะ'
  )
LIMIT 1;
-- แถว 703: นายนิรุตต์  ชัยมณี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthwjc13sluix',
  'M00703',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนิรุตต์',
  'ชัยมณี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนิรุตต์' AND m.lastName = 'ชัยมณี'
  )
LIMIT 1;
-- แถว 704: นายสวาท  เย็นใจมา | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthlvl44nugmx8',
  'M00704',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสวาท',
  'เย็นใจมา',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสวาท' AND m.lastName = 'เย็นใจมา'
  )
LIMIT 1;
-- แถว 705: นางอัมพร  วสันต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth9le849g1jgw',
  'M00705',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางอัมพร',
  'วสันต์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางอัมพร' AND m.lastName = 'วสันต์'
  )
LIMIT 1;
-- แถว 706: นายสุทธิพันธ์  ดวงสุข | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthm2esnypert',
  'M00706',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายสุทธิพันธ์',
  'ดวงสุข',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายสุทธิพันธ์' AND m.lastName = 'ดวงสุข'
  )
LIMIT 1;
-- แถว 707: นายวุฒิชัย  กันใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthoi0prl9rgn',
  'M00707',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายวุฒิชัย',
  'กันใจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายวุฒิชัย' AND m.lastName = 'กันใจ'
  )
LIMIT 1;
-- แถว 708: นายธนกฤต  วิริยะจิตต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth2e5tru4c52d',
  'M00708',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายธนกฤต',
  'วิริยะจิตต์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายธนกฤต' AND m.lastName = 'วิริยะจิตต์'
  )
LIMIT 1;
-- แถว 709: นางสาวสุชาวดี  จิตต์ใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthtn7w9quphyj',
  'M00709',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชาวดี',
  'จิตต์ใจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชาวดี' AND m.lastName = 'จิตต์ใจ'
  )
LIMIT 1;
-- แถว 710: นางสาวอรสา ทะลิ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth7aswc0mgu1r',
  'M00710',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอรสา',
  'ทะลิ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอรสา' AND m.lastName = 'ทะลิ'
  )
LIMIT 1;
-- แถว 711: นายคณาวุฒิ  มูลทาศรี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth0ofbhe5fq8d',
  'M00711',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายคณาวุฒิ',
  'มูลทาศรี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายคณาวุฒิ' AND m.lastName = 'มูลทาศรี'
  )
LIMIT 1;
-- แถว 712: นางสาวสิริรัตน์  สุนสะดี | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth5kt8cftejak',
  'M00712',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสิริรัตน์',
  'สุนสะดี',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสิริรัตน์' AND m.lastName = 'สุนสะดี'
  )
LIMIT 1;
-- แถว 713: นางสาวอำพร  อรหันต์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthb4ss57fpmih',
  'M00713',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวอำพร',
  'อรหันต์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวอำพร' AND m.lastName = 'อรหันต์'
  )
LIMIT 1;
-- แถว 714: นางกัญชริภา  ทะจันทร์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthi59aguyepe',
  'M00714',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกัญชริภา',
  'ทะจันทร์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกัญชริภา' AND m.lastName = 'ทะจันทร์'
  )
LIMIT 1;
-- แถว 715: นายนวมินตร์  ตาใจ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthb3mjn8u59p',
  'M00715',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายนวมินตร์',
  'ตาใจ',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายนวมินตร์' AND m.lastName = 'ตาใจ'
  )
LIMIT 1;
-- แถว 716: นายชินกร  จองหนุ่ม | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthzl0c4lavn4c',
  'M00716',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายชินกร',
  'จองหนุ่ม',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายชินกร' AND m.lastName = 'จองหนุ่ม'
  )
LIMIT 1;
-- แถว 717: นางสาวมีนาร์  อารีย์ | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthevk4t97jttd',
  'M00717',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวมีนาร์',
  'อารีย์',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวมีนาร์' AND m.lastName = 'อารีย์'
  )
LIMIT 1;
-- แถว 718: นายเอกพงษ์  กาแก้ว | โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthlvx6c7rmumn',
  'M00718',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายเอกพงษ์',
  'กาแก้ว',
  NULL,
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_030_อนุบาลแม่ฟ้าหลวง_กลุ' OR s.name = 'โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนอนุบาลแม่ฟ้าหลวง กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายเอกพงษ์' AND m.lastName = 'กาแก้ว'
  )
LIMIT 1;
-- แถว 719: นางกุลธิดา อดิลักษณ์ศิริ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthajq4ef4ttvq',
  'M00719',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางกุลธิดา',
  'อดิลักษณ์ศิริ',
  '081-1665565',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางกุลธิดา' AND m.lastName = 'อดิลักษณ์ศิริ'
  )
LIMIT 1;
-- แถว 720: นางภาระวี อินนวล | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthc2jaoekdiof',
  'M00720',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางภาระวี',
  'อินนวล',
  '065-6322595',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางภาระวี' AND m.lastName = 'อินนวล'
  )
LIMIT 1;
-- แถว 721: นางสาวทัศนีย์ โสภณอำนวยกิจ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthpc7lql5tohf',
  'M00721',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวทัศนีย์',
  'โสภณอำนวยกิจ',
  '082-1908315',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวทัศนีย์' AND m.lastName = 'โสภณอำนวยกิจ'
  )
LIMIT 1;
-- แถว 722: นางสาววราภรณ์ ไชยานันตา | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth8pabb7xoidq',
  'M00722',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาววราภรณ์',
  'ไชยานันตา',
  '094-0107632',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาววราภรณ์' AND m.lastName = 'ไชยานันตา'
  )
LIMIT 1;
-- แถว 723: นางสาวกัญญารัตน์ ตาโม่ง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthlv6ngqjglb',
  'M00723',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกัญญารัตน์',
  'ตาโม่ง',
  '094-9314949',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกัญญารัตน์' AND m.lastName = 'ตาโม่ง'
  )
LIMIT 1;
-- แถว 724: นางสาวกานติมา เกตสระไชย | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20ntheedkodp5fc',
  'M00724',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวกานติมา',
  'เกตสระไชย',
  '093-2397727',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวกานติมา' AND m.lastName = 'เกตสระไชย'
  )
LIMIT 1;
-- แถว 725: นางสาวศศิกานต์ ดาชิต | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth0ylwdujwo43',
  'M00725',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวศศิกานต์',
  'ดาชิต',
  '092-7841523',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวศศิกานต์' AND m.lastName = 'ดาชิต'
  )
LIMIT 1;
-- แถว 726: นางสาวสุชาดา เครือคำวัง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthhbp43izmhid',
  'M00726',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวสุชาดา',
  'เครือคำวัง',
  '080-6714082',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวสุชาดา' AND m.lastName = 'เครือคำวัง'
  )
LIMIT 1;
-- แถว 727: นางสาวพัชรา บุญสุวรรณ์ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthdb2aoskrj1c',
  'M00727',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพัชรา',
  'บุญสุวรรณ์',
  '094-8401127',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพัชรา' AND m.lastName = 'บุญสุวรรณ์'
  )
LIMIT 1;
-- แถว 728: นางสาวนิภาวรรณ การเจริญ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nth6orpcihqlp',
  'M00728',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวนิภาวรรณ',
  'การเจริญ',
  '099-9982065',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวนิภาวรรณ' AND m.lastName = 'การเจริญ'
  )
LIMIT 1;
-- แถว 729: นางสาวฐิตาภรณ์ โยงยศ | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthbf96rnyr3tl',
  'M00729',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวฐิตาภรณ์',
  'โยงยศ',
  '097-9471813',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวฐิตาภรณ์' AND m.lastName = 'โยงยศ'
  )
LIMIT 1;
-- แถว 730: นางสาวพิมพ์จันทร์ ทานศิลา | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthtpttqfyo9eb',
  'M00730',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นางสาวพิมพ์จันทร์',
  'ทานศิลา',
  '096-2853002',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นางสาวพิมพ์จันทร์' AND m.lastName = 'ทานศิลา'
  )
LIMIT 1;
-- แถว 731: นายประทวน ขัดบุญเรือง | โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง
INSERT INTO `Member` (`id`, `memberNo`, `schoolId`, `memberTypeId`, `firstName`, `lastName`, `phone`, `joinDate`, `status`, `createdAt`, `updatedAt`)
SELECT 
  'cmlq20nthbyx0928edz',
  'M00731',
  s.id,
  (SELECT id FROM `MemberType` ORDER BY id LIMIT 1),
  'นายประทวน',
  'ขัดบุญเรือง',
  '061-1530498',
  '2020-01-01 00:00:00',
  'ACTIVE',
  '2026-02-17 03:39:09',
  '2026-02-17 03:39:09'
FROM `School` s
WHERE (s.code = 'SCH_031_บ้านขาแหย่งพัฒนา_กลุ' OR s.name = 'โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง' OR s.name LIKE '%โรงเรียนบ้านขาแหย่งพัฒนา กลุ่มเครือข่ายพัฒนาการศึก%')
  AND NOT EXISTS (
    SELECT 1 FROM `Member` m 
    WHERE m.schoolId = s.id AND m.firstName = 'นายประทวน' AND m.lastName = 'ขัดบุญเรือง'
  )
LIMIT 1;
