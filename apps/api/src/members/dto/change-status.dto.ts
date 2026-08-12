import { IsEnum, IsOptional, IsDateString } from 'class-validator';
import { MemberStatus, MembershipEndReason } from '@prisma/client';

export class ChangeStatusDto {
  @IsEnum(MemberStatus, { message: 'สถานะไม่ถูกต้อง' })
  status: MemberStatus;

  @IsOptional()
  @IsDateString()
  date?: string;

  // ระบุเหตุสิ้นสุดสมาชิกภาพเอง (เช่น TRANSFERRED กรณีย้ายไปต่างอำเภอ) —
  // ถ้าไม่ส่งมา ระบบจะอนุมานจากสถานะ + ประเภทสมาชิกตามเดิม
  @IsOptional()
  @IsEnum(MembershipEndReason, { message: 'เหตุสิ้นสุดสมาชิกภาพไม่ถูกต้อง' })
  membershipEndReason?: MembershipEndReason;
}
