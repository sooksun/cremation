import {
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class UpdateDeathClaimWorkflowDto {
  @IsOptional()
  @IsBoolean()
  startCollecting?: boolean;

  @IsOptional()
  @IsNumber()
  @Min(0)
  collectedAmount?: number;

  @IsOptional()
  @IsString()
  workflowNotes?: string;
}