import * as fs from 'fs';
import * as path from 'path';
import { MEMBERSHIP_TYPE_CONFIG, type MembershipRegisterForm } from './membership-register';

// ตัวสร้าง PDF เรียก fetch ด้วย path แบบเว็บ — ต่อให้อ่านจากดิสก์แทนเพื่อทดสอบนอกเบราว์เซอร์
const PUBLIC = path.join(__dirname, '../../public');
(global as any).fetch = async (url: string) => {
  const file = path.join(PUBLIC, url.replace(/^\//, ''));
  const buf = fs.readFileSync(file);
  return { ok: true, arrayBuffer: async () => buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.byteLength) };
};

const addr = (t: string) => ({
  houseNo: t + '99/9', moo: '9', road: 'ถนน' + t, soi: 'ซอย' + t,
  subdistrict: 'เทอดไทย', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0812345678',
});

const DATA: MembershipRegisterForm = {
  type: 'ordinary' as never,
  memberNo: 'M0604', memberSince: '2026-01-15', governmentAgency: 'โรงเรียนตำรวจตระเวนชายแดนศรีสมวงศ์ กลุ่มเครือข่ายพัฒนาการศึกษาพื้นที่โครงการพัฒนาดอยตุง',
  schoolId: 'x', applicationDate: '2026-01-15',
  fullName: 'นางสาวพัชรี สิงห์ฉลาด', birthDate: '1985-03-20', age: '41',
  nationalId: '1234567890123',
  registeredAddress: addr('ก'), maritalStatus: 'married', spouseName: 'นายธนันชัย พิพิธพงศ์สันต์',
  contactAddress: addr('ข'),
  bloodRelatives: Array.from({length:7},(_,i)=>({ name:`ญาติลำดับ${i+1} ผู้ใหญ่`, relationship:'บิดา' })),
  beneficiaries: Array.from({length:3},(_,i)=>({
    name:`ผู้รับเงิน${i+1} ฟ้าใส`, relationship:'บุตร', nationalId:'9876543210123',
    ...addr('ค'), contactPerson:'ผู้ติดต่อ น้ำใจ', contactPhone:'0898765432',
  })) as never,
  applicantSignatureName: 'นางสาวพัชรี สิงห์ฉลาด', applicantSignatureDate: '2026-01-15',
};

describe('buildMembershipRegisterPdf', () => {
  it('ประกอบแบบฟอร์มทางการทั้งสองหน้าได้จากข้อมูลที่กรอกครบ', async () => {
    const { buildMembershipRegisterPdf } = await import('./membership-register-pdf');
    const bytes = await buildMembershipRegisterPdf(DATA);

    expect(bytes.length).toBeGreaterThan(10000);
    // ต้องเป็นไฟล์ PDF จริง ไม่ใช่ไบต์ว่าง
    expect(Buffer.from(bytes.slice(0, 5)).toString()).toBe('%PDF-');
  });

  // ชื่อหน่วยงานจริงยาวถึง 88 ตัวอักษร แต่ช่องบนแบบฟอร์มกำหนดไว้ 22 ตัว
  // เดิมตัดทิ้งจนเหลือราวหนึ่งในสี่ ตอนนี้ย่อขนาดตัวอักษรให้พอดีแทน
  it('ชื่อหน่วยงานที่ยาวเกินช่องต้องไม่ทำให้สร้างไฟล์ล้มเหลว', async () => {
    const { buildMembershipRegisterPdf } = await import('./membership-register-pdf');
    const bytes = await buildMembershipRegisterPdf({ ...DATA, governmentAgency: 'ก'.repeat(200) });

    expect(bytes.length).toBeGreaterThan(10000);
  });
});
