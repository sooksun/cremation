import { IsString, IsOptional, IsBoolean } from 'class-validator';

export class UpdateMemberTypeDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}

