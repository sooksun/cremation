import { IsString, IsOptional, Matches, MaxLength } from 'class-validator';

// คอลัมน์ User.signature เป็น TEXT (65,535 ไบต์) — MySQL จะตัดปลายทิ้งเงียบ ๆ ถ้าเกิน
// ทำให้ลายเซ็นในใบเสร็จกลายเป็นรูปเสีย จึงกันไว้ที่ชั้น DTO ก่อนถึงฐานข้อมูล
export const SIGNATURE_MAX_LENGTH = 60_000;

export class UpdateSignatureDto {
  @IsString()
  @IsOptional()
  @MaxLength(SIGNATURE_MAX_LENGTH, {
    message: 'รูปลายเซ็นมีขนาดใหญ่เกินไป กรุณาใช้รูปที่ตัดเฉพาะลายเซ็น',
  })
  // ค่าว่าง = ลบลายเซ็น นอกนั้นต้องเป็น data URL ของรูปภาพเท่านั้น
  @Matches(/^$|^data:image\/(png|jpeg|webp);base64,[A-Za-z0-9+/=]+$/, {
    message: 'รูปแบบลายเซ็นไม่ถูกต้อง',
  })
  signature?: string;
}
