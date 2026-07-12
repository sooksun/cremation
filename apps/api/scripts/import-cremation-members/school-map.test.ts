import assert from 'node:assert';
import { PrismaClient } from '@prisma/client';
import { readAllSources } from './sources';
import { ensureUnknownSchool, buildCodeToSchoolId } from './school-map';

(async () => {
  const prisma = new PrismaClient();
  try {
    const s = readAllSources();
    const unknownId = await ensureUnknownSchool(prisma);
    assert.ok(unknownId, 'unknown school id');
    const map = await buildCodeToSchoolId(prisma, s);
    // ทุกรหัสใน F3 ต้อง map ได้ (ไม่ throw) และ 410/417 ต้องอยู่
    assert.ok(map.size >= 29, `mapped codes = ${map.size}`);
    assert.ok(map.has('410') && map.has('417'), 'hardcode 410/417 mapped');
    console.log('school-map: passed', { mappedCodes: map.size, unknownId });
  } finally {
    await prisma.$disconnect();
  }
})();
