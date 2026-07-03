import { Module } from '@nestjs/common';
import { SchoolAdminsController } from './school-admins.controller';
import { SchoolAdminsService } from './school-admins.service';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [CommonModule],
  controllers: [SchoolAdminsController],
  providers: [SchoolAdminsService],
  exports: [SchoolAdminsService],
})
export class SchoolAdminsModule {}