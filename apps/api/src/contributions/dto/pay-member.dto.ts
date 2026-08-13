import { IsDateString, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from 'class-validator';

/**
 * body ของ POST /contributions/pay-member ต้องเป็น class จริง ไม่ใช่ inline type
 * ไม่งั้น metadata ที่ Nest เห็นจะเป็น Object แล้ว ValidationPipe จะข้ามการตรวจทั้งก้อน
 * ปล่อยให้ amount แบบ "1,050" กลายเป็น NaN หรือยอดติดลบหลุดเข้าไปถึงชั้นบันทึกบัญชี
 */
export class PayMemberDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุสมาชิก' })
  memberId: string;

  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุงวด' })
  periodId: string;

  @IsOptional()
  @IsNumber({}, { message: 'จำนวนเงินต้องเป็นตัวเลข' })
  @Min(0, { message: 'จำนวนเงินต้องไม่ติดลบ' })
  amount?: number;

  @IsOptional()
  @IsDateString({}, { message: 'รูปแบบวันที่ชำระไม่ถูกต้อง' })
  paidDate?: string;
}
