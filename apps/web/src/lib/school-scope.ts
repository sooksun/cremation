export function canSelectAllSchools(role?: string): boolean {
  return role === 'ADMIN';
}

export function resolveSelectedSchoolId(
  role: string | undefined,
  userSchoolId: string | undefined,
  requestedSchoolId: string | null,
): string | null {
  if (canSelectAllSchools(role)) {
    return requestedSchoolId;
  }
  return userSchoolId ?? null;
}

export function filterSchoolsForUser<T extends { id: string }>(
  schools: T[],
  role: string | undefined,
  userSchoolId: string | undefined,
): T[] {
  if (canSelectAllSchools(role)) {
    return schools;
  }
  if (!userSchoolId) {
    return [];
  }
  return schools.filter((school) => school.id === userSchoolId);
}