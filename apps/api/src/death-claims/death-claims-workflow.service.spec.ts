import { BadRequestException } from '@nestjs/common';
import { AuditAction, DeathClaimStatus, Role } from '@prisma/client';
import { DeathClaimsService } from './death-claims.service';
import { SchoolScopeService } from '../common/security/school-scope.service';

describe('DeathClaimsService.updateWorkflow', () => {
  const claimId = 'claim-1';
  const schoolId = 'school-a';
  const actor = { id: 'user-1', role: Role.FINANCE, schoolId };

  const baseClaim = {
    id: claimId,
    schoolId,
    status: DeathClaimStatus.COLLECTING,
    collectedAmount: 1000,
    totalContribution: 5000,
    documentsComplete: false,
    collectionCompletedAt: null,
    documentChecklist: [],
    payment: null,
    member: { associationMember: null },
    school: { name: 'Test' },
  };

  const prisma = {
    deathClaim: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
  };

  const auditLog = { log: jest.fn() };
  const schoolScope = new SchoolScopeService();

  const service = new DeathClaimsService(
    prisma as never,
    {} as never,
    {} as never,
    schoolScope,
    auditLog as never,
    {} as never,
  );

  beforeEach(() => {
    jest.clearAllMocks();
    prisma.deathClaim.findUnique.mockResolvedValue({ ...baseClaim });
    prisma.deathClaim.update.mockImplementation(({ data }: { data: { status: DeathClaimStatus } }) =>
      Promise.resolve({ ...baseClaim, ...data }),
    );
  });

  // เดิมบันทึกเป็น DEATH_CLAIM_CREATE ทั้งที่เป็นการแก้ไขเคลมที่มีอยู่แล้ว
  // ทำให้ทุกครั้งที่มีคนเก็บเงินหรือปรับ workflow ถูกนับเป็น "สร้างใหม่" ในสมุดบันทึก
  it('บันทึก audit log เป็น DEATH_CLAIM_UPDATE ไม่ใช่ CREATE', async () => {
    await service.updateWorkflow(claimId, { collectedAmount: 2000 }, actor);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({ action: AuditAction.DEATH_CLAIM_UPDATE, entityId: claimId }),
    );
  });

  it('rejects startCollecting when claim is not REPORTED', async () => {
    await expect(
      service.updateWorkflow(claimId, { startCollecting: true }, actor),
    ).rejects.toThrow(BadRequestException);
  });

  it('derives FUND_COMPLETE from collected amount — cannot force READY_TO_PAY via status field', async () => {
    const updated = await service.updateWorkflow(
      claimId,
      { collectedAmount: 5000 },
      actor,
    );

    expect(updated.status).toBe(DeathClaimStatus.FUND_COMPLETE);
    expect(prisma.deathClaim.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ status: DeathClaimStatus.FUND_COMPLETE }),
      }),
    );
  });

  it('starts collection from REPORTED via startCollecting', async () => {
    prisma.deathClaim.findUnique.mockResolvedValue({
      ...baseClaim,
      status: DeathClaimStatus.REPORTED,
      collectedAmount: 0,
    });

    const updated = await service.updateWorkflow(
      claimId,
      { startCollecting: true },
      actor,
    );

    expect(updated.status).toBe(DeathClaimStatus.COLLECTING);
  });
});
/**
 * updateDocuments ไม่เคยมีเทสต์มาก่อน และมีบั๊กเดียวกับ updateWorkflow
 * บันทึก audit log เป็น DEATH_CLAIM_CREATE ทั้งที่เป็นการแก้ไขเช็คลิสต์เอกสาร
 */
describe('DeathClaimsService.updateDocuments', () => {
  const claimId = 'claim-2';
  const schoolId = 'school-a';
  const actor = { id: 'user-1', role: Role.FINANCE, schoolId };

  const baseClaim = {
    id: claimId,
    schoolId,
    status: DeathClaimStatus.COLLECTING,
    collectedAmount: 1000,
    totalContribution: 5000,
    documentsComplete: false,
    documentChecklist: [{ key: 'idCard', label: 'บัตรประชาชน', checked: false }],
    payment: null,
    member: { associationMember: null },
    school: { name: 'Test' },
  };

  const prisma = {
    deathClaim: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
  };

  const auditLog = { log: jest.fn() };
  const schoolScope = new SchoolScopeService();

  const service = new DeathClaimsService(
    prisma as never,
    {} as never,
    {} as never,
    schoolScope,
    auditLog as never,
    {} as never,
  );

  beforeEach(() => {
    jest.clearAllMocks();
    prisma.deathClaim.findUnique.mockResolvedValue({ ...baseClaim });
    prisma.deathClaim.update.mockImplementation(({ data }: { data: unknown }) =>
      Promise.resolve({ ...baseClaim, ...(data as object) }),
    );
  });

  it('บันทึก audit log เป็น DEATH_CLAIM_UPDATE ไม่ใช่ CREATE', async () => {
    await service.updateDocuments(
      claimId,
      { items: [{ key: 'idCard', checked: true }] },
      actor,
    );

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({ action: AuditAction.DEATH_CLAIM_UPDATE, entityId: claimId }),
    );
  });

  it('ปฏิเสธเมื่อรายการจ่ายเงินไปแล้ว', async () => {
    prisma.deathClaim.findUnique.mockResolvedValue({ ...baseClaim, status: DeathClaimStatus.PAID });

    await expect(
      service.updateDocuments(claimId, { items: [{ key: 'idCard', checked: true }] }, actor),
    ).rejects.toThrow(BadRequestException);
  });
});
