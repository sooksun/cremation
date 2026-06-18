import { DeathClaimType, DeceasedType, ProtectedRelationship } from '@prisma/client';
import {
  relationshipMatchesDeceasedType,
  toClaimType,
  deceasedTypeFromRelationship,
} from './death-claim-deceased.constants';

describe('death-claim-deceased constants', () => {
  it('maps deceased type to claim type', () => {
    expect(toClaimType(DeceasedType.MEMBER)).toBe(DeathClaimType.MEMBER_DEATH);
    expect(toClaimType(DeceasedType.PARENT)).toBe(DeathClaimType.PROTECTED_DEATH);
    expect(toClaimType(DeceasedType.CHILD)).toBe(DeathClaimType.PROTECTED_DEATH);
  });

  it('maps protected relationship to deceased type', () => {
    expect(deceasedTypeFromRelationship(ProtectedRelationship.PARENT)).toBe(DeceasedType.PARENT);
    expect(deceasedTypeFromRelationship(ProtectedRelationship.CHILD)).toBe(DeceasedType.CHILD);
    expect(deceasedTypeFromRelationship(ProtectedRelationship.SPOUSE)).toBe(DeceasedType.SPOUSE);
  });

  it('validates relationship against deceased type', () => {
    expect(
      relationshipMatchesDeceasedType(ProtectedRelationship.PARENT, DeceasedType.PARENT),
    ).toBe(true);
    expect(
      relationshipMatchesDeceasedType(ProtectedRelationship.CHILD, DeceasedType.PARENT),
    ).toBe(false);
  });
});