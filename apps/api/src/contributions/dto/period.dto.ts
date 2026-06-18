import { IsNumber, IsNotEmpty, IsOptional, IsBoolean, Min, Max } from 'class-validator';

export class CreatePeriodDto {
  @IsNumber()
  @IsNotEmpty({ message: 'กรุณากรอกปี' })
  @Min(2020)
  year: number;

  @IsNumber()
  @IsNotEmpty({ message: 'กรุณากรอกเดือน' })
  @Min(1)
  @Max(12)
  month: number;

  @IsNumber()
  @IsNotEmpty({ message: 'กรุณากรอกอัตราเงินสงเคราะห์' })
  @Min(0)
  welfareRate: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  serviceFee?: number;
}

export class UpdatePeriodDto {
  @IsOptional()
  @IsNumber()
  @Min(0)
  welfareRate?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  serviceFee?: number;

  @IsOptional()
  @IsBoolean()
  isClosed?: boolean;
}

