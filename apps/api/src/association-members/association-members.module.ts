import { Module } from '@nestjs/common';
import { AssociationMembersService } from './association-members.service';
import { AssociationMembersController } from './association-members.controller';

@Module({
  controllers: [AssociationMembersController],
  providers: [AssociationMembersService],
  exports: [AssociationMembersService],
})
export class AssociationMembersModule {}
