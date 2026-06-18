const VIEWER_BLOCKED_PREFIXES = [
  '/users',
  '/schools',
  '/school-clusters',
  '/member-types',
  '/groups',
  '/accounts',
  '/bank-accounts',
  '/members/new',
  '/death-claims/new',
  '/settings',
];

const ROLE_BLOCKED_PREFIXES: Record<string, string[]> = {
  VIEWER: VIEWER_BLOCKED_PREFIXES,
  GROUP_LEADER: ['/users', '/schools', '/school-clusters', '/member-types', '/groups', '/accounts', '/settings/welfare-rate'],
};

export function isPathAllowedForRole(pathname: string, role: string): boolean {
  const blocked = ROLE_BLOCKED_PREFIXES[role];
  if (!blocked) return true;

  if (blocked.some((prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`))) {
    return false;
  }

  if (role === 'VIEWER' && /\/members\/[^/]+\/edit$/.test(pathname)) {
    return false;
  }

  return true;
}