/**
 * อ่านข้อมูลจาก doc/member_data.xlsx และสร้าง migration SQL
 *
 * โครงสร้าง Excel: แยกโรงเรียนละ 1 sheet
 * - ชื่อ sheet = ชื่อโรงเรียน หรือ แถวแรกใน sheet มีชื่อโรงเรียน
 * - ในแต่ละ sheet: header (ที่, ชื่อ-สกุล, ตำแหน่ง, เบอร์โทร) + ข้อมูล
 *
 * สร้าง 3 migrations:
 * 1. seed_schools_from_excel - INSERT School (โรงเรียนที่ไม่ซ้ำ)
 * 2. seed_members_from_excel - INSERT Member (ต้องมี School, MemberType แล้ว)
 * 3. seed_association_member_from_excel - INSERT AssociationMember (match กับ Member)
 *
 * หมายเหตุ: ต้องมี MemberType ใน DB (รัน prisma db seed ก่อน หรือมี migration seed MemberType)
 * รัน: npm run db:excel-to-migration
 */
import * as XLSX from 'xlsx';
import * as path from 'path';
import * as fs from 'fs';

const EXCEL_PATH = path.join(__dirname, '../../../doc/member_data.xlsx');
const OUTPUT_PATH = path.join(__dirname, '../prisma/migrations');

const DEFAULT_DISTRICT = 'แม่ฟ้าหลวง';
const DEFAULT_PROVINCE = 'เชียงราย';

function escapeSql(str: string | number | undefined | null): string {
  if (str === undefined || str === null || str === '') return 'NULL';
  const s = String(str).replace(/\\/g, '\\\\').replace(/'/g, "''");
  return `'${s}'`;
}

function toCuid(): string {
  const timestamp = Date.now().toString(36);
  const randomPart = Math.random().toString(36).substring(2, 15);
  return 'c' + timestamp + randomPart;
}

/** สร้างรหัสโรงเรียนจากชื่อ (เช่น โรงเรียนชุมชนศึกษา -> SCH_xxx) */
function schoolCodeFromName(name: string, index: number): string {
  const slug = name
    .replace(/โรงเรียน/g, '')
    .replace(/\s+/g, '_')
    .replace(/[()]/g, '')
    .substring(0, 20);
  return `SCH_${String(index + 1).padStart(3, '0')}_${slug}`.substring(0, 50);
}

/** แยกชื่อ-นามสกุล ( lastName ไม่เป็นค่าว่าง เพราะ Member.lastName ต้อง NOT NULL ) */
function parseName(full: string): { firstName: string; lastName: string } {
  const t = full.replace(/\s+/g, ' ').trim();
  const parts = t.split(' ').filter(Boolean);
  if (parts.length >= 2) {
    return { firstName: parts[0], lastName: parts.slice(1).join(' ') };
  }
  return { firstName: t || '—', lastName: '—' };
}

interface DataRow {
  schoolName: string;
  schoolCode: string;
  seq: number;
  fullName: string;
  firstName: string;
  lastName: string;
  position: string;
  phone: string;
}

interface ParsedResult {
  schools: { name: string; code: string; district: string; province: string }[];
  members: DataRow[];
}

function parseSheet(sheet: XLSX.WorkSheet, sheetName: string, schoolCode: string): DataRow[] {
  const raw = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '' }) as (string | number)[][];
  const rows: DataRow[] = [];
  let currentSchool = '';

  for (let r = 0; r < raw.length; r++) {
    const row = (raw[r] || []) as (string | number)[];
    const c0 = String(row[0] || '').trim();
    const c1 = String(row[1] || '').trim();
    const c2 = String(row[2] || '').trim();
    const c3 = String(row[3] || '').trim();

    if (c0.includes('โรงเรียน') || c1.includes('โรงเรียน')) {
      currentSchool = c0 || c1;
      continue;
    }
    if (!c0 && !c1) continue;
    if (c0 === 'ที่' || c1 === 'ชื่อ' || c0 === 'ลำดับ') continue;
    const fullCheck = (c1 || c0).toLowerCase();
    if (fullCheck.includes('บัญชี') || fullCheck.includes('รายชื่อ') || fullCheck.includes('ข้าราชการ') || fullCheck.includes('ทางการศึกษา')) continue;

    const seq = typeof row[0] === 'number' ? row[0] : parseInt(String(row[0]), 10) || 0;
    const fullName = c1 || c0;
    if (!fullName || fullName.length < 2) continue;

    const schoolName = currentSchool || sheetName;
    const { firstName, lastName } = parseName(fullName);
    if (!firstName || !lastName) continue;

    rows.push({
      schoolName,
      schoolCode,
      seq: Number(seq) || r + 1,
      fullName,
      firstName,
      lastName,
      position: c2,
      phone: c3,
    });
  }

  return rows;
}

function parseWorkbook(workbook: XLSX.WorkBook): ParsedResult {
  const schoolMap = new Map<string, { name: string; code: string }>();
  const allMembers: DataRow[] = [];

  workbook.SheetNames.forEach((sheetName, sheetIndex) => {
    const sheet = workbook.Sheets[sheetName];
    if (!sheet) return;

    // ชื่อโรงเรียน: ใช้ชื่อ sheet หรือหาใน sheet
    let schoolName = sheetName.trim();
    if (!schoolName.includes('โรงเรียน')) {
      const raw = XLSX.utils.sheet_to_json(sheet, { header: 1, defval: '' }) as (string | number)[][];
      for (const row of raw) {
        const cell = String((row as any)[0] || (row as any)[1] || '').trim();
        if (cell.includes('โรงเรียน')) {
          schoolName = cell;
          break;
        }
      }
    }

    if (!schoolName || schoolName.length < 3) return;

    const code = schoolCodeFromName(schoolName, sheetIndex);
    schoolMap.set(schoolName, { name: schoolName, code });

    const members = parseSheet(sheet, schoolName, code);
    allMembers.push(...members);
  });

  const schools = Array.from(schoolMap.values()).map((s) => ({
    ...s,
    district: DEFAULT_DISTRICT,
    province: DEFAULT_PROVINCE,
  }));

  return { schools, members: allMembers };
}

async function main() {
  if (!fs.existsSync(EXCEL_PATH)) {
    console.error('❌ ไม่พบไฟล์:', EXCEL_PATH);
    process.exit(1);
  }

  const workbook = XLSX.readFile(EXCEL_PATH);
  const { schools, members } = parseWorkbook(workbook);

  console.log('📚 พบโรงเรียน', schools.length, 'แห่ง');
  schools.forEach((s, i) => console.log(`   ${i + 1}. ${s.name} (${s.code})`));
  console.log('👥 พบสมาชิกรวม', members.length, 'รายการ');

  const ts = new Date().toISOString().slice(0, 10).replace(/-/g, '');
  const baseTime = '130000'; // ใช้ 13xxxx เพื่อไม่ชนกับ migrations ที่มีอยู่ (12xxxx)
  const now = new Date().toISOString().slice(0, 19).replace('T', ' ');

  // ========== Migration 1: School ==========
  const schoolMigrationName = `${ts}${baseTime}_seed_schools_from_excel`;
  const schoolMigrationDir = path.join(OUTPUT_PATH, schoolMigrationName);
  fs.mkdirSync(schoolMigrationDir, { recursive: true });

  const schoolInserts = schools.map(
    (s, i) => `
-- โรงเรียน ${i + 1}: ${s.name}
INSERT INTO \`School\` (\`id\`, \`code\`, \`name\`, \`district\`, \`province\`, \`isActive\`, \`createdAt\`, \`updatedAt\`)
SELECT ${escapeSql(toCuid())}, ${escapeSql(s.code)}, ${escapeSql(s.name)}, ${escapeSql(s.district)}, ${escapeSql(s.province)}, 1, '${now}', '${now}'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM \`School\` WHERE \`code\` = ${escapeSql(s.code)} OR \`name\` = ${escapeSql(s.name)});`,
  );

  const schoolSql = `-- Migration: Seed School จาก doc/member_data.xlsx (ทุก sheet)
-- สร้างโดย excel-to-migration.ts | โรงเรียนละ 1 sheet
-- จำนวน: ${schools.length} โรงเรียน

${schoolInserts.join('\n')}
`;
  fs.writeFileSync(path.join(schoolMigrationDir, 'migration.sql'), schoolSql, 'utf-8');
  console.log('\n✅ Migration 1 (School):', path.join(schoolMigrationDir, 'migration.sql'));

  // ========== Migration 2: Member ==========
  const memberSeedMigrationName = `${ts}130001_seed_members_from_excel`;
  const memberSeedMigrationDir = path.join(OUTPUT_PATH, memberSeedMigrationName);
  fs.mkdirSync(memberSeedMigrationDir, { recursive: true });

  const memberInsertsRaw = members.map((row, i) => {
    const id = toCuid();
    const memberNo = `M${String(i + 1).padStart(5, '0')}`;
    const schoolLike = row.schoolName.replace(/'/g, "''").substring(0, 50);
    return `-- แถว ${i + 1}: ${row.fullName} | ${row.schoolName}
INSERT INTO \`Member\` (\`id\`, \`memberNo\`, \`schoolId\`, \`memberTypeId\`, \`firstName\`, \`lastName\`, \`phone\`, \`joinDate\`, \`status\`, \`createdAt\`, \`updatedAt\`)
SELECT 
  ${escapeSql(id)},
  ${escapeSql(memberNo)},
  s.id,
  (SELECT id FROM \`MemberType\` ORDER BY id LIMIT 1),
  ${escapeSql(row.firstName)},
  ${escapeSql(row.lastName)},
  ${row.phone ? escapeSql(row.phone) : 'NULL'},
  '2020-01-01 00:00:00',
  'ACTIVE',
  '${now}',
  '${now}'
FROM \`School\` s
WHERE (s.code = ${escapeSql(row.schoolCode)} OR s.name = ${escapeSql(row.schoolName)} OR s.name LIKE ${escapeSql('%' + schoolLike + '%')})
  AND NOT EXISTS (
    SELECT 1 FROM \`Member\` m 
    WHERE m.schoolId = s.id AND m.firstName = ${escapeSql(row.firstName)} AND m.lastName = ${escapeSql(row.lastName)}
  )
LIMIT 1;`;
  });

  const memberSeedSql = `-- Migration: Seed Member จาก doc/member_data.xlsx
-- สร้างโดย excel-to-migration.ts | รวมข้อมูลทุก sheet
-- จำนวน: ${members.length} รายการ
-- หมายเหตุ: ต้องมี School และ MemberType แล้ว (รัน seed_schools และ prisma db seed ก่อน)

${memberInsertsRaw.join('\n')}
`;
  fs.writeFileSync(path.join(memberSeedMigrationDir, 'migration.sql'), memberSeedSql, 'utf-8');
  console.log('✅ Migration 2 (Member):', path.join(memberSeedMigrationDir, 'migration.sql'));

  // ========== Migration 3: AssociationMember ==========
  const assocMigrationName = `${ts}130002_seed_association_member_from_excel`;
  const memberMigrationDir = path.join(OUTPUT_PATH, assocMigrationName);
  fs.mkdirSync(memberMigrationDir, { recursive: true });

  const memberInserts = members.map((row, i) => {
    const id = toCuid();
    const schoolLike = row.schoolName.replace(/'/g, "''").substring(0, 50);

    return `
-- แถว ${i + 1}: ${row.fullName} | ${row.schoolName}
INSERT INTO \`AssociationMember\` (\`id\`, \`memberId\`, \`schoolId\`, \`memberTypeId\`, \`associationMemberNo\`, \`position\`, \`associationJoinDate\`, \`notes\`, \`createdAt\`, \`updatedAt\`)
SELECT 
  ${escapeSql(id)},
  m.id,
  m.schoolId,
  m.memberTypeId,
  m.memberNo,
  ${row.position ? escapeSql(row.position) : 'NULL'},
  m.joinDate,
  ${row.phone ? escapeSql('โทร ' + row.phone) : 'NULL'},
  '${now}',
  '${now}'
FROM \`Member\` m
INNER JOIN \`School\` s ON m.schoolId = s.id
WHERE m.firstName = ${escapeSql(row.firstName)}
  AND m.lastName = ${escapeSql(row.lastName)}
  AND (s.name = ${escapeSql(row.schoolName)} OR s.name LIKE ${escapeSql('%' + schoolLike + '%')} OR s.code = ${escapeSql(row.schoolCode)})
  AND NOT EXISTS (SELECT 1 FROM \`AssociationMember\` am WHERE am.memberId = m.id)
LIMIT 1;`;
  });

  const memberSql = `-- Migration: Seed AssociationMember จาก doc/member_data.xlsx
-- สร้างโดย excel-to-migration.ts | รวมข้อมูลทุก sheet
-- จำนวน: ${members.length} รายการ
-- หมายเหตุ: School ต้องมีอยู่แล้ว (รัน seed_schools ก่อน) และ Member ต้อง match ชื่อ+โรงเรียน

${memberInserts.join('\n')}
`;
  fs.writeFileSync(path.join(memberMigrationDir, 'migration.sql'), memberSql, 'utf-8');
  console.log('✅ Migration 3 (AssociationMember):', path.join(memberMigrationDir, 'migration.sql'));

  console.log('\n📋 ลำดับการรัน: 1) seed_schools  2) seed_members  3) seed_association_member');
}

main().catch(console.error);
