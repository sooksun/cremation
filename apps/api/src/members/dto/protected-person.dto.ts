import { IsString, IsNotEmpty, IsOptional, IsEnum, IsBoolean } from 'class-validator';
import { ProtectedRelationship } from '@prisma/client';

export class CreateProtectedPersonDto {
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsEnum(ProtectedRelationship)
  relationship: ProtectedRelationship;

  @IsOptional()
  @IsString()
  nationalId?: string;

  @IsOptional()
  @IsString()
  phone?: string;
}

export class UpdateProtectedPersonDto {
  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsEnum(ProtectedRelationship)
  relationship?: ProtectedRelationship;

  @IsOptional()
  @IsString()
  nationalId?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsString()
  endReason?: string;
}