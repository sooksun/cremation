import { Role } from '@prisma/client';
import {
  maskMemberListResponse,
  maskMemberWithAssociation,
  maskProtectedPersonList,
} from './pii-response.util';

describe('pii-response.util (members)', () => {
  const fullId = '1234567890123';

  const memberRow = {
    id: 'm1',
    memberNo: 'M001',
    associationMember: {
      firstName: 'สมชาย',
      idCardNo: fullId,
      phone: '0812345678',
    },
  };

  it('masks idCardNo for VIEWER on member detail', () => {
    const masked = maskMemberWithAssociation(memberRow, Role.VIEWER);
    expect(masked.associationMember?.idCardNo).not.toBe(fullId);
    expect(masked.associationMember?.idCardNo).toMatch(/\*/);
    expect(masked.associationMember?.phone).toBe('0812345678');
  });

  it('preserves idCardNo for ADMIN', () => {
    const masked = maskMemberWithAssociation(memberRow, Role.ADMIN);
    expect(masked.associationMember?.idCardNo).toBe(fullId);
  });

  it('masks idCardNo on member list response', () => {
    const result = maskMemberListResponse(
      { data: [memberRow], meta: { total: 1, page: 1, limit: 50, totalPages: 1 } },
      Role.GROUP_LEADER,
    );
    expect(result.data[0].associationMember?.idCardNo).not.toBe(fullId);
  });

  it('masks protected person nationalId for VIEWER', () => {
    const masked = maskProtectedPersonList(
      [{ id: 'p1', fullName: 'Test', nationalId: fullId }],
      Role.VIEWER,
    );
    expect(masked[0].nationalId).not.toBe(fullId);
  });

  it('preserves nationalId for FINANCE', () => {
    const masked = maskProtectedPersonList(
      [{ id: 'p1', fullName: 'Test', nationalId: fullId }],
      Role.FINANCE,
    );
    expect(masked[0].nationalId).toBe(fullId);
  });
});