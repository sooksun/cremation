import { IsOptional, IsNumberString, IsArray } from 'class-validator';

export class UploadPaymentDto {
  @IsNumberString()
  year!: string;

  @IsNumberString()
  month!: string;

  /** multipart ส่งมาเป็น string เสมอ */
  @IsOptional()
  fullDistrict?: string | boolean;

  @IsOptional()
  autoMarkArrears?: string | boolean;

  /** รูปแบบเดิม: ส่งแถวเป็น JSON โดยไม่แนบไฟล์ */
  @IsOptional()
  @IsArray()
  data?: Array<Record<string, string | number | undefined>>;
}
