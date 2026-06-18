import { IsString, IsNotEmpty, IsOptional, IsBoolean } from 'class-validator';

export class CreateSchoolDto {
  @IsOptional()
  @IsString()
  clusterId?: string;
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกรหัสโรงเรียน' })
  code: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อโรงเรียน' })
  name: string;

  @IsOptional()
  @IsString()
  district?: string;

  @IsOptional()
  @IsString()
  province?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

