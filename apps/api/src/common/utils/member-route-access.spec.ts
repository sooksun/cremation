import { isPathAllowedForRole } from '../../../../web/src/lib/route-access';

describe('member route access', () => {
  it('allows a MEMBER to open only its own profile route', () => {
    expect(
      isPathAllowedForRole('/members/member-1/profile', 'MEMBER', 'member-1'),
    ).toBe(true);
    expect(
      isPathAllowedForRole('/members/member-2/profile', 'MEMBER', 'member-1'),
    ).toBe(false);
    expect(isPathAllowedForRole('/dashboard', 'MEMBER', 'member-1')).toBe(false);
  });

  it('denies a MEMBER account without a linked member id', () => {
    expect(isPathAllowedForRole('/members/member-1/profile', 'MEMBER')).toBe(false);
  });
});
