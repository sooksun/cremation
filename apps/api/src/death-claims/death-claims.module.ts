import { Module } from '@nestjs/common';
import { DeathClaimsService } from './death-claims.service';
import { DeathClaimsController } from './death-claims.controller';
import { DeathBenefitCalculatorService } from './death-benefit-calculator.service';
import { WelfareSettingsService } from './welfare-settings.service';
import { MembersModule } from '../members/members.module';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [MembersModule, CommonModule],
  controllers: [DeathClaimsController],
  providers: [DeathClaimsService, DeathBenefitCalculatorService, WelfareSettingsService],
  exports: [DeathClaimsService, WelfareSettingsService, DeathBenefitCalculatorService],
})
export class DeathClaimsModule {}

