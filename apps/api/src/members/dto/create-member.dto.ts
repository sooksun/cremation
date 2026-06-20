import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
  IsDateString,
  IsArray,
  ValidateNested,
  IsBoolean,
  ValidateIf,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';
import { MemberStatus, MembershipClass, ProtectedRelationship } from '@prisma/client';

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

class ProtectedPersonInput {
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

// สร้างสมาชิกฌาปนกิจ — สร้าง AssociationMember อัตโนมัติ หรือเชื่อมกับรายการที่มีอยู่
export class CreateMemberDto {
  @ValidateIf((dto: CreateMemberDto) => !dto.schoolId)
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกสมาชิกสมาคมหรือกรอกข้อมูลสมาชิกใหม่' })
  associationMemberId?: string;

  @ValidateIf((dto: CreateMemberDto) => !dto.associationMemberId)
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId?: string;

  @ValidateIf((dto: CreateMemberDto) => !dto.associationMemberId)
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกประเภทสมาชิก' })
  memberTypeId?: string;

  @ValidateIf((dto: CreateMemberDto) => !dto.associationMemberId)
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อ' })
  @MaxLength(191)
  firstName?: string;

  @ValidateIf((dto: CreateMemberDto) => !dto.associationMemberId)
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกนามสกุล' })
  @MaxLength(191)
  lastName?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  associationMemberNo?: string;

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
  memberNo?: string;

  @IsOptional()
  @IsString()
  groupId?: string;

  @IsDateString({}, { message: 'กรุณากรอกวันที่สมัครเข้าร่วมฌาปนกิจ' })
  joinDate: string;

  @IsOptional()
  @IsEnum(MemberStatus)
  status?: MemberStatus;

  @IsOptional()
  @IsBoolean()
  salaryDeduction?: boolean;

  @IsOptional()
  @IsEnum(MembershipClass)
  membershipClass?: MembershipClass;

  @IsOptional()
  @IsDateString()
  applicationSubmittedAt?: string;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BeneficiaryInput)
  beneficiaries?: BeneficiaryInput[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ProtectedPersonInput)
  protectedPersons?: ProtectedPersonInput[];
}