import * as fs from 'fs';
import * as path from 'path';

/**
 * ชื่อตารางใน raw SQL ต้องตรงตัวพิมพ์กับชื่อโมเดลใน schema.prisma
 *
 * MySQL บนวินโดวส์ตั้ง lower_case_table_names=1 จึงไม่แยกตัวพิมพ์
 * แต่ MariaDB บน production ตั้ง 0 ซึ่งแยก การเขียน `thaiaddress` ตัวเล็ก
 * จึงผ่านตอนพัฒนาแต่พังบนเครื่องจริงด้วย error 1146 Table doesn't exist
 *
 * เทสต์นี้คู่กับ migration-table-case.spec.ts ที่ตรวจฝั่งไฟล์ migration
 */
const SRC = path.join(__dirname, '..');
const SCHEMA = path.join(__dirname, '../../prisma/schema.prisma');

function listModels(): string[] {
  const schema = fs.readFileSync(SCHEMA, 'utf8');
  return [...schema.matchAll(/^model\s+(\w+)\s*\{/gm)].map((m) => m[1]);
}

function walk(dir: string, out: string[] = []): string[] {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(full, out);
    else if (entry.name.endsWith('.ts') && !entry.name.endsWith('.spec.ts')) out.push(full);
  }
  return out;
}

describe('ชื่อตารางใน raw SQL', () => {
  const models = listModels();
  const byLower = new Map(models.map((m) => [m.toLowerCase(), m]));
  const files = walk(SRC);

  it('มีโมเดลใน schema ให้ตรวจ', () => {
    expect(models.length).toBeGreaterThan(10);
  });

  it('ทุกไฟล์ต้องอ้างชื่อตารางตรงตัวพิมพ์กับ schema.prisma', () => {
    const problems: string[] = [];

    for (const file of files) {
      const source = fs.readFileSync(file, 'utf8');
      if (!/queryRaw|executeRaw/.test(source)) continue;

      // ชื่อที่ตามหลังคำสั่ง SQL ที่อ้างตาราง
      const refs = source.matchAll(/\b(FROM|JOIN|INTO|UPDATE)\s+`?([A-Za-z_][A-Za-z0-9_]*)`?/gi);
      for (const ref of refs) {
        const used = ref[2];
        const canonical = byLower.get(used.toLowerCase());
        if (!canonical) continue; // ไม่ใช่ตารางของเรา เช่น information_schema
        if (canonical !== used) {
          problems.push(`${path.relative(SRC, file)}: เขียน "${used}" ต้องเป็น "${canonical}"`);
        }
      }
    }

    expect(problems).toEqual([]);
  });
});
