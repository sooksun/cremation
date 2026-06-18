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