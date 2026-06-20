import { Role } from '@prisma/client';

const PII_FULL_ACCESS_ROLES: Role[] = [Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE];

export function maskIdCardNo(idCardNo?: string | null): string | undefined {
  if (!idCardNo) {
    return undefined;
  }
  const digits = idCardNo.replace(/\D/g, '');
  if (digits.length < 4) {
    return '****';
  }
  const last4 = digits.slice(-4);
  return `*****${last4.slice(0, 2)}*${last4.slice(2)}`;
}

export function canViewFullIdCard(role: Role): boolean {
  return PII_FULL_ACCESS_ROLES.includes(role);
}

export function applyIdCardMask<T extends { idCardNo?: string | null }>(
  entity: T,
  role: Role,
): T {
  if (!entity || canViewFullIdCard(role)) {
    return entity;
  }
  return {
    ...entity,
    idCardNo: maskIdCardNo(entity.idCardNo),
  };
}

export function maskAssociationMemberFields<
  T extends { idCardNo?: string | null },
>(entity: T, role: Role): T {
  return applyIdCardMask(entity, role);
}

export function applyNationalIdMask<T extends { nationalId?: string | null }>(
  entity: T,
  role: Role,
): T {
  if (!entity || canViewFullIdCard(role)) {
    return entity;
  }
  return {
    ...entity,
    nationalId: maskIdCardNo(entity.nationalId),
  };
}