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
  @MinLength(8, { message: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร' })
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

  @IsOptional()
  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.groupId !== undefined && o.groupId !== '')
  @IsString()
  groupId?: string;

  @Transform(({ value }) => value === '' ? undefined : value)
  @ValidateIf((o) => o.role === Role.MEMBER || o.memberId !== undefined)
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกสมาชิก' })
  memberId?: string;
}
