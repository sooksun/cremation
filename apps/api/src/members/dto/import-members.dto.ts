import { IsArray, IsDateString, IsOptional, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class MemberCsvRowDto {
  @IsString()
  memberNo: string;

  @IsString()
  firstName: string;

  @IsString()
  lastName: string;

  @IsString()
  schoolCode: string;

  @IsString()
  memberTypeCode: string;

  @IsOptional()
  @IsString()
  groupCode?: string;

  @IsOptional()
  @IsString()
  status?: string;

  @IsOptional()
  @IsDateString()
  joinDate?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  idCardNo?: string;
}

export class ImportMembersDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => MemberCsvRowDto)
  rows: MemberCsvRowDto[];
}