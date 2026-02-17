import { IsString, IsNotEmpty, IsOptional } from 'class-validator';

export class CreateGroupDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสกลุ่ม' })
  code: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อกลุ่ม' })
  name: string;

  @IsOptional()
  @IsString()
  leaderId?: string;
}

