import axios from 'axios';
import { useAuthStore } from '@/store/auth';

export const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || '/api',
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true,
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (typeof window !== 'undefined') {
      const message = error.response?.data?.message as string | undefined;
      if (
        error.response?.status === 403 &&
        message?.includes('เปลี่ยนรหัสผ่าน') &&
        !window.location.pathname.startsWith('/change-password')
      ) {
        window.location.href = '/change-password';
        return Promise.reject(error);
      }
      if (error.response?.status === 401) {
        useAuthStore.getState().logout();
        if (!window.location.pathname.startsWith('/login')) {
          window.location.href = '/login';
        }
      }
    }
    return Promise.reject(error);
  },
);

export const fetcher = async <T>(url: string): Promise<T> => {
  const response = await api.get<T>(url);
  return response.data;
};

export interface SchoolCluster {
  id: string;
  code: string;
  name: string;
  _count?: {
    schools: number;
    members?: number;
  };
}

export interface School {
  id: string;
  code: string;
  name: string;
  district?: string;
  province?: string;
  isActive: boolean;
  clusterId?: string;
  cluster?: SchoolCluster;
  _count?: {
    associationMembers: number;
    members?: number;
    groups: number;
  };
}

export interface Member {
  id: string;
  memberNo: string;
  firstName?: string;
  lastName?: string;
  idCardNo?: string;
  birthDate?: string;
  address?: string;
  phone?: string;
  status: 'ACTIVE' | 'RESIGNED' | 'DECEASED' | 'ARREARS' | 'SUSPENDED';
  membershipClass?: 'ORDINARY' | 'CONTRIBUTORY';
  joinDate: string;
  resignDate?: string;
  deathDate?: string;
  salaryDeduction?: boolean;
  applicationSubmittedAt?: string;
  applicationDeadline?: string;
  membershipEndReason?: MembershipEndReason;
  arrearsNoticeSentAt?: string;
  consecutiveArrearsPeriods?: number;
  school: School;
  memberType?: MemberType;
  group?: Group;
  associationMember?: {
    firstName: string;
    lastName: string;
    phone?: string;
    idCardNo?: string;
    birthDate?: string;
    address?: string;
    memberType?: MemberType;
  };
  beneficiaries?: Array<{
    id: string;
    fullName: string;
    relationship: string;
    nationalId?: string;
    houseNo?: string;
    moo?: string;
    road?: string;
    soi?: string;
    subdistrict?: string;
    district?: string;
    province?: string;
    zip?: string;
    phone?: string;
    contactPerson?: string;
    contactPhone?: string;
    priority: number;
  }>;
  protectedPersons?: Array<{
    id: string;
    fullName: string;
    relationship: 'SPOUSE' | 'PARENT' | 'CHILD';
    nationalId?: string;
    phone?: string;
    isActive: boolean;
    endedAt?: string;
    endReason?: string;
  }>;
}

export const membershipClassLabels: Record<'ORDINARY' | 'CONTRIBUTORY', string> = {
  ORDINARY: 'สมาชิกสามัญ',
  CONTRIBUTORY: 'สมาชิกสมทบ',
};

export type MembershipEndReason =
  | 'DECEASED'
  | 'RETIRED'
  | 'RESIGNED'
  | 'TRANSFERRED'
  | 'ARREARS_TERMINATED'
  | 'MANUAL';

export const membershipEndReasonLabels: Record<MembershipEndReason, string> = {
  DECEASED: 'เสียชีวิต',
  RETIRED: 'เกษียณอายุราชการ',
  RESIGNED: 'ลาออก',
  TRANSFERRED: 'ย้ายออกนอกเขต',
  ARREARS_TERMINATED: 'ขาดส่งเงินสงเคราะห์',
  MANUAL: 'อื่น ๆ (บันทึกโดยเจ้าหน้าที่)',
};

export const protectedRelationshipLabels: Record<'SPOUSE' | 'PARENT' | 'CHILD', string> = {
  SPOUSE: 'คู่สมรส',
  PARENT: 'บิดา/มารดา',
  CHILD: 'บุตร/ธิดา',
};

export interface MemberType {
  id: string;
  code: string;
  name: string;
  description?: string;
}

export interface Group {
  id: string;
  code: string;
  name: string;
  school: School;
}

export interface ContributionPeriod {
  id: string;
  year: number;
  month: number;
  welfareRate: number;
  serviceFee: number;
  isClosed: boolean;
  _count?: {
    contributions: number;
  };
}

export interface ContributionSettings {
  serviceFeeEnabled: boolean;
}

export function periodTotalPerPerson(
  period: Pick<ContributionPeriod, 'welfareRate' | 'serviceFee'>,
  serviceFeeEnabled: boolean,
) {
  return Number(period.welfareRate) + (serviceFeeEnabled ? Number(period.serviceFee) : 0);
}

export type DeathClaimStatus =
  | 'REPORTED'
  | 'COLLECTING'
  | 'FUND_COMPLETE'
  | 'READY_TO_PAY'
  | 'PAID';

export type DeathCollectionChannel = 'SALARY_DEDUCTION' | 'BANK_TRANSFER';

export interface DocumentChecklistItem {
  key: string;
  label: string;
  required: boolean;
  checked: boolean;
  checkedAt?: string;
}

export interface DeathClaim {
  id: string;
  claimNo: string;
  claimType?: 'MEMBER_DEATH' | 'PROTECTED_DEATH';
  deceasedType?: 'MEMBER' | 'PARENT' | 'CHILD' | 'SPOUSE';
  deceasedName?: string;
  relationshipNote?: string | null;
  reportedDate: string;
  deathDate: string;
  causeOfDeath?: string | null;
  mainBeneficiary: string;
  beneficiaryPhone?: string | null;
  activeMemberCount: number;
  welfareRate: number;
  payoutRatio?: number;
  otherDeductions: number;
  netToPay: number;
  totalContribution: number;
  associationSupport: number;
  status?: DeathClaimStatus;
  collectionChannel?: DeathCollectionChannel;
  notifyAuthorityDeadline?: string | null;
  collectionDeadline?: string;
  documentDeadline?: string;
  paymentDeadline?: string;
  collectedAmount?: number;
  collectionCompletedAt?: string | null;
  documentsComplete?: boolean;
  documentChecklist?: DocumentChecklistItem[];
  workflowNotes?: string | null;
  approvedAt?: string | null;
  approverName?: string | null;
  approverSignature?: string | null;
  approvedBy?: { id: string; fullName: string; role: string };
  member: {
    id: string;
    memberNo: string;
    joinDate: string;
    firstName?: string;
    lastName?: string;
    associationMember?: {
      firstName: string;
      lastName: string;
      memberType?: MemberType;
    };
  };
  school: School;
  payment?: {
    payDate: string;
    amount: number;
    method: string;
  };
}

export const DEATH_CLAIM_STATUS_LABELS: Record<DeathClaimStatus, string> = {
  REPORTED: 'แจ้งแล้ว',
  COLLECTING: 'กำลังเก็บเงิน',
  FUND_COMPLETE: 'เก็บครบแล้ว',
  READY_TO_PAY: 'พร้อมจ่าย',
  PAID: 'จ่ายแล้ว',
};

export const DEATH_COLLECTION_CHANNEL_LABELS: Record<DeathCollectionChannel, string> = {
  SALARY_DEDUCTION: 'หักผ่านเงินเดือน (สามัญ)',
  BANK_TRANSFER: 'โอนเงิน (สมทบ)',
};

export interface DashboardData {
  members: {
    total: number;
    active: number;
    deceased: number;
    resigned: number;
    arrears: number;
  };
  deathClaims: {
    thisYear: number;
  };
  finance: {
    receiptsThisMonth: { count: number; amount: number };
    paymentsThisMonth: { count: number; amount: number };
  };
}
