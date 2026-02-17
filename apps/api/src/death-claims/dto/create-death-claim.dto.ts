import { IsString, IsNotEmpty, IsDateString, IsOptional, IsNumber } from 'class-validator';

export class CreateDeathClaimDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกสมาชิก' })
  memberId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId: string;

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
  welfareRate?: number; // อัตราต่อคน (default 20)

  @IsOptional()
  @IsNumber()
  associationSupport?: number; // เงินสมทบจากสมาคม

  @IsOptional()
  @IsNumber()
  otherDeductions?: number; // หักรายการอื่นๆ
}
