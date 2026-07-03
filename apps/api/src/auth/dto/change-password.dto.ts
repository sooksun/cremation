import { IsNotEmpty, IsString, MinLength, Matches } from 'class-validator';

export class ChangePasswordDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสผ่านปัจจุบัน' })
  currentPassword: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสผ่านใหม่' })
  @MinLength(8, { message: 'รหัสผ่านใหม่ต้องมีอย่างน้อย 8 ตัวอักษร' })
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-+=~`[\]\\;'/]).{8,}$/, {
    message: 'รหัสผ่านใหม่ต้องมีตัวพิมพ์ใหญ่, ตัวพิมพ์เล็ก, ตัวเลข และอักขระพิเศษอย่างน้อย 1 ตัว',
  })
  newPassword: string;
}