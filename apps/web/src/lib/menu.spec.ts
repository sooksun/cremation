import { menuItems, type MenuItem, type MenuLeaf } from './menu';
import { isPathAllowedForRole } from './route-access';

const ROLES = [
  'ADMIN',
  'SCHOOL_ADMIN',
  'FINANCE',
  'ACCOUNTING',
  'GROUP_LEADER',
  'VIEWER',
] as const;

type Entry = { label: string; href: string; roles?: string[] };

/** ทุกรายการเมนูที่กดเข้าไปได้จริง พร้อมบทบาทที่มองเห็นมัน */
function visibleEntries(): Entry[] {
  const out: Entry[] = [];
  for (const item of menuItems as MenuItem[]) {
    if (item.href) out.push({ label: item.label, href: item.href, roles: item.roles });
    for (const child of (item.children ?? []) as MenuLeaf[]) {
      // เมนูลูกมองเห็นได้ก็ต่อเมื่อทั้งหัวข้อและตัวมันเองอนุญาตบทบาทนั้น
      const roles =
        item.roles && child.roles
          ? item.roles.filter((r) => child.roles!.includes(r))
          : (child.roles ?? item.roles);
      out.push({ label: child.label, href: child.href, roles });
    }
  }
  return out;
}

const entries = visibleEntries();

describe('เมนูข้างกับตัวกันเส้นทาง', () => {
  it('มีรายการเมนูให้ตรวจ', () => {
    expect(entries.length).toBeGreaterThan(20);
  });

  /**
   * เงื่อนไขที่ห้ามผิด: เห็นเมนูแล้วต้องกดเข้าไปได้
   *
   * ถ้าผิด ผู้ใช้จะเห็นเมนู กดเข้าไป แล้วถูกเด้งกลับโดยไม่มีคำอธิบาย
   * ซึ่งดูเหมือนระบบพัง ไม่ใช่เหมือนการปฏิเสธสิทธิ์
   */
  it.each(ROLES)('บทบาท %s: เมนูที่มองเห็นต้องกดเข้าไปได้ทุกอัน', (role) => {
    const blocked = entries
      .filter((e) => !e.roles || e.roles.includes(role))
      .filter((e) => !isPathAllowedForRole(e.href, role))
      .map((e) => `${e.label} (${e.href})`);

    expect(blocked).toEqual([]);
  });

  it('ชื่อบทบาทในเมนูต้องสะกดถูกทุกที่', () => {
    const known = new Set<string>([...ROLES, 'MEMBER']);
    const unknown = entries.flatMap((e) => e.roles ?? []).filter((r) => !known.has(r));

    expect([...new Set(unknown)]).toEqual([]);
  });
});

/**
 * ทิศทางกลับกัน — เมนูซ่อนไว้แต่พิมพ์ URL เข้าได้
 *
 * ไม่ได้บังคับให้เป็นศูนย์ เพราะ route-access.ts เป็นรายการปิดกั้นแบบหยาบ ส่วนเมนู
 * เป็นรายการนำทางที่คัดมาแล้ว และตัวตัดสินจริงคือ RolesGuard ฝั่ง API ซึ่งหลายกรณี
 * อนุญาตกว้างกว่าเมนู เช่น /assets ที่ AssetsController เปิดให้ SCHOOL_ADMIN อยู่แล้ว
 * เมนูแค่ไม่ได้ลิงก์ไว้
 *
 * บันทึกไว้เป็นรายการอ้างอิงแทน เพื่อให้การเปลี่ยนแปลงครั้งหน้าที่ทำให้รายการนี้
 * โตขึ้นหรือเล็กลงต้องถูกพิจารณา ไม่ใช่หลุดไปเงียบ ๆ
 */
describe('เส้นทางที่เมนูซ่อนแต่ยังเข้าถึงได้ (รายการอ้างอิง)', () => {
  const KNOWN: Record<string, string[]> = {
    ADMIN: [],
    FINANCE: [],
    SCHOOL_ADMIN: ['/assets'],
    ACCOUNTING: ['/reports'],
    GROUP_LEADER: [
      '/dashboard/finance', '/school-admins', '/assets', '/association-members',
      '/bank', '/reports/finance', '/reports/financial-statements', '/reports/daily',
      '/reports/trial-balance', '/reports', '/reports/executive', '/reports/board-monthly',
      '/members', '/contributions/arrears', '/receipts', '/payments', '/death-claims',
      '/settings/signature', '/audit-logs',
    ],
    VIEWER: [
      '/dashboard/finance', '/school-admins', '/assets', '/association-members',
      '/bank', '/reports/finance', '/reports/financial-statements', '/reports/daily',
      '/reports/trial-balance', '/reports', '/reports/executive', '/reports/board-monthly',
      '/members', '/contributions/periods', '/contributions/matrix', '/contributions/arrears',
      '/receipts', '/payments', '/death-claims', '/audit-logs',
    ],
  };

  it.each(ROLES)('บทบาท %s ตรงกับรายการอ้างอิง', (role) => {
    const actual = [
      ...new Set(
        entries
          .filter((e) => e.roles && !e.roles.includes(role))
          .filter((e) => isPathAllowedForRole(e.href, role))
          .map((e) => e.href),
      ),
    ].sort();

    expect(actual).toEqual([...KNOWN[role]].sort());
  });
});
