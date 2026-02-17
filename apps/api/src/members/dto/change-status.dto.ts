import { IsEnum, IsOptional, IsDateString } from 'class-validator';
import { MemberStatus } from '@prisma/client';

export class ChangeStatusDto {
  @IsEnum(MemberStatus, { message: 'สถานะไม่ถูกต้อง' })
  status: MemberStatus;

  @IsOptional()
  @IsDateString()
  date?: string;
}

