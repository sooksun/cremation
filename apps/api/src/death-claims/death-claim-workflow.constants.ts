import {
  DeathClaimStatus,
  DeathClaimType,
  DeathCollectionChannel,
  MembershipClass,
} from '@prisma/client';

export interface DocumentChecklistItem {
  key: string;
  label: string;
  required: boolean;
  checked: boolean;
  checkedAt?: string;
}

export interface DeathClaimWorkflowDeadlines {
  collectionChannel: DeathCollectionChannel;
  notifyAuthorityDeadline: Date | null;
  collectionDeadline: Date;
  documentDeadline: Date;
  paymentDeadline: Date;
}

const BASE_CHECKLIST: DocumentChecklistItem[] = [
  { key: 'death_certificate', label: 'ใบมรณบัตร', required: true, checked: false },
  { key: 'beneficiary_id', label: 'สำเนาบัตรประชาชนผู้รับเงิน', required: true, checked: false },
  { key: 'bank_book', label: 'สำเนาสมุดบัญชีผู้รับเงิน', required: true, checked: false },
];

const ORDINARY_EXTRA: DocumentChecklistItem[] = [
  { key: 'authority_notice', label: 'หนังสือแจ้ง สพป. (หักเงินเดือน)', required: true, checked: false },
];

const PROTECTED_EXTRA: DocumentChecklistItem[] = [
  { key: 'relationship_proof', label: 'หลักฐานความสัมพันธ์ผู้เสียชีวิต', required: true, checked: false },
];

/** วันที่ 5 ของเดือนถัดไปจากอ้างอิง */
export function nthDayOfNextMonth(ref: Date, day: number): Date {
  const d = new Date(ref);
  d.setHours(0, 0, 0, 0);
  d.setDate(1);
  d.setMonth(d.getMonth() + 1);
  d.setDate(day);
  return d;
}

/** วันที่ N ของเดือนถัดไปจากอ้างอิง (ใช้กับ deathDate) */
export function nthDayAfterDeathMonth(deathDate: Date, day: number): Date {
  const d = new Date(deathDate);
  d.setHours(0, 0, 0, 0);
  d.setDate(1);
  d.setMonth(d.getMonth() + 1);
  d.setDate(day);
  return d;
}

export function addDays(ref: Date, days: number): Date {
  const d = new Date(ref);
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() + days);
  return d;
}

export function resolveCollectionChannel(params: {
  membershipClass: MembershipClass;
  salaryDeduction?: boolean;
}): DeathCollectionChannel {
  if (params.membershipClass === MembershipClass.ORDINARY || params.salaryDeduction) {
    return DeathCollectionChannel.SALARY_DEDUCTION;
  }
  return DeathCollectionChannel.BANK_TRANSFER;
}

/** ข้อ 13.3 / 17 / 18 — กำหนด deadline ตามประเภทสมาชิก */
export function computeWorkflowDeadlines(params: {
  deathDate: Date;
  reportedDate: Date;
  membershipClass: MembershipClass;
  salaryDeduction?: boolean;
}): DeathClaimWorkflowDeadlines {
  const channel = resolveCollectionChannel(params);
  const isOrdinary = channel === DeathCollectionChannel.SALARY_DEDUCTION;

  return {
    collectionChannel: channel,
    notifyAuthorityDeadline: isOrdinary
      ? nthDayOfNextMonth(params.reportedDate, 5)
      : null,
    collectionDeadline: isOrdinary
      ? nthDayOfNextMonth(params.reportedDate, 5)
      : addDays(params.deathDate, 15),
    documentDeadline: nthDayAfterDeathMonth(params.deathDate, 15),
    paymentDeadline: nthDayAfterDeathMonth(params.deathDate, 30),
  };
}

export function buildDefaultDocumentChecklist(params: {
  claimType: DeathClaimType;
  membershipClass: MembershipClass;
  salaryDeduction?: boolean;
}): DocumentChecklistItem[] {
  const items = [...BASE_CHECKLIST];
  if (
    params.membershipClass === MembershipClass.ORDINARY ||
    params.salaryDeduction
  ) {
    items.push(...ORDINARY_EXTRA);
  }
  if (params.claimType === DeathClaimType.PROTECTED_DEATH) {
    items.push(...PROTECTED_EXTRA);
  }
  return items;
}

export function parseDocumentChecklist(raw: unknown): DocumentChecklistItem[] {
  if (!Array.isArray(raw)) return [];
  return raw.filter(
    (item): item is DocumentChecklistItem =>
      typeof item === 'object' &&
      item !== null &&
      typeof (item as DocumentChecklistItem).key === 'string' &&
      typeof (item as DocumentChecklistItem).label === 'string',
  );
}

export function isChecklistComplete(items: DocumentChecklistItem[]): boolean {
  return items.filter((i) => i.required).every((i) => i.checked);
}

export function deriveStatusAfterCollection(params: {
  currentStatus: DeathClaimStatus;
  collectedAmount: number;
  targetAmount: number;
  documentsComplete: boolean;
}): DeathClaimStatus {
  if (params.collectedAmount >= params.targetAmount) {
    return params.documentsComplete
      ? DeathClaimStatus.READY_TO_PAY
      : DeathClaimStatus.FUND_COMPLETE;
  }
  if (params.currentStatus === DeathClaimStatus.REPORTED) {
    return DeathClaimStatus.COLLECTING;
  }
  return params.currentStatus;
}

/** Derives workflow status for PATCH /workflow — PAID is never set here. */
export function resolveWorkflowStatus(params: {
  currentStatus: DeathClaimStatus;
  collectedAmount: number;
  targetAmount: number;
  documentsComplete: boolean;
  startCollecting?: boolean;
  collectedAmountChanged?: boolean;
}): DeathClaimStatus {
  if (params.collectedAmountChanged) {
    const baseStatus =
      params.startCollecting && params.currentStatus === DeathClaimStatus.REPORTED
        ? DeathClaimStatus.COLLECTING
        : params.currentStatus;
    return deriveStatusAfterCollection({
      currentStatus: baseStatus,
      collectedAmount: params.collectedAmount,
      targetAmount: params.targetAmount,
      documentsComplete: params.documentsComplete,
    });
  }

  if (params.startCollecting) {
    return DeathClaimStatus.COLLECTING;
  }

  return params.currentStatus;
}

export const DEATH_CLAIM_STATUS_LABELS: Record<DeathClaimStatus, string> = {
  [DeathClaimStatus.REPORTED]: 'แจ้งแล้ว',
  [DeathClaimStatus.COLLECTING]: 'กำลังเก็บเงิน',
  [DeathClaimStatus.FUND_COMPLETE]: 'เก็บครบแล้ว',
  [DeathClaimStatus.READY_TO_PAY]: 'พร้อมจ่าย',
  [DeathClaimStatus.PAID]: 'จ่ายแล้ว',
};

export const DEATH_COLLECTION_CHANNEL_LABELS: Record<DeathCollectionChannel, string> = {
  [DeathCollectionChannel.SALARY_DEDUCTION]: 'หักผ่านเงินเดือน (สามัญ)',
  [DeathCollectionChannel.BANK_TRANSFER]: 'โอนเงิน (สมทบ)',
};