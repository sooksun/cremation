import { Module } from '@nestjs/common';
import { ContributionsService } from './contributions.service';
import { ContributionsController } from './contributions.controller';
import { PaymentReconciliationService } from './payment-reconciliation.service';
import { MembersModule } from '../members/members.module';
import { ReceiptsModule } from '../receipts/receipts.module';
import { CommonModule } from '../common/common.module';
import { BankAccountsModule } from '../bank-accounts/bank-accounts.module';

@Module({
  imports: [MembersModule, ReceiptsModule, CommonModule, BankAccountsModule],
  controllers: [ContributionsController],
  providers: [ContributionsService, PaymentReconciliationService],
  exports: [ContributionsService],
})
export class ContributionsModule {}

