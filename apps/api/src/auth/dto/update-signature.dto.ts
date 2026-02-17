import { IsString, IsOptional } from 'class-validator';

export class UpdateSignatureDto {
  @IsString()
  @IsOptional()
  signature?: string;
}

