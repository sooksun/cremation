import { IsString, IsNotEmpty, IsOptional, IsNumber } from 'class-validator';

export class CreateBeneficiaryDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อผู้รับผลประโยชน์' })
  fullName: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกความสัมพันธ์' })
  relationship: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsNumber()
  priority?: number;
}

export class UpdateBeneficiaryDto {
  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsString()
  relationship?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsNumber()
  priority?: number;
}

