import { IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class UpdateDeathBenefitFixedDto {
  @IsNumber()
  @Min(0)
  welfareAmountPerCase: number;

  @IsOptional()
  @IsString()
  description?: string;

  effectiveDate?: string; // ISO date
}