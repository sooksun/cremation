import { IsNotEmpty, IsString } from 'class-validator';

export class CreateSchoolClusterDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสกลุ่ม' })
  code: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อกลุ่ม' })
  name: string;
}