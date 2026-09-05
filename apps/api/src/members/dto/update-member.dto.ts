import {
  IsString,
  IsOptional,
  IsEnum,
  IsDateString,
  IsBoolean,
  IsArray,
  IsNotEmpty,
  ValidateNested,
  ArrayMaxSize,
} from 'class-validator';
import { Type } from 'class-transformer';
import { MemberStatus, MembershipClass } from '@prisma/client';

// ผู้รับผลประโยชน์ตามระเบียบ ข้อ 19 — ส่งมาทั้งชุดเพื่อแทนที่ของเดิม (ลำดับ = ตำแหน่งในอาเรย์)
class BeneficiaryInput {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อผู้รับผลประโยชน์' })
  fullName: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกความสัมพันธ์' })
  relationship: string;

  @IsOptional()
  @IsString()
  phone?: string;
}

// อัปเดตเฉพาะข้อมูลด้านฌาปนกิจ (ข้อมูลบุคคลแก้ที่ association-members)
export class UpdateMemberDto {
  @IsOptional()
  @IsString()
  groupId?: string;

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
  joinDate?: string;

  @IsOptional()
  @IsDateString()
  resignDate?: string;

  @IsOptional()
  @IsDateString()
  deathDate?: string;

  // ถ้าไม่ส่งมา = ไม่แตะผู้รับผลประโยชน์เดิม; ถ้าส่งมา = แทนที่ทั้งชุด
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(3, { message: 'ผู้รับผลประโยชน์ได้สูงสุด 3 คน (ระเบียบ ข้อ 19)' })
  @ValidateNested({ each: true })
  @Type(() => BeneficiaryInput)
  beneficiaries?: BeneficiaryInput[];
}
