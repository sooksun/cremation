import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
  IsDateString,
  IsArray,
  ValidateNested,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';

class AddressDto {
  @IsOptional() @IsString() houseNo?: string;
  @IsOptional() @IsString() moo?: string;
  @IsOptional() @IsString() road?: string;
  @IsOptional() @IsString() soi?: string;
  @IsOptional() @IsString() subdistrict?: string;
  @IsOptional() @IsString() district?: string;
  @IsOptional() @IsString() province?: string;
  @IsOptional() @IsString() zip?: string;
  @IsOptional() @IsString() phone?: string;
}

class BloodRelativeDto {
  @IsOptional() @IsString() name?: string;
  @IsOptional() @IsString() relationship?: string;
}

class BeneficiaryDto {
  @IsOptional() @IsString() name?: string;
  @IsOptional() @IsString() relationship?: string;
  @IsOptional() @IsString() @MaxLength(13) nationalId?: string;
  @IsOptional() @IsString() houseNo?: string;
  @IsOptional() @IsString() moo?: string;
  @IsOptional() @IsString() road?: string;
  @IsOptional() @IsString() soi?: string;
  @IsOptional() @IsString() subdistrict?: string;
  @IsOptional() @IsString() district?: string;
  @IsOptional() @IsString() province?: string;
  @IsOptional() @IsString() @MaxLength(10) zip?: string;
  @IsOptional() @IsString() phone?: string;
  @IsOptional() @IsString() contactPerson?: string;
  @IsOptional() @IsString() contactPhone?: string;
}

export class SubmitApplicationDto {
  @IsEnum(['ordinary', 'contributory'])
  type: 'ordinary' | 'contributory';

  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุส่วนราชการ/โรงเรียน' })
  governmentAgency: string;

  @IsOptional()
  @IsString()
  memberNo?: string;

  @IsOptional()
  @IsDateString()
  applicationDate?: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุชื่อ-นามสกุล' })
  fullName: string;

  @IsOptional()
  @IsDateString()
  birthDate?: string;

  @IsOptional()
  @IsString()
  @MaxLength(13)
  nationalId?: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => AddressDto)
  registeredAddress?: AddressDto;

  @IsOptional()
  @ValidateNested()
  @Type(() => AddressDto)
  contactAddress?: AddressDto;

  @IsOptional()
  @IsEnum(['single', 'married'])
  maritalStatus?: 'single' | 'married';

  @IsOptional()
  @IsString()
  spouseName?: string;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BloodRelativeDto)
  bloodRelatives?: BloodRelativeDto[];

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BeneficiaryDto)
  beneficiaries?: BeneficiaryDto[];
}
