import {
  IsString,
  IsNotEmpty,
  IsDateString,
  IsOptional,
  IsNumber,
  IsEnum,
} from 'class-validator';
import { DeathClaimType, DeceasedType } from '@prisma/client';

export class CreateDeathClaimDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกสมาชิก' })
  memberId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId: string;

  @IsOptional()
  @IsEnum(DeathClaimType, { message: 'ประเภทการเคลมไม่ถูกต้อง' })
  claimType?: DeathClaimType;

  @IsOptional()
  @IsEnum(DeceasedType, { message: 'ประเภทผู้เสียชีวิตไม่ถูกต้อง' })
  deceasedType?: DeceasedType;

  @IsOptional()
  @IsString()
  deceasedName?: string;

  @IsOptional()
  @IsString()
  relationshipNote?: string;

  @IsOptional()
  @IsString()
  protectedPersonId?: string;

  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่รายงาน' })
  reportedDate: string;

  @IsDateString()
  @IsNotEmpty({ message: 'กรุณากรอกวันที่เสียชีวิต' })
  deathDate: string;

  @IsOptional()
  @IsString()
  causeOfDeath?: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อผู้รับเงิน' })
  mainBeneficiary: string;

  @IsOptional()
  @IsString()
  beneficiaryPhone?: string;

  @IsOptional()
  @IsNumber()
  otherDeductions?: number;
}