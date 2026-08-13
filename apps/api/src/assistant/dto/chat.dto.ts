import { Type } from 'class-transformer';
import { ArrayMaxSize, ArrayNotEmpty, IsArray, IsIn, IsString, MaxLength, ValidateNested } from 'class-validator';

/**
 * เพดานนี้ใช้กับ "ทุกข้อความในบทสนทนา" ไม่ใช่เฉพาะที่ผู้ใช้พิมพ์ เพราะฝั่งเว็บส่งประวัติ
 * ทั้งก้อนกลับมาทุกครั้ง คำตอบของผู้ช่วยจึงต้องอยู่ในเพดานนี้ด้วย
 * ช่องพิมพ์บนหน้าจอยังจำกัดที่ 1,000 ตัวอักษรตามเดิม ส่วน 4,000 คือเผื่อคำตอบที่ยาว
 */
export const MAX_MESSAGE_LENGTH = 4000;

export class ChatMessageDto {
  @IsIn(['user', 'assistant'])
  role!: 'user' | 'assistant';

  @IsString()
  @MaxLength(MAX_MESSAGE_LENGTH, {
    message: `ข้อความต้องไม่เกิน ${MAX_MESSAGE_LENGTH} ตัวอักษร`,
  })
  content!: string;
}

export class ChatRequestDto {
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(40)
  @ValidateNested({ each: true })
  @Type(() => ChatMessageDto)
  messages!: ChatMessageDto[];
}
