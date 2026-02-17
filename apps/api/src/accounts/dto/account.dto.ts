import { IsString, IsNotEmpty, IsEnum, IsOptional, IsBoolean } from 'class-validator';
import { AccountType } from '@prisma/client';

export class CreateAccountDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสบัญชี' })
  code: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อบัญชี' })
  name: string;

  @IsEnum(AccountType, { message: 'ประเภทบัญชีไม่ถูกต้อง' })
  type: AccountType;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class UpdateAccountDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsEnum(AccountType)
  type?: AccountType;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

