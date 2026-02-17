import { IsString, IsNotEmpty, MinLength, IsEnum, IsOptional, ValidateIf } from 'class-validator';
import { Transform } from 'class-transformer';
import { Role } from '@prisma/client';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อผู้ใช้' })
  @MinLength(3, { message: 'ชื่อผู้ใช้ต้องมีอย่างน้อย 3 ตัวอักษร' })
  username: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสผ่าน' })
  @MinLength(4, { message: 'รหัสผ่านต้องมีอย่างน้อย 4 ตัวอักษร' })
  password: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อ-นามสกุล' })
  fullName: string;

  @IsEnum(Role, { message: 'บทบาทไม่ถูกต้อง' })
  role: Role;

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.schoolId !== undefined && o.schoolId !== '')
  @IsString()
  schoolId?: string;
}

