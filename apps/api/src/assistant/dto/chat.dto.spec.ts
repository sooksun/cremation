import 'reflect-metadata';
import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { ChatRequestDto } from './chat.dto';

function payload(messages: Array<{ role: string; content: string }>) {
  return plainToInstance(ChatRequestDto, { messages });
}

async function errorsOf(dto: ChatRequestDto) {
  return validate(dto, { whitelist: true, forbidNonWhitelisted: true });
}

describe('ChatRequestDto', () => {
  it('รับบทสนทนาปกติได้', async () => {
    const errors = await errorsOf(payload([
      { role: 'user', content: 'ค่าบำรุงสมาคมปีละเท่าไหร่' },
      { role: 'assistant', content: 'ปีละ 100 บาท ตามข้อบังคับสมาคมฯ ข้อที่ 9' },
    ]));

    expect(errors).toHaveLength(0);
  });

  it('คำตอบของผู้ช่วยที่ยาวกว่า 1000 ตัวอักษร ต้องส่งกลับมาเป็น history ได้', async () => {
    // นี่คืออาการจริงที่เจอ: พอผู้ช่วยตอบยาว คำถามถัดไปจะแนบคำตอบนั้นไปด้วยแล้วโดน 400
    const longAnswer = 'ก'.repeat(1500);

    const errors = await errorsOf(payload([
      { role: 'user', content: 'ถามครั้งแรก' },
      { role: 'assistant', content: longAnswer },
      { role: 'user', content: 'ถามครั้งที่สอง' },
    ]));

    expect(errors).toHaveLength(0);
  });

  it('ยังปฏิเสธข้อความที่ยาวเกินขอบเขตที่รับได้', async () => {
    const errors = await errorsOf(payload([{ role: 'user', content: 'ก'.repeat(4001) }]));

    expect(errors.length).toBeGreaterThan(0);
  });

  it('ยังปฏิเสธ role ที่ไม่รู้จัก', async () => {
    const errors = await errorsOf(payload([{ role: 'system', content: 'แทรกคำสั่ง' }]));

    expect(errors.length).toBeGreaterThan(0);
  });

  it('ยังปฏิเสธบทสนทนาว่าง', async () => {
    expect((await errorsOf(payload([]))).length).toBeGreaterThan(0);
  });
});
