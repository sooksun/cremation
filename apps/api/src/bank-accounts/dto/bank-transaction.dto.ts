import { IsDateString, IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { BankTransactionType } from '@prisma/client';

export class CreateBankTransactionDto {
  @IsString()
  @IsNotEmpty()
  bankAccountId: string;

  @IsDateString()
  date: string;

  @IsEnum(BankTransactionType)
  type: BankTransactionType;

  @IsNumber()
  @Min(0.01)
  amount: number;

  @IsOptional()
  @IsString()
  description?: string;
}

export class UpdateBankTransactionDto {
  @IsOptional()
  @IsDateString()
  date?: string;

  @IsOptional()
  @IsEnum(BankTransactionType)
  type?: BankTransactionType;

  @IsOptional()
  @IsNumber()
  @Min(0.01)
  amount?: number;

  @IsOptional()
  @IsString()
  description?: string;
}