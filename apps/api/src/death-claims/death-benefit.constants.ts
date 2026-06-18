import { DeathClaimType } from '@prisma/client';

/** ข้อ 13.1 / 13.2 ระเบียบ ฌ.ป.ส.ค.แม่ฟ้าหลวง พ.ศ. 2568 */
export const DEATH_COLLECTION_RATES: Record<DeathClaimType, number> = {
  [DeathClaimType.MEMBER_DEATH]: 100,
  [DeathClaimType.PROTECTED_DEATH]: 50,
};

/** ข้อ 16 — จ่ายผู้มีสิทธิ 90%, เข้ากองทุน 10% */
export const DEATH_PAYOUT_RATIO = 0.9;
export const DEATH_FUND_RESERVE_RATIO = 0.1;