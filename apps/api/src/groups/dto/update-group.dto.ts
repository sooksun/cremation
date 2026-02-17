import { IsString, IsOptional, ValidateIf } from 'class-validator';
import { Transform } from 'class-transformer';

export class UpdateGroupDto {
  @IsOptional()
  @IsString()
  schoolId?: string;

  @IsOptional()
  @IsString()
  code?: string;

  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.leaderId !== undefined && o.leaderId !== '')
  @IsString()
  leaderId?: string;
}

