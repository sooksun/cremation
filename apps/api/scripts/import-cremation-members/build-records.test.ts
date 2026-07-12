import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';
import { buildMemberRecords } from './build-records';

(async () => {
  const prisma = new PrismaClient();
  try {
    const s = readAllSources();
    const unknownId = await ensureUnknownSchool(prisma);
    const codeMap = await buildCodeToSchoolId(prisma, s);
    const { records, stats } = buildMemberRecords(s, codeMap, unknownId);

    assert.strictEqual(records.length, 603, `records = ${records.length}`);
    // memberNo unique + รูปแบบถูก
    const nos = new Set(records.map((r) => r.memberNo));
    assert.strictEqual(nos.size, 603, 'memberNo unique');
    assert.strictEqual(records[0].memberNo, 'M0001');
    assert.strictEqual(records[602].memberNo, 'M0603');
    // idCard: valid 13 หลักทุกตัว
    assert.ok(records.every((r) => /^\d{13}$/.test(r.idCard)), 'all idCard 13 digits');
    // school resolution: 41 คนเข้า unknown
    assert.strictEqual(stats.unknownSchool, 41, `unknownSchool = ${stats.unknownSchool}`);
    assert.strictEqual(stats.withSchoolCode, 562, `withSchoolCode = ${stats.withSchoolCode}`);
    // type: ~571 REG จาก ขรก, ~1 PERM จาก ลจ (31 ไม่รู้ = REG)
    assert.ok(stats.typePerm >= 1, `typePerm = ${stats.typePerm}`);
    assert.strictEqual(stats.typeReg + stats.typePerm, 603, 'type total = 603');
    // firstName คงคำนำหน้า
    assert.ok(records.every((r) => r.firstName.length > 0 && r.lastName !== undefined));
    console.log('build-records: passed', stats);
  } finally {
    await prisma.$disconnect();
  }
})();
