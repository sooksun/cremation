import { IsOptional, IsString, IsDateString, MaxLength, IsEnum, IsIn } from 'class-validator';
import { AssociationMemberStatus, MembershipEndReason } from '@prisma/client';

// เหตุที่ใช้ได้ในระดับสมาคม — ARREARS_TERMINATED เป็นเรื่องของกองทุนฌาปนกิจเท่านั้น
export const ASSOCIATION_END_REASONS = [
  MembershipEndReason.TRANSFERRED,
  MembershipEndReason.RESIGNED,
  MembershipEndReason.RETIRED,
  MembershipEndReason.DECEASED,
  MembershipEndReason.MANUAL,
] as const;

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
  memberTypeId?: string;

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

  @IsOptional()
  @IsEnum(AssociationMemberStatus, { message: 'สถานะสมาชิกสมาคมไม่ถูกต้อง' })
  status?: AssociationMemberStatus;

  @IsOptional()
  @IsIn(ASSOCIATION_END_REASONS as unknown as string[], {
    message: 'เหตุสิ้นสุดสมาชิกภาพไม่ถูกต้อง',
  })
  membershipEndReason?: MembershipEndReason;

  @IsOptional()
  @IsDateString()
  membershipEndDate?: string;
}
