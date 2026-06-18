import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

export const SERVICE_FEE_ENABLED_KEY = 'service_fee_enabled';

@Injectable()
export class AppSettingsService {
  constructor(private readonly prisma: PrismaService) {}

  async isServiceFeeEnabled(): Promise<boolean> {
    const row = await this.prisma.appSetting.findUnique({
      where: { key: SERVICE_FEE_ENABLED_KEY },
    });
    return row?.value === 'true';
  }

  async setServiceFeeEnabled(enabled: boolean): Promise<{ serviceFeeEnabled: boolean }> {
    await this.prisma.appSetting.upsert({
      where: { key: SERVICE_FEE_ENABLED_KEY },
      create: { key: SERVICE_FEE_ENABLED_KEY, value: String(enabled) },
      update: { value: String(enabled) },
    });
    return { serviceFeeEnabled: enabled };
  }

  effectiveServiceFee(serviceFee: number, enabled: boolean): number {
    return enabled ? serviceFee : 0;
  }

  periodTotal(welfareRate: number, serviceFee: number, enabled: boolean): number {
    return Number(welfareRate) + this.effectiveServiceFee(Number(serviceFee), enabled);
  }
}