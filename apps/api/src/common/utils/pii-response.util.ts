import { Role } from '@prisma/client';
import { applyIdCardMask, applyNationalIdMask } from './pii.util';

export function maskAssociationMemberRow<T extends { idCardNo?: string | null }>(
  row: T,
  role: Role,
): T {
  return applyIdCardMask(row, role);
}

export function maskMemberWithAssociation<
  T extends { associationMember?: { idCardNo?: string | null } | null },
>(member: T, role: Role): T {
  if (!member.associationMember) {
    return member;
  }
  return {
    ...member,
    associationMember: maskAssociationMemberRow(member.associationMember, role),
  };
}

export function maskAssociationMemberListResponse(
  result: { data: Array<{ idCardNo?: string | null }>; meta: unknown },
  role: Role,
) {
  return {
    ...result,
    data: result.data.map((row) => maskAssociationMemberRow(row, role)),
  };
}

export function maskMemberListResponse<
  T extends { associationMember?: { idCardNo?: string | null } | null },
>(result: { data: T[]; meta: unknown }, role: Role) {
  return {
    ...result,
    data: result.data.map((row) => maskMemberWithAssociation(row, role)),
  };
}

export function maskProtectedPersonRow<T extends { nationalId?: string | null }>(
  row: T,
  role: Role,
): T {
  return applyNationalIdMask(row, role);
}

export function maskProtectedPersonList<T extends { nationalId?: string | null }>(
  rows: T[],
  role: Role,
): T[] {
  return rows.map((row) => maskProtectedPersonRow(row, role));
}