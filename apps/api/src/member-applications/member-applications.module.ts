import { Module } from '@nestjs/common';
import { MemberApplicationsController } from './member-applications.controller';
import { MemberApplicationsService } from './member-applications.service';
import { MembersModule } from '../members/members.module';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [MembersModule, CommonModule],
  controllers: [MemberApplicationsController],
  providers: [MemberApplicationsService],
})
export class MemberApplicationsModule {}