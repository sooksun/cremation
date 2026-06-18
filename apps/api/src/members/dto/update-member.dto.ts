import { IsString, IsOptional, IsEnum, IsDateString, IsBoolean } from 'class-validator';
import { MemberStatus, MembershipClass } from '@prisma/client';

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
}
