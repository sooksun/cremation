import { DeathClaimType, DeceasedType, ProtectedRelationship } from '@prisma/client';

export const DECEASED_TYPE_LABELS: Record<DeceasedType, string> = {
  [DeceasedType.MEMBER]: 'ตัวสมาชิกเอง',
  [DeceasedType.PARENT]: 'บิดา/มารดาที่คุ้มครอง',
  [DeceasedType.CHILD]: 'บุตร/ธิดาที่คุ้มครอง',
  [DeceasedType.SPOUSE]: 'คู่สมรสที่คุ้มครอง',
};

export function toClaimType(deceasedType: DeceasedType): DeathClaimType {
  return deceasedType === DeceasedType.MEMBER
    ? DeathClaimType.MEMBER_DEATH
    : DeathClaimType.PROTECTED_DEATH;
}

export function deceasedTypeFromRelationship(
  relationship: ProtectedRelationship,
): DeceasedType {
  switch (relationship) {
    case ProtectedRelationship.SPOUSE:
      return DeceasedType.SPOUSE;
    case ProtectedRelationship.PARENT:
      return DeceasedType.PARENT;
    case ProtectedRelationship.CHILD:
      return DeceasedType.CHILD;
  }
}

export function relationshipMatchesDeceasedType(
  relationship: ProtectedRelationship,
  deceasedType: DeceasedType,
): boolean {
  if (deceasedType === DeceasedType.MEMBER) return false;
  return deceasedTypeFromRelationship(relationship) === deceasedType;
}

export function resolveDeceasedType(
  claimType: DeathClaimType,
  explicit?: DeceasedType,
): DeceasedType {
  if (explicit) return explicit;
  return claimType === DeathClaimType.MEMBER_DEATH
    ? DeceasedType.MEMBER
    : DeceasedType.PARENT;
}