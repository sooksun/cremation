import type { DeathClaimStatus } from './api';

export function isDeadlineOverdue(deadline?: string | null, completed?: boolean): boolean {
  if (!deadline || completed) return false;
  return new Date(deadline) < new Date();
}

export function statusBadgeClass(status?: DeathClaimStatus, hasPayment?: boolean): string {
  if (hasPayment || status === 'PAID') return 'badge-success';
  if (status === 'READY_TO_PAY') return 'badge-info';
  if (status === 'FUND_COMPLETE') return 'badge-info';
  if (status === 'COLLECTING') return 'badge-warning';
  return 'badge-neutral';
}