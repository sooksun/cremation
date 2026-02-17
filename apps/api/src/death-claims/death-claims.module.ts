import { Module } from '@nestjs/common';
import { DeathClaimsService } from './death-claims.service';
import { DeathClaimsController } from './death-claims.controller';
import { MembersModule } from '../members/members.module';

@Module({
  imports: [MembersModule],
  controllers: [DeathClaimsController],
  providers: [DeathClaimsService],
  exports: [DeathClaimsService],
})
export class DeathClaimsModule {}

