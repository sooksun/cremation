import { Module } from '@nestjs/common';
import { MembersService } from './members.service';
import { MembersController } from './members.controller';
import { BeneficiariesService } from './beneficiaries.service';
import { MembershipRulesService } from './membership-rules.service';
import { ProtectedPersonsService } from './protected-persons.service';

@Module({
  controllers: [MembersController],
  providers: [
    MembersService,
    BeneficiariesService,
    MembershipRulesService,
    ProtectedPersonsService,
  ],
  exports: [MembersService, MembershipRulesService, ProtectedPersonsService],
})
export class MembersModule {}

