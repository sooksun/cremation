import assert from 'node:assert';
import * as fs from 'fs';
import { readAllSources, DOC_DIR } from './sources';

assert.ok(fs.existsSync(DOC_DIR), `DOC_DIR must exist: ${DOC_DIR}`);
const s = readAllSources();

// F1: 603 สมาชิกจริง (กรอง total row money=60300 ออกแล้ว)
assert.strictEqual(s.f1.length, 603, `f1 length = ${s.f1.length}`);
assert.ok(/^\d{13}$/.test(s.f1[0].idCard), 'f1[0].idCard is 13 digits');

// F2: ขรก ~2180 + ลจ ~18
assert.ok(s.f2ById.size >= 2190 && s.f2ById.size <= 2200, `f2 size = ${s.f2ById.size}`);
assert.ok(['ขรก', 'ลจ.'].includes([...s.f2ById.values()][0].type));

// F3: 609 คน มีรหัสโรงเรียน
assert.strictEqual(s.f3IdToCode.size, 609, `f3 size = ${s.f3IdToCode.size}`);

// F4: 31 sheets
assert.strictEqual(s.f4SheetNames.length, 31, `f4 sheets = ${s.f4SheetNames.length}`);
assert.ok(s.f4NameToInfo.size >= 700, `f4 names = ${s.f4NameToInfo.size}`);

console.log('sources: all assertions passed', {
  f1: s.f1.length, f2: s.f2ById.size, f3: s.f3IdToCode.size,
  f4names: s.f4NameToInfo.size, f4sheets: s.f4SheetNames.length,
});
