import { IsString, IsNotEmpty, IsOptional, IsBoolean } from 'class-validator';

export class CreateBankAccountDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อธนาคาร' })
  bankName: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกเลขบัญชี' })
  accountNo: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณากรอกชื่อบัญชี' })
  accountName: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}

export class UpdateBankAccountDto {
  @IsOptional()
  @IsString()
  bankName?: string;

  @IsOptional()
  @IsString()
  accountNo?: string;

  @IsOptional()
  @IsString()
  accountName?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}
