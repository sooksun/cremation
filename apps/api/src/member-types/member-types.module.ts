import { Module } from '@nestjs/common';
import { MemberTypesService } from './member-types.service';
import { MemberTypesController } from './member-types.controller';

@Module({
  controllers: [MemberTypesController],
  providers: [MemberTypesService],
  exports: [MemberTypesService],
})
export class MemberTypesModule {}

