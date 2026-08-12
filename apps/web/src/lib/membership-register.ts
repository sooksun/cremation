export type MembershipType = 'ordinary' | 'contributory';

export interface AddressFields {
  houseNo: string;
  moo: string;
  road: string;
  soi: string;
  subdistrict: string;
  district: string;
  province: string;
  zip: string;
  phone: string;
}

export interface BloodRelative {
  name: string;
  relationship: string;
}

export interface Beneficiary {
  name: string;
  relationship: string;
  nationalId: string;
  houseNo: string;
  moo: string;
  road: string;
  soi: string;
  subdistrict: string;
  district: string;
  province: string;
  zip: string;
  phone: string;
  contactPerson: string;
  contactPhone: string;
}

export interface MembershipRegisterForm {
  type: MembershipType;
  memberNo: string;
  memberSince: string;
  governmentAgency: string;
  schoolId: string;
  applicationDate: string;
  fullName: string;
  birthDate: string;
  age: string;
  nationalId: string;
  registeredAddress: AddressFields;
  maritalStatus: 'single' | 'married';
  spouseName: string;
  contactAddress: AddressFields;
  bloodRelatives: BloodRelative[];
  beneficiaries: Beneficiary[];
  applicantSignatureName: string;
  applicantSignatureDate: string;
}

export const MEMBERSHIP_TYPE_CONFIG: Record<
  MembershipType,
  {
    title: string;
    subtitle: string;
    memberClass: string;
    blankPdf: string;
    supervisorCertLine2: string;
  }
> = {
  ordinary: {
    title: 'ใบสมัครขอเข้าเป็นสมาชิกสามัญฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง',
    subtitle: '(ข้าราชการครู, ลูกจ้างประจำ)',
    memberClass: 'สมาชิกสามัญ',
    blankPdf: '/doc/ref1-1.pdf',
    supervisorCertLine2:
      'เป็นผู้มีสิทธิสมัครเข้าเป็นสมาชิกสามัญของกองทุนฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวงได้',
  },
  contributory: {
    title: 'ใบสมัครขอเข้าเป็นสมาชิกสมทบฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง',
    subtitle: '(ครูอัตราจ้าง ครูธุรการ ลูกจ้างของหน่วยงาน ลูกจ้างของโรงเรียน)',
    memberClass: 'สมาชิกสมทบ',
    blankPdf: '/doc/ref1-2.pdf',
    supervisorCertLine2:
      'เป็นผู้มีสิทธิสมัครเข้าเป็นสมาชิกสมทบฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวงได้',
  },
};

export const REFERENCE_DOCUMENTS = [
  {
    id: 'regulation',
    title: 'ระเบียบฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง',
    subtitle: 'พ.ศ. 2568',
    href: '/doc/ref1.pdf',
    pages: 9,
  },
  {
    id: 'bylaws',
    title: 'ข้อบังคับสมาคมฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง',
    subtitle: 'ฉบับปรับปรุง พ.ศ. 2566',
    href: '/doc/ref2.pdf',
    pages: 9,
  },
  {
    id: 'form-ordinary',
    title: 'แบบฟอร์มใบสมัครสมาชิกสามัญ',
    subtitle: 'ข้าราชการครู, ลูกจ้างประจำ',
    href: '/doc/ref1-1.pdf',
    pages: 2,
  },
  {
    id: 'form-contributory',
    title: 'แบบฟอร์มใบสมัครสมาชิกสมทบ',
    subtitle: 'ครูอัตราจ้าง, ครูธุรการ, ลูกจ้าง',
    href: '/doc/ref1-2.pdf',
    pages: 2,
  },
] as const;

export function emptyAddress(): AddressFields {
  return {
    houseNo: '',
    moo: '',
    road: '',
    soi: '',
    subdistrict: '',
    district: '',
    province: 'เชียงราย',
    zip: '',
    phone: '',
  };
}

export function emptyBeneficiary(): Beneficiary {
  return {
    name: '',
    relationship: '',
    nationalId: '',
    houseNo: '',
    moo: '',
    road: '',
    soi: '',
    subdistrict: '',
    district: '',
    province: 'เชียงราย',
    zip: '',
    phone: '',
    contactPerson: '',
    contactPhone: '',
  };
}

export function createDefaultForm(type: MembershipType = 'ordinary'): MembershipRegisterForm {
  return {
    type,
    memberNo: '',
    memberSince: '',
    governmentAgency: '',
    schoolId: '',
    applicationDate: new Date().toISOString().split('T')[0],
    fullName: '',
    birthDate: '',
    age: '',
    nationalId: '',
    registeredAddress: emptyAddress(),
    maritalStatus: 'single',
    spouseName: '',
    contactAddress: emptyAddress(),
    bloodRelatives: Array.from({ length: 7 }, () => ({ name: '', relationship: '' })),
    beneficiaries: Array.from({ length: 3 }, () => emptyBeneficiary()),
    applicantSignatureName: '',
    applicantSignatureDate: new Date().toISOString().split('T')[0],
  };
}

// ข้อมูลตัวอย่างสำหรับกรอกฟอร์มอัตโนมัติ (ใช้ตอน dev เท่านั้น) — 2 โปรไฟล์
export function createDemoForm(
  index: number,
  school?: { id: string; name: string },
): MembershipRegisterForm {
  const type: MembershipType = index === 1 ? 'contributory' : 'ordinary';
  const base = createDefaultForm(type);

  const padBlood = (rows: BloodRelative[]): BloodRelative[] =>
    Array.from({ length: 7 }, (_, i) => rows[i] ?? { name: '', relationship: '' });
  const padBene = (rows: Beneficiary[]): Beneficiary[] =>
    Array.from({ length: 3 }, (_, i) => rows[i] ?? emptyBeneficiary());

  const profiles: Partial<MembershipRegisterForm>[] = [
    {
      // สามัญ — หญิง สมรส
      fullName: 'สมหญิง ใจดี',
      birthDate: '1986-05-20',
      age: '40',
      nationalId: '1100701234567',
      registeredAddress: { houseNo: '88', moo: '4', road: '', soi: '', subdistrict: 'แม่ฟ้าหลวง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0810000001' },
      contactAddress: { houseNo: '88', moo: '4', road: '', soi: '', subdistrict: 'แม่ฟ้าหลวง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0810000001' },
      maritalStatus: 'married',
      spouseName: 'สมชาย ใจดี',
      bloodRelatives: padBlood([
        { name: 'นายมี ใจดี', relationship: 'บิดา' },
        { name: 'นางมา ใจดี', relationship: 'มารดา' },
        { name: 'สมชาย ใจดี', relationship: 'สามี' },
        { name: 'เด็กหญิงแก้ว ใจดี', relationship: 'บุตร' },
      ]),
      beneficiaries: padBene([
        { name: 'สมชาย ใจดี', relationship: 'สามี', nationalId: '1100704444444', houseNo: '88', moo: '4', road: '', soi: '', subdistrict: 'แม่ฟ้าหลวง', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0810000009', contactPerson: 'สมชาย ใจดี', contactPhone: '0810000009' },
      ]),
      applicantSignatureName: 'นางสมหญิง ใจดี',
    },
    {
      // สมทบ — ชาย โสด
      fullName: 'ประสิทธิ์ มั่นคง',
      birthDate: '1979-11-02',
      age: '46',
      nationalId: '1100709876543',
      registeredAddress: { houseNo: '12/3', moo: '7', road: '', soi: '', subdistrict: 'เทอดไทย', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0820000002' },
      contactAddress: { houseNo: '12/3', moo: '7', road: '', soi: '', subdistrict: 'เทอดไทย', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0820000002' },
      maritalStatus: 'single',
      spouseName: '',
      bloodRelatives: padBlood([
        { name: 'นายแก่น มั่นคง', relationship: 'บิดา' },
        { name: 'นางสมปอง มั่นคง', relationship: 'มารดา' },
        { name: 'ประสงค์ มั่นคง', relationship: 'พี่ชาย' },
      ]),
      beneficiaries: padBene([
        { name: 'นางสมปอง มั่นคง', relationship: 'มารดา', nationalId: '1100705555555', houseNo: '12/3', moo: '7', road: '', soi: '', subdistrict: 'เทอดไทย', district: 'แม่ฟ้าหลวง', province: 'เชียงราย', zip: '57240', phone: '0820000008', contactPerson: 'นางสมปอง มั่นคง', contactPhone: '0820000008' },
      ]),
      applicantSignatureName: 'นายประสิทธิ์ มั่นคง',
    },
  ];

  const p = profiles[index] ?? profiles[0];
  return {
    ...base,
    ...p,
    schoolId: school?.id ?? '',
    governmentAgency: school?.name ?? '',
  };
}

export function formatAddressLine(addr: AddressFields): string {
  const parts = [
    addr.houseNo && `เลขที่ ${addr.houseNo}`,
    addr.moo && `หมู่ที่ ${addr.moo}`,
    addr.road && `ถนน ${addr.road}`,
    addr.soi && `ซอย ${addr.soi}`,
    addr.subdistrict && `ต.${addr.subdistrict}`,
    addr.district && `อ.${addr.district}`,
    addr.province && `จ.${addr.province}`,
    addr.zip,
    addr.phone && `โทร ${addr.phone}`,
  ].filter(Boolean);
  return parts.join(' ') || '-';
}

export function formatBeneficiaryAddress(b: Beneficiary): string {
  const parts = [
    b.houseNo && `บ้านเลขที่ ${b.houseNo}`,
    b.moo && `หมู่ที่ ${b.moo}`,
    b.road && `ถนน ${b.road}`,
    b.soi && `ซอย ${b.soi}`,
    b.subdistrict && `ต.${b.subdistrict}`,
    b.district && `อ.${b.district}`,
    b.province && `จ.${b.province}`,
    b.zip,
    b.phone && `โทร ${b.phone}`,
  ].filter(Boolean);
  return parts.join(' ') || '-';
}