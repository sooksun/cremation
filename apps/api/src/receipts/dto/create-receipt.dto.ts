import { IsString, IsNotEmpty, IsEnum, IsNumber, IsDateString, IsOptional, Min } from 'class-validator';
import { ReceiptType } from '@prisma/client';

export class CreateReceiptDto {
  @IsOptional()
  @IsString()
  schoolId?: string; // optional - ระบุโรงเรียนที่ส่งเงินมา (ถ้ามี)

  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่' })
  date: string;

  @IsEnum(ReceiptType, { message: 'ประเภทใบเสร็จไม่ถูกต้อง' })
  type: ReceiptType;

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

