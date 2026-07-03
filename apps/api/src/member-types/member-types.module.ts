import { Module } from '@nestjs/common';
import { MemberTypesService } from './member-types.service';
import { MemberTypesController } from './member-types.controller';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [CommonModule],
  controllers: [MemberTypesController],
  providers: [MemberTypesService],
  exports: [MemberTypesService],
})
export class MemberTypesModule {}

