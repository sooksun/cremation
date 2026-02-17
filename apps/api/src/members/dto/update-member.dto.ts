import { IsString, IsOptional, IsEnum, IsDateString, IsBoolean } from 'class-validator';
import { MemberStatus } from '@prisma/client';

export class UpdateMemberDto {
  @IsOptional()
  @IsString()
  memberTypeId?: string;

  @IsOptional()
  @IsString()
  groupId?: string;

  @IsOptional()
  @IsString()
  firstName?: string;

  @IsOptional()
  @IsString()
  lastName?: string;

  @IsOptional()
  @IsString()
  idCardNo?: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsEnum(MemberStatus)
  status?: MemberStatus;

  @IsOptional()
  @IsBoolean()
  salaryDeduction?: boolean;

  @IsOptional()
  @IsDateString()
  joinDate?: string;

  @IsOptional()
  @IsDateString()
  resignDate?: string;

  @IsOptional()
  @IsDateString()
  deathDate?: string;
}

