import { join } from 'path';
import { readdirSync } from 'fs';
import { loadKnowledgeBase } from './knowledge-loader';
import { buildSystemPrompt } from './system-prompt';

/**
 * เทสต์ชุดอื่นของผู้ช่วยใช้ฐานความรู้ปลอม ('KB' หรือ temp dir) ทั้งหมด
 * ถ้าไฟล์ระเบียบจริงหาย ถูกเปลี่ยนชื่อ หรือ assets glob ใน nest-cli.json พัง
 * จะไม่มีเทสต์ตัวไหนล้มเลย — ผู้ช่วยจะตอบ "ไม่พบข้อกำหนดนี้" ไปเงียบ ๆ บน production
 * ชุดนี้จึงอ่านโฟลเดอร์ knowledge ของจริง
 */
describe('ฐานความรู้ของผู้ช่วย — ครอบคลุมทั้งสองฉบับ', () => {
  const KB_DIR = join(__dirname, 'knowledge');
  const kb = loadKnowledgeBase(KB_DIR);

  it('มีไฟล์ครบทั้งสารบัญ ระเบียบฌาปนกิจ ข้อบังคับสมาคม และแบบฟอร์ม', () => {
    const files = readdirSync(KB_DIR).filter((f) => f.endsWith('.md')).sort();

    expect(files).toEqual([
      '00-index-and-relations.md',
      '01-regulation-cremation-2568.md',
      '02-association-bylaws-2566.md',
      '03-application-forms.md',
    ]);
  });

  it('สารบัญต้องมาก่อน เพราะ loader เรียงตามชื่อไฟล์และโมเดลอ่านส่วนต้นก่อน', () => {
    const indexAt = kb.indexOf('สารบัญเอกสารและความเชื่อมโยง');
    const cremationAt = kb.indexOf('**ข้อ 1.**');
    const bylawsAt = kb.indexOf('**ข้อที่ 1**');

    expect(indexAt).toBeGreaterThanOrEqual(0);
    expect(indexAt).toBeLessThan(cremationAt);
    expect(cremationAt).toBeLessThan(bylawsAt);
  });

  it('ระเบียบฌาปนกิจฯ ต้องมีครบข้อ 1–21', () => {
    const missing = Array.from({ length: 21 }, (_, i) => i + 1).filter(
      (n) => !kb.includes(`**ข้อ ${n}.**`),
    );

    expect(missing).toEqual([]);
  });

  it('ข้อบังคับสมาคมฯ ต้องมีครบข้อที่ 1–38', () => {
    const missing = Array.from({ length: 38 }, (_, i) => i + 1).filter(
      (n) => !kb.includes(`**ข้อที่ ${n}**`),
    );

    expect(missing).toEqual([]);
  });

  /**
   * คำถามที่ผู้ใช้ถามจริงบ่อย ๆ คู่กับข้อความในเอกสารที่เป็นคำตอบ
   * ถ้า anchor หาย = ผู้ช่วยตอบคำถามนั้นไม่ได้อีกต่อไป
   */
  const ANCHORS: Array<[string, string[]]> = [
    ['ค่าบำรุงสมาคมปีละเท่าไหร่', ['ค่าบำรุง', 'ปีละ 100 บาท']],
    ['สมาชิกสมาคมมีกี่ประเภท', ['สมาชิกของสมาคม มี 3 ประเภท']],
    ['สมาชิกฌาปนกิจมีกี่ประเภท', ['สมาชิกภาพ แบ่งออกเป็น 2 ประเภท']],
    ['เก็บศพละเท่าไหร่', ['100 บาท', '50 บาท']],
    ['หักเข้ากองทุนเท่าไหร่ จ่ายเท่าไหร่', ['ร้อยละ 10', 'ร้อยละ 90']],
    ['ใครได้รับความคุ้มครองบ้าง', ['คู่สมรส', 'บิดา', 'บุตร']],
    ['ลำดับผู้รับเงินสงเคราะห์', ['ผู้รับผลประโยชน์']],
    ['พ้นสภาพสมาชิกฌาปนกิจเมื่อไหร่', ['สมาชิกภาพสิ้นสุดลง']],
    ['พ้นสภาพสมาชิกสมาคมเมื่อไหร่', ['ค้างค่าบำรุงสมาคมฯ 2 ปี']],
    ['นายกสมาคมสั่งจ่ายได้เท่าไหร่', ['5,000']],
    ['คณะกรรมการฌาปนกิจมีใครบ้าง', ['ประธานกรรมการ', 'รองประธาน']],
    ['ขอรับเงินต้องทำยังไง', ['การขอรับเงินค่าฌาปนกิจสงเคราะห์']],
    ['แก้ข้อบังคับสมาคมต้องทำยังไง', ['เปลี่ยนแปลงแก้ไข โดยมติของที่ประชุมใหญ่']],
    ['สมัครสมาชิกใช้เอกสารอะไร', ['ใบสมัคร']],
  ];

  it.each(ANCHORS)('ตอบคำถาม "%s" ได้ — คำตอบอยู่ในฐานความรู้', (_question, anchors) => {
    for (const anchor of anchors) {
      expect(kb).toContain(anchor);
    }
  });

  it('system prompt ที่ส่งจริงมีเนื้อหาทั้งสองฉบับอยู่ครบ', () => {
    const prompt = buildSystemPrompt(kb, null);

    expect(prompt).toContain('**ข้อ 13.**'); // การหักเงินสงเคราะห์ศพ — ฝั่งฌาปนกิจ
    expect(prompt).toContain('**ข้อที่ 9**'); // ค่าบำรุงสมาคม — ฝั่งสมาคมฯ
    expect(prompt.length).toBeGreaterThan(kb.length);
  });
});
