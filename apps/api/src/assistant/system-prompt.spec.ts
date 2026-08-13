import { buildSystemPrompt } from './system-prompt';
import type { FundFacts } from './fund-facts.service';

const FACTS: FundFacts = {
  payingMemberCount: 604,
  isFixedAmount: false,
  memberDeath: { rate: 100, gross: 60400, fundReserve: 6040, netToPay: 54360 },
  protectedDeath: { rate: 50, gross: 30200, fundReserve: 3020, netToPay: 27180 },
};

describe('buildSystemPrompt', () => {
  it('ประกาศให้ชัดว่ามีสองเอกสารคนละองค์กร', () => {
    const prompt = buildSystemPrompt('KB', null);

    expect(prompt).toContain('ข้อบังคับสมาคม');
    expect(prompt).toContain('ระเบียบฌาปนกิจสงเคราะห์');
  });

  it('สั่งให้ค้นทั้งสองฉบับก่อนตอบว่าไม่พบ', () => {
    const prompt = buildSystemPrompt('KB', null);

    expect(prompt).toMatch(/ค้น(หา)?.*ทั้งสองฉบับ/);
  });

  it('แนบตัวเลขจริงเมื่อมีข้อมูลระบบ', () => {
    const prompt = buildSystemPrompt('KB', FACTS);

    expect(prompt).toContain('604');
    expect(prompt).toContain('54,360');
    expect(prompt).toContain('27,180');
  });

  it('สลับเป็นโหมดอธิบายสูตรเมื่อไม่มีข้อมูลระบบ', () => {
    const prompt = buildSystemPrompt('KB', null);

    expect(prompt).toContain('ไม่มีข้อมูลระบบ');
    expect(prompt).not.toContain('===== ข้อมูลระบบ ณ ขณะนี้ =====');
  });

  it('ยังคงห้ามเปิดเผยข้อมูลรายบุคคล', () => {
    const prompt = buildSystemPrompt('KB', FACTS);

    expect(prompt).toMatch(/ห้าม.*รายบุคคล|ห้าม.*ข้อมูลสมาชิกจริง/);
  });

  it('ฝังเนื้อหาระเบียบที่ส่งเข้ามา', () => {
    expect(buildSystemPrompt('เนื้อหาทดสอบ', null)).toContain('เนื้อหาทดสอบ');
  });
});
