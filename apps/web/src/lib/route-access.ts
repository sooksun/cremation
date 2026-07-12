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
  '/member-applications',
  '/reports/resignations',
  '/reports/receipts-ledger',
  '/reports/disbursement-ledger',
  '/reports/member-registry',
  '/reports/period-close-summary',
];

const SCHOOL_ADMIN_BLOCKED_PREFIXES = [
  '/users',
  '/school-admins',
  '/schools',
  '/school-clusters',
  '/member-types',
  '/accounts',
  '/settings',
  '/settings/welfare-rate',
  '/reports/executive',
];

const ROLE_BLOCKED_PREFIXES: Record<string, string[]> = {
  VIEWER: VIEWER_BLOCKED_PREFIXES,
  SCHOOL_ADMIN: SCHOOL_ADMIN_BLOCKED_PREFIXES,
  GROUP_LEADER: [
    '/users',
    '/schools',
    '/school-clusters',
    '/member-types',
    '/groups',
    '/accounts',
    '/settings/welfare-rate',
    '/member-applications',
    '/reports/resignations',
    '/reports/receipts-ledger',
    '/reports/disbursement-ledger',
    '/reports/member-registry',
    '/reports/period-close-summary',
  ],
};

export function isPathAllowedForRole(
  pathname: string,
  role: string,
  memberId?: string,
): boolean {
  if (role === 'MEMBER') {
    if (memberId && pathname === `/members/${memberId}/profile`) {
      return true;
    }
    if (memberId && pathname === `/reports/member-statement/${memberId}`) {
      return true;
    }
    return /^\/receipts\/[^/]+$/.test(pathname) && pathname !== '/receipts/new';
  }

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
