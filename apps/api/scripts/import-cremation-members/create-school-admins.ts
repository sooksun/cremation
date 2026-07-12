/**
 * สร้าง SCHOOL_ADMIN ให้ 31 โรงเรียนจริงของแม่ฟ้าหลวง (SCH_XXX)
 * - fullName = คนลำดับที่ 2 ของแต่ละโรงเรียน (จาก member_data.xlsx)
 * - username = admin-{schoolCode}, password = school@2569 (mustChangePassword=true)
 * - ผูก memberId ถ้าคนลำดับ 2 เป็นสมาชิกฌาปนกิจ (match ด้วยชื่อ), กัน memberId ซ้ำ
 * - Idempotent: มี admin อยู่แล้ว → update, ยังไม่มี → create
 *
 * รัน: npx ts-node --project tsconfig.json scripts/import-cremation-members/create-school-admins.ts
 */
import * as path from 'path';
import * as XLSX from 'xlsx';
import * as bcrypt from 'bcrypt';
import { PrismaClient, Role } from '@prisma/client';
import { nameKey } from './name-utils';
import { schoolNameKey } from './school-map';

const F4 = path.join(__dirname, '../../../../doc/member/member_data.xlsx');
const DEFAULT_PASSWORD = 'school@2569';

function cell(v: unknown): string {
  if (v === null || v === undefined) return '';
  const s = String(v).trim();
  return s === 'nan' ? '' : s;
}

/** ดึงชื่อคนลำดับที่ 2 จาก sheet — handle บ้านกลางที่ชื่อ/สกุลแยก 2 คอลัมน์ */
function extractSecondPersonName(rows: unknown[][], sheetName: string): string {
  const splitName = /บ้านกลาง/.test(sheetName); // sheet นี้แยกชื่อ-สกุลเป็น col1|col2
  for (const r of rows) {
    if (cell(r[0]) !== '2') continue;
    const c1 = cell(r[1]);
    if (splitName) {
      const c2 = cell(r[2]);
      return c2 ? `${c1} ${c2}` : c1;
    }
    return c1;
  }
  return '';
}

async function main() {
  const prisma = new PrismaClient();
  try {
    const wb = XLSX.readFile(F4, { codepage: 65001 });

    // โรงเรียนจริง (SCH_) index ด้วย name key
    const dbSchools = await prisma.school.findMany({ select: { id: true, code: true, name: true } });
    const dbByKey = new Map<string, { id: string; code: string; name: string }>();
    for (const sc of dbSchools) if (sc.code.startsWith('SCH_')) dbByKey.set(schoolNameKey(sc.name), sc);
    const findSchool = (title: string, sheet: string) => {
      for (const cand of [schoolNameKey(title), schoolNameKey(sheet)]) {
        if (!cand) continue;
        for (const [k, v] of dbByKey) if (k.includes(cand) || cand.includes(k)) return v;
      }
      return null;
    };

    // สมาชิก: nameKey(firstName+lastName) → memberId
    const members = await prisma.member.findMany({
      select: { id: true, associationMember: { select: { firstName: true, lastName: true } } },
    });
    const memberByName = new Map<string, string>();
    for (const m of members) {
      const k = nameKey((m.associationMember.firstName ?? '') + (m.associationMember.lastName ?? ''));
      if (k && !memberByName.has(k)) memberByName.set(k, m.id);
    }

    // memberId ที่มี user ผูกอยู่แล้ว (กันชน unique)
    const usedMemberIds = new Set<string>(
      (await prisma.user.findMany({ where: { memberId: { not: null } }, select: { memberId: true } }))
        .map((u) => u.memberId as string),
    );

    const passwordHash = await bcrypt.hash(DEFAULT_PASSWORD, 10);

    let created = 0, updated = 0, linked = 0, skippedSchool = 0;
    const report: { code: string; fullName: string; member: boolean; action: string }[] = [];

    for (const sheetName of wb.SheetNames) {
      const rows = XLSX.utils.sheet_to_json(wb.Sheets[sheetName], { header: 1, raw: false, defval: '' }) as unknown[][];
      const title = rows.length > 1 ? cell(rows[1][0]) : '';
      const school = findSchool(title, sheetName);
      if (!school) { skippedSchool++; console.warn(`⚠️ ไม่พบโรงเรียนใน DB สำหรับ sheet: ${sheetName}`); continue; }

      const fullName = extractSecondPersonName(rows, sheetName);
      if (!fullName) { console.warn(`⚠️ ไม่พบคนลำดับ 2 ใน sheet: ${sheetName}`); continue; }

      // resolve memberId (match ชื่อ + ยังไม่ถูกผูก)
      const mkey = nameKey(fullName) ?? '';
      let memberId: string | null = memberByName.get(mkey) ?? null;
      if (memberId && usedMemberIds.has(memberId)) {
        console.warn(`⚠️ memberId ของ "${fullName}" ถูกผูกกับ user อื่นแล้ว — สร้าง admin โดยไม่ผูก`);
        memberId = null;
      }

      const username = `admin-${school.code.toLowerCase()}`;

      // idempotent: หา SCHOOL_ADMIN เดิมของโรงเรียนนี้
      const existing = await prisma.user.findFirst({
        where: { role: Role.SCHOOL_ADMIN, schoolId: school.id },
      });

      if (existing) {
        await prisma.user.update({
          where: { id: existing.id },
          data: { fullName, memberId: memberId ?? undefined },
        });
        updated++;
        if (memberId) { usedMemberIds.add(memberId); linked++; }
        report.push({ code: school.code, fullName, member: !!memberId, action: 'update' });
      } else {
        // กัน username ชนกับ user อื่น (นอกโรงเรียน)
        const usernameTaken = await prisma.user.findUnique({ where: { username } });
        const finalUsername = usernameTaken ? `${username}-${school.id.slice(-4)}` : username;
        await prisma.user.create({
          data: {
            username: finalUsername,
            passwordHash,
            fullName,
            role: Role.SCHOOL_ADMIN,
            schoolId: school.id,
            memberId: memberId ?? undefined,
            mustChangePassword: true,
          },
        });
        created++;
        if (memberId) { usedMemberIds.add(memberId); linked++; }
        report.push({ code: school.code, fullName, member: !!memberId, action: 'create' });
      }
    }

    // validate — นับสถานะจริงจาก DB ด้วย REGEXP (เลี่ยง LIKE wildcard ของ '_' ใน startsWith)
    const statRows = await prisma.$queryRawUnsafe<{ total: bigint; linked: bigint }[]>(
      "SELECT COUNT(*) AS total, SUM(u.memberId IS NOT NULL) AS linked " +
        "FROM `User` u JOIN `School` s ON u.schoolId=s.id " +
        "WHERE u.role='SCHOOL_ADMIN' AND s.code REGEXP '^SCH_'",
    );
    const total = Number(statRows[0].total);
    const linkedInDb = Number(statRows[0].linked);

    console.log('\n=== รายงาน ===');
    for (const r of report) {
      console.log(`${r.action.padEnd(6)} | ${r.code.padEnd(30)} | ${r.member ? '🔗' : '  '} ${r.fullName}`);
    }
    console.log('\n=== สรุป ===');
    console.log({ createdThisRun: created, updatedThisRun: updated, linkedThisRun: linked, skippedSchool, adminForRealSchools: total, linkedMemberInDb: linkedInDb });
    if (created + updated !== 31) console.warn(`⚠️ คาดหวัง 31 โรงเรียน แต่ทำได้ ${created + updated}`);
    else console.log('✅ สร้าง/อัปเดต SCHOOL_ADMIN ครบ 31 โรงเรียน');
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((e) => { console.error(e); process.exit(1); });
