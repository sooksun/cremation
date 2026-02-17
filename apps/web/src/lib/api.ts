import axios from 'axios';
import { useAuthStore } from '@/store/auth';

export const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to requests
api.interceptors.request.use((config) => {
  const token = useAuthStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      useAuthStore.getState().logout();
      window.location.href = '/login';
    }
    return Promise.reject(error);
  },
);

// API helper functions
export const fetcher = async <T>(url: string): Promise<T> => {
  const response = await api.get<T>(url);
  return response.data;
};

// Types
export interface School {
  id: string;
  code: string;
  name: string;
  district?: string;
  province?: string;
  isActive: boolean;
  _count?: {
    members: number;
    groups: number;
  };
}

export interface Member {
  id: string;
  memberNo: string;
  firstName: string;
  lastName: string;
  idCardNo?: string;
  birthDate?: string;
  address?: string;
  phone?: string;
  status: 'ACTIVE' | 'RESIGNED' | 'DECEASED' | 'ARREARS' | 'SUSPENDED';
  joinDate: string;
  resignDate?: string;
  deathDate?: string;
  salaryDeduction?: boolean;
  school: School;
  memberType: MemberType;
  group?: Group;
}

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

export interface DeathClaim {
  id: string;
  claimNo: string;
  reportedDate: string;
  deathDate: string;
  mainBeneficiary: string;
  netToPay: number;
  member: {
    id: string;
    memberNo: string;
    firstName: string;
    lastName: string;
  };
  school: School;
  payment?: {
    payDate: string;
    amount: number;
    method: string;
  };
}

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

