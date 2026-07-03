import { IsString, IsNotEmpty, IsNumber, IsDateString, IsOptional, IsIn } from 'class-validator';

export class CreateCashBookDto {
  @IsDateString()
  date: string;

  @IsIn(['IN', 'OUT'])
  type: 'IN' | 'OUT';

  @IsNumber()
  amount: number;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  receiptId?: string;

  @IsOptional()
  @IsString()
  paymentId?: string;
}

export class UpdateCashBookDto {
  @IsOptional()
  @IsDateString()
  date?: string;

  @IsOptional()
  @IsIn(['IN', 'OUT'])
  type?: 'IN' | 'OUT';

  @IsOptional()
  @IsNumber()
  amount?: number;

  @IsOptional()
  @IsString()
  description?: string;
}