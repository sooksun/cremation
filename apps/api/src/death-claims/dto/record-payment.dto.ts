import { IsString, IsNotEmpty, IsDateString, IsOptional, IsNumber, Min } from 'class-validator';

export class RecordBenefitPaymentDto {
  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่จ่าย' })
  payDate: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกวิธีการจ่าย' })
  method: string; // 'CASH' | 'BANK_TRANSFER'

  @IsOptional()
  @IsString()
  bankAccountId?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  amount?: number;
}

