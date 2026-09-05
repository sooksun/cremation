import * as fs from 'fs';
import * as path from 'path';

/**
 * ชื่อตารางใน migration ต้องตรงตัวพิมพ์กับ schema.prisma เป๊ะ ๆ
 *
 * MySQL บน Windows ตั้ง lower_case_table_names=1 ชื่อตารางจึงไม่แยกตัวพิมพ์
 * แต่ MariaDB บน Linux (เครื่อง production) ใช้ค่า 0 ซึ่งแยกตัวพิมพ์
 * SQL ที่เขียน `paymentvoucher` จึงผ่านบนเครื่อง dev แต่ล้มด้วย error 1146
 * "Table doesn't exist" บน production แล้วทำให้ prisma migrate deploy ค้าง
 * และ container ของ api วนรีสตาร์ท จนกว่าจะ migrate resolve ด้วยมือ
 *
 * `prisma migrate diff --script` คืนชื่อตารางเป็นตัวพิมพ์เล็กทั้งหมด การนำผลลัพธ์
 * มาใส่ migration ตรง ๆ จึงเป็นกับดักที่เทสต์นี้มีไว้ดัก
 */
describe('migration SQL — ชื่อตารางต้องตรงตัวพิมพ์กับ schema.prisma', () => {
  const prismaDir = path.join(__dirname, '..', '..', 'prisma');
  const schema = fs.readFileSync(path.join(prismaDir, 'schema.prisma'), 'utf-8');
  const models = [...schema.matchAll(/^model\s+(\w+)/gm)].map((m) => m[1]);
  const byLower = new Map(models.map((m) => [m.toLowerCase(), m]));

  const migrationsDir = path.join(prismaDir, 'migrations');
  const files = fs
    .readdirSync(migrationsDir)
    .filter((d) => fs.existsSync(path.join(migrationsDir, d, 'migration.sql')));

  it('อ่านสคีมาและ migration ได้จริง', () => {
    expect(models.length).toBeGreaterThan(0);
    expect(files.length).toBeGreaterThan(0);
  });

  it.each(files)('%s อ้างชื่อตารางถูกตัวพิมพ์', (dir) => {
    const sql = fs.readFileSync(path.join(migrationsDir, dir, 'migration.sql'), 'utf-8');

    const refs = [
      ...[
        ...sql.matchAll(
          /(?:ALTER TABLE|CREATE TABLE(?: IF NOT EXISTS)?|INSERT INTO|UPDATE|ON)\s+`([A-Za-z_]+)`/g,
        ),
      ].map((m) => m[1]),
      ...[...sql.matchAll(/TABLE_NAME\s*=\s*'([A-Za-z_]+)'/g)].map((m) => m[1]),
    ];

    // สนใจเฉพาะตารางที่ยังอยู่ในสคีมาปัจจุบัน ตารางเก่าที่ถูกถอดไปแล้วไม่ต้องตรวจ
    const wrongCase = [...new Set(refs)].filter((ref) => {
      const canonical = byLower.get(ref.toLowerCase());
      return canonical !== undefined && canonical !== ref;
    });

    expect(wrongCase).toEqual([]);
  });
});
