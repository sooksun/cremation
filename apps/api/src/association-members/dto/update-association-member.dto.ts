import { IsOptional, IsString, IsDateString, MaxLength } from 'class-validator';

export class UpdateAssociationMemberDto {
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
