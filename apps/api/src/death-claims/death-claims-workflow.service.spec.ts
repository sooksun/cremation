import { BadRequestException } from '@nestjs/common';
import { DeathClaimStatus, Role } from '@prisma/client';
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