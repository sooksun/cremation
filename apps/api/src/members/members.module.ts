import { Module } from '@nestjs/common';
import { MembersService } from './members.service';
import { MembersController } from './members.controller';
import { BeneficiariesService } from './beneficiaries.service';

@Module({
  controllers: [MembersController],
  providers: [MembersService, BeneficiariesService],
  exports: [MembersService],
})
export class MembersModule {}

