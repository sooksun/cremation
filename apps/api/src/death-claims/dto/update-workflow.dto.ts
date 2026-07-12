import {
  IsBoolean,
  IsDateString,
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

  // ข้อ 18 — บันทึกการนำพวงหรีด / ร่วมเป็นเจ้าภาพสวดอภิธรรม
  @IsOptional()
  @IsDateString()
  condolenceWreathAt?: string;

  @IsOptional()
  @IsDateString()
  funeralPrayerAt?: string;
}