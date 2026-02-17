import { IsString, IsNotEmpty, IsEnum, IsNumber, IsDateString, IsOptional, Min } from 'class-validator';
import { PaymentType } from '@prisma/client';

export class CreatePaymentDto {
  @IsOptional()
  @IsString()
  schoolId?: string; // optional - ระบุโรงเรียนที่เกี่ยวข้อง (ถ้ามี)

  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่' })
  date: string;

  @IsEnum(PaymentType, { message: 'ประเภทใบสำคัญจ่ายไม่ถูกต้อง' })
  type: PaymentType;

  @IsOptional()
  @IsString()
  description?: string;

  @IsNumber()
  @IsNotEmpty({ message: 'กรุณากรอกจำนวนเงิน' })
  @Min(0)
  amount: number;

  @IsOptional()
  @IsString()
  bankAccountId?: string;
}

