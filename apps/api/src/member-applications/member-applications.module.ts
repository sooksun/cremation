import { Module } from '@nestjs/common';
import { MemberApplicationsController } from './member-applications.controller';
import { MemberApplicationsService } from './member-applications.service';
import { MembersModule } from '../members/members.module';

@Module({
  imports: [MembersModule],
  controllers: [MemberApplicationsController],
  providers: [MemberApplicationsService],
})
export class MemberApplicationsModule {}