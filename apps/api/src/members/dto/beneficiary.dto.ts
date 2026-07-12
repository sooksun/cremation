import { IsString, IsNotEmpty, IsOptional, IsInt, Min, Max } from 'class-validator';

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
  @IsInt()
  @Min(1, { message: 'ลำดับผู้รับเงินต้องอยู่ระหว่าง 1-3' })
  @Max(3, { message: 'ลำดับผู้รับเงินต้องอยู่ระหว่าง 1-3' })
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
  @IsInt()
  @Min(1, { message: 'ลำดับผู้รับเงินต้องอยู่ระหว่าง 1-3' })
  @Max(3, { message: 'ลำดับผู้รับเงินต้องอยู่ระหว่าง 1-3' })
  priority?: number;
}

