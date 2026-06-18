import { IsString, IsNotEmpty, IsOptional, IsDateString, MaxLength } from 'class-validator';

export class CreateAssociationMemberDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกโรงเรียน' })
  schoolId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาเลือกประเภทสมาชิก' })
  memberTypeId: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  associationMemberNo?: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อ' })
  @MaxLength(191)
  firstName: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกนามสกุล' })
  @MaxLength(191)
  lastName: string;

  @IsOptional()
  @IsString()
  @MaxLength(191)
  idCardNo?: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  phone?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  position?: string;

  @IsOptional()
  @IsDateString()
  associationJoinDate?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
