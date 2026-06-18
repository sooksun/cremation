import { IsOptional, IsString, IsDateString, MaxLength } from 'class-validator';

export class UpdateAssociationMemberDto {
  @IsOptional()
  @IsString()
  @MaxLength(191)
  firstName?: string;

  @IsOptional()
  @IsString()
  @MaxLength(191)
  lastName?: string;

  @IsOptional()
  @IsString()
  @MaxLength(191)
  idCardNo?: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  phone?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  associationMemberNo?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  position?: string;

  @IsOptional()
  @IsDateString()
  associationJoinDate?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
