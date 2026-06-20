'use client';

import { useParams } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  User,
  Phone,
  MapPin,
  Calendar,
  Building2,
  Users,
  CreditCard,
  CheckCircle,
  AlertCircle,
  Clock,
  Flower2,
  DollarSign,
  ArrowLeft,
  FileText,
  TrendingUp,
} from 'lucide-react';
import Link from 'next/link';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';
import { api } from '@/lib/api';
import { formatThaiDate, formatThaiDateShort } from '@/components/ThaiDatePicker';
import { useAuthStore } from '@/store/auth';

interface MemberProfile {
  member: {
    id: string;
    memberNo: string;
    fullName: string;
    firstName: string;
    lastName: string;
    idCardNo?: string;
    phone?: string;
    address?: string;
    birthDate?: string;
    joinDate: string;
    status: string;
    school: { id: string; name: string };
    memberType: { id: string; name: string };
    group?: { id: string; name: string };
  };
  beneficiaries: {
    id: string;
    fullName: string;
    relationship: string;
    phone?: string;
    priority: number;
  }[];
  summary: {
    membershipYears: number;
    totalContributions: number;
    paidContributions: number;
    paymentRate: number;
    totalPaid: number;
    arrearsCount: number;
    arrearsAmount: number;
    benefitsReceived: number;
    totalBenefitsAmount: number;
  };
  recentContributions: {
    id: string;
    period: { year: number; month: number };
    totalAmount: string;
    paidAmount: string;
    paidDate?: string;
    isArrears: boolean;
  }[];
  arrears: any[];
  deathClaims: any[];
}

const statusLabels: Record<string, string> = {
  ACTIVE: 'ปกติ',
  RESIGNED: 'ลาออก',
  DECEASED: 'เสียชีวิต',
  ARREARS: 'ค้างชำระ',
  SUSPENDED: 'พักสมาชิก',
};

const statusColors: Record<string, string> = {
  ACTIVE: 'badge-success',
  RESIGNED: 'badge-neutral',
  DECEASED: 'badge-danger',
  ARREARS: 'badge-warning',
  SUSPENDED: 'badge-info',
};

const thaiMonths = ['ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

export default function MemberProfilePage() {
  const params = useParams();
  const memberId = params.id as string;
  const isMemberUser = useAuthStore((state) => state.user?.role === 'MEMBER');

  const { data, isLoading } = useQuery<MemberProfile>({
    queryKey: ['member-profile', memberId],
    queryFn: async () => {
      const response = await api.get(`/reports/member-profile/${memberId}`);
      return response.data;
    },
  });

  const formatCurrency = (amount: number | string) => {
    const num = typeof amount === 'string' ? parseFloat(amount) : amount;
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(num);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!data) {
    return (
      <div className="text-center py-20">
        <User className="w-16 h-16 mx-auto text-slate-300 mb-4" />
        <p className="text-lg text-slate-500">ไม่พบข้อมูลสมาชิก</p>
        <Link
          href="/members"
          className={isMemberUser ? 'hidden' : 'btn-secondary mt-4'}
        >
          กลับไปรายการสมาชิก
        </Link>
      </div>
    );
  }

  // Prepare chart data
  const contributionChartData = data.recentContributions.slice(0, 12).reverse().map((c) => ({
    name: `${thaiMonths[c.period.month - 1]} ${(c.period.year + 543).toString().slice(-2)}`,
    ยอดชำระ: parseFloat(c.totalAmount),
    ชำระแล้ว: parseFloat(c.paidAmount),
  }));

  const paymentPieData = [
    { name: 'ชำระแล้ว', value: data.summary.paidContributions, color: '#10b981' },
    { name: 'ค้างชำระ', value: data.summary.arrearsCount, color: '#f59e0b' },
  ];

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link
          href={`/members/${memberId}`}
          className={isMemberUser ? 'hidden' : 'p-2 hover:bg-slate-100 rounded-lg'}
        >
          <ArrowLeft size={20} />
        </Link>
        <div className="flex-1">
          <div className="flex items-center gap-3">
            <h1 className="text-2xl font-display font-bold text-slate-900">
              ข้อมูลสมาชิก
            </h1>
            <span className={statusColors[data.member.status]}>
              {statusLabels[data.member.status]}
            </span>
          </div>
          <p className="text-slate-500 mt-1">
            {data.member.fullName} • เลขสมาชิก {data.member.memberNo}
          </p>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="card p-5"
        >
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-primary-100 rounded-xl flex items-center justify-center">
              <Calendar className="w-6 h-6 text-primary-600" />
            </div>
            <div>
              <p className="text-sm text-slate-500">อายุสมาชิก</p>
              <p className="text-2xl font-bold text-slate-900">{data.summary.membershipYears} ปี</p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="card p-5"
        >
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
              <CreditCard className="w-6 h-6 text-emerald-600" />
            </div>
            <div>
              <p className="text-sm text-slate-500">ยอดชำระรวม</p>
              <p className="text-xl font-bold text-emerald-600">{formatCurrency(data.summary.totalPaid)}</p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="card p-5"
        >
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-sky-100 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-sky-600" />
            </div>
            <div>
              <p className="text-sm text-slate-500">อัตราการชำระ</p>
              <p className="text-2xl font-bold text-sky-600">{data.summary.paymentRate}%</p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="card p-5"
        >
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
              <Flower2 className="w-6 h-6 text-purple-600" />
            </div>
            <div>
              <p className="text-sm text-slate-500">ได้รับสิทธิประโยชน์</p>
              <p className="text-xl font-bold text-purple-600">{formatCurrency(data.summary.totalBenefitsAmount)}</p>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Main Content */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Left Column - Profile Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="space-y-6"
        >
          {/* Basic Info */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-primary-500" />
              ข้อมูลส่วนตัว
            </h3>
            <div className="space-y-4">
              <div className="flex items-center gap-3 p-3 bg-slate-50 rounded-xl">
                <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center">
                  <span className="text-2xl font-bold text-primary-600">
                    {(data.member.firstName || data.member.fullName || ' ').charAt(0)}
                  </span>
                </div>
                <div>
                  <p className="font-semibold text-slate-900">{data.member.fullName}</p>
                  <p className="text-sm text-slate-500">{data.member.memberType?.name}</p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-slate-50 rounded-lg">
                  <p className="text-xs text-slate-500">เลขบัตรประชาชน</p>
                  <p className="font-mono text-sm">{data.member.idCardNo || '-'}</p>
                </div>
                <div className="p-3 bg-slate-50 rounded-lg">
                  <p className="text-xs text-slate-500">วันที่สมัคร</p>
                  <p className="text-sm">{formatThaiDateShort(data.member.joinDate)}</p>
                </div>
              </div>

              {data.member.phone && (
                <div className="flex items-center gap-3 text-slate-600">
                  <Phone size={16} className="text-slate-400" />
                  <a href={`tel:${data.member.phone}`} className="text-primary-600 hover:underline">
                    {data.member.phone}
                  </a>
                </div>
              )}

              {data.member.address && (
                <div className="flex items-start gap-3 text-slate-600">
                  <MapPin size={16} className="text-slate-400 mt-1" />
                  <p className="text-sm">{data.member.address}</p>
                </div>
              )}

              <div className="flex items-center gap-3 text-slate-600">
                <Building2 size={16} className="text-slate-400" />
                <p className="text-sm">{data.member.school.name}</p>
              </div>

              {data.member.group && (
                <div className="flex items-center gap-3 text-slate-600">
                  <Users size={16} className="text-slate-400" />
                  <p className="text-sm">กลุ่ม: {data.member.group.name}</p>
                </div>
              )}
            </div>
          </div>

          {/* Beneficiaries */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <Users className="w-5 h-5 text-rose-500" />
              ผู้รับผลประโยชน์
            </h3>
            {data.beneficiaries.length > 0 ? (
              <div className="space-y-3">
                {data.beneficiaries.map((b, index) => (
                  <div key={b.id} className="flex items-center gap-3 p-3 bg-slate-50 rounded-xl">
                    <div className="w-8 h-8 bg-rose-100 rounded-full flex items-center justify-center text-rose-600 font-bold text-sm">
                      {b.priority}
                    </div>
                    <div className="flex-1">
                      <p className="font-medium text-slate-900">{b.fullName}</p>
                      <p className="text-xs text-slate-500">{b.relationship}</p>
                    </div>
                    {b.phone && (
                      <a href={`tel:${b.phone}`} className="text-xs text-primary-600">
                        {b.phone}
                      </a>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-center text-slate-400 py-4">ยังไม่มีข้อมูลผู้รับผลประโยชน์</p>
            )}
          </div>
        </motion.div>

        {/* Right Column - Charts & History */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="lg:col-span-2 space-y-6"
        >
          {/* Payment Stats */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <TrendingUp className="w-5 h-5 text-emerald-500" />
              ประวัติการชำระเงินสงเคราะห์
            </h3>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={contributionChartData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e2e8f0" />
                  <XAxis dataKey="name" tick={{ fontSize: 10 }} />
                  <YAxis tickFormatter={(value) => `${(value / 1000).toFixed(0)}k`} tick={{ fontSize: 11 }} />
                  <Tooltip formatter={(value: number) => formatCurrency(value)} />
                  <Bar dataKey="ยอดชำระ" fill="#e2e8f0" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="ชำระแล้ว" fill="#10b981" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Arrears Warning */}
          {data.summary.arrearsCount > 0 && (
            <div className="card p-6 bg-amber-50 border-amber-200">
              <h3 className="font-semibold text-amber-800 mb-3 flex items-center gap-2">
                <AlertCircle className="w-5 h-5" />
                ยอดค้างชำระ
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-amber-700">จำนวนงวดค้างชำระ</p>
                  <p className="text-2xl font-bold text-amber-800">{data.summary.arrearsCount} งวด</p>
                </div>
                <div>
                  <p className="text-sm text-amber-700">ยอดเงินค้างชำระ</p>
                  <p className="text-2xl font-bold text-amber-800">{formatCurrency(data.summary.arrearsAmount)}</p>
                </div>
              </div>
              {data.arrears.length > 0 && (
                <div className="mt-4 space-y-2">
                  {data.arrears.slice(0, 5).map((a: any) => (
                    <div key={a.id} className="flex justify-between text-sm p-2 bg-amber-100 rounded-lg">
                      <span>
                        {thaiMonths[a.period.month - 1]} {a.period.year + 543}
                      </span>
                      <span className="font-medium">{formatCurrency(a.totalAmount)}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Recent Contributions Table */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <FileText className="w-5 h-5 text-sky-500" />
              รายการชำระล่าสุด
            </h3>
            <div className="table-container">
              <table className="table">
                <thead>
                  <tr>
                    <th>งวด</th>
                    <th className="text-right">ยอดชำระ</th>
                    <th className="text-right">ชำระแล้ว</th>
                    <th>วันที่ชำระ</th>
                    <th>สถานะ</th>
                  </tr>
                </thead>
                <tbody>
                  {data.recentContributions.slice(0, 12).map((c) => (
                    <tr key={c.id}>
                      <td>
                        {thaiMonths[c.period.month - 1]} {c.period.year + 543}
                      </td>
                      <td className="text-right">{formatCurrency(c.totalAmount)}</td>
                      <td className="text-right font-medium text-emerald-600">
                        {formatCurrency(c.paidAmount)}
                      </td>
                      <td className="text-sm text-slate-500">
                        {c.paidDate ? formatThaiDateShort(c.paidDate) : '-'}
                      </td>
                      <td>
                        {parseFloat(c.paidAmount) > 0 ? (
                          <span className="badge-success flex items-center gap-1 w-fit">
                            <CheckCircle size={12} />
                            ชำระแล้ว
                          </span>
                        ) : c.isArrears ? (
                          <span className="badge-danger flex items-center gap-1 w-fit">
                            <AlertCircle size={12} />
                            ค้างชำระ
                          </span>
                        ) : (
                          <span className="badge-warning flex items-center gap-1 w-fit">
                            <Clock size={12} />
                            รอชำระ
                          </span>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Death Claims Benefits */}
          {data.deathClaims.length > 0 && (
            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Flower2 className="w-5 h-5 text-purple-500" />
                ประวัติการรับเงินสงเคราะห์
              </h3>
              <div className="space-y-3">
                {data.deathClaims.map((claim: any) => (
                  <div key={claim.id} className="p-4 bg-purple-50 rounded-xl">
                    <div className="flex justify-between items-start">
                      <div>
                        <p className="font-medium text-purple-900">{claim.claimNo}</p>
                        <p className="text-sm text-purple-700">
                          {claim.deceasedType === 'MEMBER'
                            ? 'ตัวสมาชิก'
                            : claim.deceasedType === 'PARENT'
                            ? 'บิดา/มารดา'
                            : claim.deceasedType === 'SPOUSE'
                            ? 'คู่สมรส'
                            : claim.deceasedType === 'CHILD'
                            ? 'บุตร/ธิดา'
                            : claim.claimType === 'PROTECTED_DEATH'
                            ? 'ญาติที่คุ้มครอง'
                            : 'สมาชิก'}
                          {claim.deceasedName && `: ${claim.deceasedName}`}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="text-lg font-bold text-purple-700">
                          {formatCurrency(claim.netToPay)}
                        </p>
                        {claim.payment && (
                          <p className="text-xs text-purple-500">
                            จ่ายเมื่อ {formatThaiDateShort(claim.payment.payDate)}
                          </p>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </motion.div>
      </div>
    </motion.div>
  );
}
