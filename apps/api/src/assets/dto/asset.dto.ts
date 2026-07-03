import { IsString, IsNotEmpty, IsOptional, IsNumber, IsDateString, Min, Max } from 'class-validator';
import { Transform } from 'class-transformer';

export class CreateAssetDto {
  @IsOptional()
  @IsString()
  code?: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อสินทรัพย์' })
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsDateString({}, { message: 'วันที่ซื้อไม่ถูกต้อง' })
  purchaseDate: string;

  @IsNumber()
  @Min(0)
  originalCost: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  salvageValue?: number;

  @IsNumber()
  @Min(1)
  @Max(100)
  usefulLifeYears: number;

  @IsOptional()
  @IsString()
  status?: string;
}

export class UpdateAssetDto {
  @IsOptional()
  @IsString()
  code?: string;

  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  category?: string;

  @IsOptional()
  @IsDateString()
  purchaseDate?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  originalCost?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  salvageValue?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  usefulLifeYears?: number;

  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsDateString()
  disposalDate?: string;

  @IsOptional()
  @IsNumber()
  @Min(0)
  disposalProceeds?: number;
}

export class RecordDepreciationDto {
  @IsOptional()
  @IsNumber()
  year?: number; // if not provided, use current year

  @IsOptional()
  @IsNumber()
  @Min(0)
  amount?: number; // optional override, else calculate
}