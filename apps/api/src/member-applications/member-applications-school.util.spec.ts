import {
  matchSchoolByAgency,
  normalizeSchoolLookup,
  schoolLookupErrorMessage,
} from './member-applications-school.util';

describe('member-applications-school.util', () => {
  const schools = [
    { id: '1', name: 'โรงเรียนแม่ฟ้าหลวง', code: 'MFH' },
    { id: '2', name: 'โรงเรียนแม่ฟ้าหลวง 2', code: 'MFH2' },
    { id: '3', name: 'โรงเรียนบ้านดู่', code: 'BD' },
  ];

  it('normalizes whitespace', () => {
    expect(normalizeSchoolLookup('  โรงเรียน  แม่ฟ้าหลวง  ')).toBe('โรงเรียน แม่ฟ้าหลวง');
  });

  it('matches exact school name', () => {
    const result = matchSchoolByAgency('โรงเรียนแม่ฟ้าหลวง', schools);
    expect(result.kind).toBe('one');
    if (result.kind === 'one') {
      expect(result.school.id).toBe('1');
    }
  });

  it('matches exact school code', () => {
    const result = matchSchoolByAgency('MFH', schools);
    expect(result.kind).toBe('one');
    if (result.kind === 'one') {
      expect(result.school.code).toBe('MFH');
    }
  });

  it('rejects partial contains match', () => {
    expect(matchSchoolByAgency('แม่ฟ้าหลวง', schools).kind).toBe('none');
    expect(matchSchoolByAgency('MF', schools).kind).toBe('none');
  });

  it('reports multiple exact matches', () => {
    const ambiguous = [
      { id: 'a', name: 'โรงเรียน A', code: 'SCH' },
      { id: 'b', name: 'โรงเรียน B', code: 'SCH' },
    ];
    const result = matchSchoolByAgency('SCH', ambiguous);
    expect(result.kind).toBe('many');
    expect(schoolLookupErrorMessage(result)).toContain('หลายแห่ง');
  });
});