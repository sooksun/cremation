import * as fs from 'fs';
import * as path from 'path';

/**
 * รายการ overrides ต้องเขียนไว้สองที่ให้ตรงกัน
 *
 * pnpm 11 บนเครื่องพัฒนาอ่าน overrides จาก pnpm-workspace.yaml
 * ส่วน Dockerfile ตรึง pnpm ไว้ที่ 9.15.4 ซึ่งอ่านจาก package.json (pnpm.overrides)
 * ถ้าสองที่ไม่ตรงกัน `pnpm install --frozen-lockfile` ใน Docker จะล้มด้วย
 * ERR_PNPM_LOCKFILE_CONFIG_MISMATCH คือ build ไม่ผ่านตั้งแต่ต้น
 *
 * ไม่ขยับ pnpm ใน Docker ให้เท่าเครื่องพัฒนา เพราะ `pnpm deploy --prod` ที่
 * Dockerfile.api ใช้มีพฤติกรรมเฉพาะเวอร์ชัน และเป็นเส้นทาง build ของ production
 */
const ROOT = path.join(__dirname, '../../../..');

function fromWorkspaceYaml(): Record<string, string> {
  const text = fs.readFileSync(path.join(ROOT, 'pnpm-workspace.yaml'), 'utf8');
  const section = text.split('\noverrides:')[1];
  if (!section) return {};

  const result: Record<string, string> = {};
  for (const line of section.split('\n')) {
    if (line.trim() === '') continue;
    // ออกจากบล็อกเมื่อเจอบรรทัดที่ไม่ได้เยื้อง
    if (!/^\s/.test(line)) break;
    const match = /^\s+([@\w\-/.]+):\s*'?([^'\s]+)'?/.exec(line);
    if (match) result[match[1]] = match[2];
  }
  return result;
}

function fromPackageJson(): Record<string, string> {
  const pkg = JSON.parse(fs.readFileSync(path.join(ROOT, 'package.json'), 'utf8'));
  return pkg?.pnpm?.overrides ?? {};
}

describe('pnpm overrides', () => {
  const workspace = fromWorkspaceYaml();
  const packageJson = fromPackageJson();

  it('อ่านทั้งสองไฟล์ได้และมีรายการอยู่จริง', () => {
    expect(Object.keys(workspace).length).toBeGreaterThan(0);
  });

  it('pnpm-workspace.yaml กับ package.json ต้องมีรายการตรงกันทุกตัว', () => {
    expect(packageJson).toEqual(workspace);
  });
});
