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

// สร้างสมาชิกฌาปนกิจ จากสมาชิกสมาคม (ต้องมี associationMemberId)
export class CreateMemberDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกสมาชิกสมาคม' })
  associationMemberId: string;

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
