import { IsOptional, IsString } from 'class-validator';

export class UpdateSchoolClusterDto {
  @IsOptional()
  @IsString()
  name?: string;
}