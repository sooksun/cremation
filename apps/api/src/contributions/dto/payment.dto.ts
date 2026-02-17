import { IsNumber, IsNotEmpty, IsDateString, IsOptional, IsString, Min } from 'class-validator';

export class RecordPaymentDto {
  @IsNumber()
  @IsNotEmpty({ message: 'กรุณากรอกจำนวนเงิน' })
  @Min(0)
  amount: number;

  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่ชำระ' })
  paidDate: string;

  @IsOptional()
  @IsString()
  receiptId?: string;
}

