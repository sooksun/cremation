import { IsBoolean } from 'class-validator';

export class UpdateContributionSettingsDto {
  @IsBoolean()
  serviceFeeEnabled: boolean;
}