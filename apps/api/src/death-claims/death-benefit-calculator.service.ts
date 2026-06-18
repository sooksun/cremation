import { Injectable } from '@nestjs/common';
import { DeathClaimType, MemberStatus } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import {
  DEATH_COLLECTION_RATES,
  DEATH_FUND_RESERVE_RATIO,
  DEATH_PAYOUT_RATIO,
} from './death-benefit.constants';

export interface DeathBenefitCalculation {
  claimType: DeathClaimType;
  payingMemberCount: number;
  collectionRate: number;
  grossCollected: number;
  payoutRatio: number;
  fundReserve: number;
  otherDeductions: number;
  netToPay: number;
  /** @deprecated use payingMemberCount */
  activeMemberCount: number;
  /** @deprecated use collectionRate */
  welfareRate: number;
  /** @deprecated use grossCollected */
  totalContribution: number;
  /** @deprecated use fundReserve */
  associationSupport: number;
}

@Injectable()
export class DeathBenefitCalculatorService {
  constructor(private readonly prisma: PrismaService) {}

  async calculate(params: {
    claimType?: DeathClaimType;
    excludeMemberId?: string;
    otherDeductions?: number;
  }): Promise<DeathBenefitCalculation> {
    const claimType = params.claimType ?? DeathClaimType.MEMBER_DEATH;
    const collectionRate = DEATH_COLLECTION_RATES[claimType];
    const otherDeductions = params.otherDeductions ?? 0;

    const payingMemberCount = await this.prisma.member.count({
      where: {
        status: MemberStatus.ACTIVE,
        ...(params.excludeMemberId ? { id: { not: params.excludeMemberId } } : {}),
      },
    });

    const grossCollected = payingMemberCount * collectionRate;
    const fundReserve = Math.round(grossCollected * DEATH_FUND_RESERVE_RATIO * 100) / 100;
    const netToPay =
      Math.round(grossCollected * DEATH_PAYOUT_RATIO * 100) / 100 - otherDeductions;

    return {
      claimType,
      payingMemberCount,
      collectionRate,
      grossCollected,
      payoutRatio: DEATH_PAYOUT_RATIO,
      fundReserve,
      otherDeductions,
      netToPay,
      activeMemberCount: payingMemberCount,
      welfareRate: collectionRate,
      totalContribution: grossCollected,
      associationSupport: fundReserve,
    };
  }
}