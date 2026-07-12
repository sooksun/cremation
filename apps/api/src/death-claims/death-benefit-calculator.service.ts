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
  /** Whether payout uses fixed committee-set amount (from WelfareSettings) instead of collection-based */
  isFixedAmount: boolean;
  /** The fixed amount per case if isFixedAmount */
  fixedAmount?: number;
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
        status: { in: [MemberStatus.ACTIVE, MemberStatus.ARREARS] },
        ...(params.excludeMemberId ? { id: { not: params.excludeMemberId } } : {}),
      },
    });

    // Fixed committee amount (WelfareSettings) แทน "ยอดเก็บรวมต่อศพ" แล้วแบ่ง 90/10
    // เหมือนโหมดปกติ (ข้อ 16) — ไม่จ่ายเต็มจำนวน เพื่อให้ 10% เข้ากองทุนเสมอ
    const activeFixed = await this.prisma.welfareSettings.findFirst({
      where: { isActive: true },
      orderBy: { effectiveDate: 'desc' },
    });

    let grossCollected: number;
    let isFixedAmount = false;
    let fixedAmount: number | undefined;
    if (activeFixed) {
      grossCollected = Math.round(Number(activeFixed.welfareAmountPerCase) * 100) / 100;
      isFixedAmount = true;
      fixedAmount = grossCollected;
    } else {
      grossCollected = payingMemberCount * collectionRate;
    }

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
      isFixedAmount,
      fixedAmount,
      activeMemberCount: payingMemberCount,
      welfareRate: collectionRate,
      totalContribution: grossCollected,
      associationSupport: fundReserve,
    };
  }
}