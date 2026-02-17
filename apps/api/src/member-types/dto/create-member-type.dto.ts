import { IsString, IsNotEmpty, IsOptional, IsBoolean } from 'class-validator';

export class CreateMemberTypeDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสประเภท' })
  code: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อประเภท' })
  name: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}

