import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
  IsDateString,
  IsArray,
  ValidateNested,
  IsBoolean,
} from 'class-validator';
import { Type } from 'class-transformer';
import { MemberStatus } from '@prisma/client';

class BeneficiaryInput {
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @IsString()
  @IsNotEmpty()
  relationship: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  priority?: number;
}

export class CreateMemberDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกเลขทะเบียนสมาชิก' })
  memberNo: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกประเภทสมาชิก' })
  memberTypeId: string;

  @IsOptional()
  @IsString()
  groupId?: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อ' })
  firstName: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกนามสกุล' })
  lastName: string;

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

  @IsDateString({}, { message: 'กรุณากรอกวันที่สมัครสมาชิก' })
  joinDate: string;

  @IsOptional()
  @IsEnum(MemberStatus)
  status?: MemberStatus;

  @IsOptional()
  @IsBoolean()
  salaryDeduction?: boolean;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BeneficiaryInput)
  beneficiaries?: BeneficiaryInput[];
}

