import { Test } from '@nestjs/testing';
import { AssistantModule } from './assistant.module';
import { AssistantService } from './assistant.service';

describe('AssistantModule', () => {
  it('compiles via Nest DI and resolves AssistantService (module boots)', async () => {
    const moduleRef = await Test.createTestingModule({
      imports: [AssistantModule],
    }).compile();

    // onModuleInit จะถูกเรียกเพื่อโหลด knowledge base จริงจาก src/assistant/knowledge
    await moduleRef.init();

    // ตรวจสอบว่า AssistantService ได้รับการ resolve อย่างถูกต้อง
    const svc = moduleRef.get(AssistantService);
    expect(svc).toBeInstanceOf(AssistantService);

    // ทำความสะอาด
    await moduleRef.close();
  });
});
