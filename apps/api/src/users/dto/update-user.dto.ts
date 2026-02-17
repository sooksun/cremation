import { IsString, MinLength, IsEnum, IsOptional, ValidateIf } from 'class-validator';
import { Transform } from 'class-transformer';
import { Role } from '@prisma/client';

export class UpdateUserDto {
  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.password !== undefined && o.password !== '')
  @IsString()
  @MinLength(4, { message: 'รหัสผ่านต้องมีอย่างน้อย 4 ตัวอักษร' })
  password?: string;

  @IsOptional()
  @IsString()
  fullName?: string;

  @IsOptional()
  @IsEnum(Role, { message: 'บทบาทไม่ถูกต้อง' })
  role?: Role;

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.schoolId !== undefined && o.schoolId !== '')
  @IsString()
  schoolId?: string;

  @IsOptional()
  @IsString()
  signature?: string;
}

