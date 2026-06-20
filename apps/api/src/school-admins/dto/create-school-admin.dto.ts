import { IsNotEmpty, IsString, MinLength } from 'class-validator';

export class CreateSchoolAdminDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุโรงเรียน' })
  schoolId: string;

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
}