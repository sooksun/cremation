import { Injectable, Logger } from '@nestjs/common';
import { DeathClaimType } from '@prisma/client';
import { DeathBenefitCalculatorService } from '../death-claims/death-benefit-calculator.service';

export interface FundFactsCase {
  rate: number;
  gross: number;
  fundReserve: number;
  netToPay: number;
}

export interface FundFacts {
  payingMemberCount: number;
  isFixedAmount: boolean;
  memberDeath: FundFactsCase;
  protectedDeath: FundFactsCase;
}

/**
 * ตัวเลขรวมของกองทุน ณ ขณะที่ผู้ใช้ถาม — ไม่มีข้อมูลรายบุคคล ไม่มี PII
 * ใช้ DeathBenefitCalculatorService ตัวเดียวกับที่ออกใบเคสจริง เพื่อไม่ให้สูตรแตกเป็นสองที่
 */
@Injectable()
export class FundFactsService {
  private readonly logger = new Logger(FundFactsService.name);

  constructor(private readonly calculator: DeathBenefitCalculatorService) {}

  async snapshot(): Promise<FundFacts | null> {
    try {
      const [member, protectedPerson] = await Promise.all([
        this.calculator.calculate({ claimType: DeathClaimType.MEMBER_DEATH }),
        this.calculator.calculate({ claimType: DeathClaimType.PROTECTED_DEATH }),
      ]);

      return {
        payingMemberCount: member.payingMemberCount,
        isFixedAmount: member.isFixedAmount,
        memberDeath: {
          rate: member.collectionRate,
          gross: member.grossCollected,
          fundReserve: member.fundReserve,
          netToPay: member.netToPay,
        },
        protectedDeath: {
          rate: protectedPerson.collectionRate,
          gross: protectedPerson.grossCollected,
          fundReserve: protectedPerson.fundReserve,
          netToPay: protectedPerson.netToPay,
        },
      };
    } catch (err) {
      // ข้อมูลระบบล่มไม่ควรลากให้ถามเรื่องระเบียบไม่ได้ไปด้วย
      this.logger.warn(`fund facts unavailable: ${err instanceof Error ? err.message : String(err)}`);
      return null;
    }
  }
}
