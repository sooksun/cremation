import { Module } from '@nestjs/common';
import { SchoolsService } from './schools.service';
import { SchoolsController } from './schools.controller';
import { SchoolAdminsModule } from '../school-admins/school-admins.module';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [SchoolAdminsModule, CommonModule],
  controllers: [SchoolsController],
  providers: [SchoolsService],
  exports: [SchoolsService],
})
export class SchoolsModule {}

