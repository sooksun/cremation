export const AUTH_COOKIE_NAME = 'cremation_token';

export const AUTH_COOKIE_MAX_AGE_MS = 7 * 24 * 60 * 60 * 1000;

export function getAuthCookieOptions() {
  const webOrigin = process.env.WEB_ORIGIN || process.env.FRONTEND_URL || '';
  const secure =
    process.env.COOKIE_SECURE === 'true' ||
    (process.env.COOKIE_SECURE !== 'false' && webOrigin.startsWith('https://'));

  return {
    httpOnly: true,
    secure,
    sameSite: 'strict' as const,
    maxAge: AUTH_COOKIE_MAX_AGE_MS,
    path: '/',
  };
}