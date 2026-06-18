import { MembershipClass } from '@prisma/client';

/** ข้อ 7.1 — สมาชิกสามัญ: ข้าราชการครู, ลูกจ้างประจำ */
export const ORDINARY_MEMBER_TYPE_CODES = ['REG', 'PERM'];

/** ข้อ 7.2 — สมาชิกสมทบ */
export const CONTRIBUTORY_MEMBER_TYPE_CODES = ['RET', 'STF'];

/** ข้อ 8 — ยื่นใบสมัครภายใน 30 วันนับจากวันเริ่มปฏิบัติงาน */
export const APPLICATION_DEADLINE_DAYS = 30;

/** ข้อ 9.2.3 — สมทบค้างชำระ 3 งวดติดต่อหลังแจ้งเตือน */
export const ARREARS_TERMINATION_PERIODS = 3;

export function resolveMembershipClass(params: {
  memberTypeCode: string;
  salaryDeduction?: boolean;
  explicitClass?: MembershipClass;
  formType?: 'ordinary' | 'contributory';
}): MembershipClass {
  if (params.explicitClass) return params.explicitClass;
  if (params.formType === 'ordinary') return MembershipClass.ORDINARY;
  if (params.formType === 'contributory') return MembershipClass.CONTRIBUTORY;
  if (params.salaryDeduction) return MembershipClass.ORDINARY;
  if (ORDINARY_MEMBER_TYPE_CODES.includes(params.memberTypeCode)) {
    return MembershipClass.ORDINARY;
  }
  return MembershipClass.CONTRIBUTORY;
}

export function computeApplicationDeadline(joinDate: Date): Date {
  const deadline = new Date(joinDate);
  deadline.setDate(deadline.getDate() + APPLICATION_DEADLINE_DAYS);
  return deadline;
}

const SPOUSE_KEYWORDS = ['สามี', 'ภรรยา', 'คู่สมรส', 'สามี/ภรรยา'];
const PARENT_KEYWORDS = ['บิดา', 'มารดา', 'พ่อ', 'แม่', 'บิดา/มารดา'];
const CHILD_KEYWORDS = ['บุตร', 'ธิดา', 'ลูก', 'บุตร/ธิดา', 'บุตรชาย', 'บุตรสาว'];

export function parseProtectedRelationship(
  text: string,
): 'SPOUSE' | 'PARENT' | 'CHILD' | null {
  const normalized = text.trim();
  if (!normalized) return null;
  if (SPOUSE_KEYWORDS.some((k) => normalized.includes(k))) return 'SPOUSE';
  if (PARENT_KEYWORDS.some((k) => normalized.includes(k))) return 'PARENT';
  if (CHILD_KEYWORDS.some((k) => normalized.includes(k))) return 'CHILD';
  return null;
}

export function splitFullName(fullName: string): { firstName: string; lastName: string } {
  const parts = fullName.trim().split(/\s+/);
  if (parts.length <= 1) return { firstName: parts[0] || '', lastName: '' };
  return { firstName: parts[0], lastName: parts.slice(1).join(' ') };
}