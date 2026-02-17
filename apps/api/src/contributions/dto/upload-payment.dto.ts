import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class UploadPaymentDto {
  @IsNotEmpty()
  @IsNumber()
  periodId: number;

  @IsNotEmpty()
  @IsString()
  month: string; // เดือนที่ต้องการ upload (1-12)
}

