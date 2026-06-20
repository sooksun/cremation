import { IsNotEmpty, IsOptional, IsString, MinLength } from 'class-validator';

export class UpdateSchoolAdminDto {
  @IsOptional()
  @IsString()
  @MinLength(3, { message: 'ชื่อผู้ใช้ต้องมีอย่างน้อย 3 ตัวอักษร' })
  username?: string;

  @IsOptional()
  @IsString()
  @MinLength(8, { message: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร' })
  password?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อ-นามสกุล' })
  fullName?: string;
}