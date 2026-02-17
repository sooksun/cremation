import { IsArray, ValidateNested, IsString, IsNumber, IsDateString, IsOptional, Min } from 'class-validator';
import { Type } from 'class-transformer';

class PaymentItem {
  @IsString()
  contributionId: string;

  @IsNumber()
  @Min(0)
  amount: number;

  @IsOptional()
  @IsDateString()
  paidDate?: string;

  @IsOptional()
  @IsString()
  receiptId?: string;
}

export class BatchPaymentDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PaymentItem)
  payments: PaymentItem[];
}

