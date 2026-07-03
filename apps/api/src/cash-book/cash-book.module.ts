import { Module } from '@nestjs/common';
import { CashBookService } from './cash-book.service';
import { CashBookController } from './cash-book.controller';
import { CommonModule } from '../common/common.module';

@Module({
  imports: [CommonModule],
  controllers: [CashBookController],
  providers: [CashBookService],
  exports: [CashBookService],
})
export class CashBookModule {}