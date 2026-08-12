const VIEWER_BLOCKED_PREFIXES = [
  '/users',
  '/schools',
  '/school-clusters',
  '/member-types',
  '/groups',
  '/accounts',
  '/bank-accounts',
  '/members/new',
  '/members/membership-end',
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

// Derived from the sidebar menu `roles` arrays in app/(dashboard)/layout.tsx:
// any path whose menu entry's `roles` list omits FINANCE is blocked here.
// FINANCE has access to money/member-facing modules (groups, bank-accounts,
// cash-book, association-members, bank, members, contributions, receipts,
// payments, death-claims, reports, settings/signature) but not admin-only
// setup screens (users, schools, member-types, accounts, assets,
// member-applications, welfare-rate, executive overview).
const FINANCE_BLOCKED_PREFIXES = [
  '/users',
  '/school-admins',
  '/schools',
  '/school-clusters',
  '/member-types',
  '/accounts',
  '/assets',
  '/member-applications',
  '/settings/welfare-rate',
  '/reports/executive',
];

// Derived from the sidebar menu `roles` arrays in app/(dashboard)/layout.tsx:
// any path whose menu entry's `roles` list omits ACCOUNTING is blocked here.
// ACCOUNTING only has access to accounts, assets, audit-logs, and the
// shared finance/accounting reports (finance, financial-statements, daily,
// trial-balance, receipts-ledger, disbursement-ledger, board-monthly) — not
// member/contribution/payment operations or settings.
const ACCOUNTING_BLOCKED_PREFIXES = [
  '/users',
  '/school-admins',
  '/schools',
  '/school-clusters',
  '/member-types',
  '/groups',
  '/bank-accounts',
  '/cash-book',
  '/member-applications',
  '/association-members',
  '/bank',
  '/members',
  '/contributions',
  '/receipts',
  '/payments',
  '/death-claims',
  '/settings',
  '/reports/executive',
  '/reports/resignations',
  '/reports/member-registry',
  '/reports/period-close-summary',
];

const ROLE_BLOCKED_PREFIXES: Record<string, string[]> = {
  VIEWER: VIEWER_BLOCKED_PREFIXES,
  SCHOOL_ADMIN: SCHOOL_ADMIN_BLOCKED_PREFIXES,
  FINANCE: FINANCE_BLOCKED_PREFIXES,
  ACCOUNTING: ACCOUNTING_BLOCKED_PREFIXES,
  GROUP_LEADER: [
    '/users',
    '/schools',
    '/school-clusters',
    '/member-types',
    '/groups',
    '/accounts',
    '/settings/welfare-rate',
    '/member-applications',
    '/members/membership-end',
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
