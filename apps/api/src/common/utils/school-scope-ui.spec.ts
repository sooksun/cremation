import {
  canSelectAllSchools,
  filterSchoolsForUser,
  resolveSelectedSchoolId,
} from '../../../../web/src/lib/school-scope';

describe('school-scope UI helpers', () => {
  const schools = [
    { id: 'school-a', name: 'A' },
    { id: 'school-b', name: 'B' },
  ];

  it('allows ADMIN to select all schools', () => {
    expect(canSelectAllSchools('ADMIN')).toBe(true);
    expect(resolveSelectedSchoolId('ADMIN', undefined, null)).toBeNull();
    expect(filterSchoolsForUser(schools, 'ADMIN', undefined)).toHaveLength(2);
  });

  it('locks non-ADMIN users to their school', () => {
    expect(canSelectAllSchools('FINANCE')).toBe(false);
    expect(resolveSelectedSchoolId('FINANCE', 'school-a', null)).toBe('school-a');
    expect(resolveSelectedSchoolId('VIEWER', 'school-a', 'school-b')).toBe('school-a');
    expect(filterSchoolsForUser(schools, 'VIEWER', 'school-a')).toEqual([schools[0]]);
  });
});