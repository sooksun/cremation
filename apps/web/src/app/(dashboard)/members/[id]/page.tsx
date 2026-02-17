'use client';

import { useParams, useRouter } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Edit, User, Phone, Calendar, MapPin, Building2, Users, Flower2, AlertCircle, BarChart3 } from 'lucide-react';
import Link from 'next/link';
import { showSuccess, showError } from '@/lib/toast';
import { api, type Member } from '@/lib/api';

const statusConfig = {
  ACTIVE: { label: 'ปกติ', class: 'badge-success' },
  RESIGNED: { label: 'ลาออก', class: 'badge-neutral' },
  DECEASED: { label: 'เสียชีวิต', class: 'badge-danger' },
  ARREARS: { label: 'ค้างชำระ', class: 'badge-warning' },
  SUSPENDED: { label: 'พักสมาชิก', class: 'badge-info' },
};

export default function MemberDetailPage() {
  const params = useParams();
  const router = useRouter();
  const memberId = params.id as string;
  const queryClient = useQueryClient();

  const { data: member, isLoading } = useQuery<Member & { beneficiaries?: any[]; contributions?: any[]; deathClaims?: any[] }>({
    queryKey: ['member', memberId],
    queryFn: async () => {
      const response = await api.get(`/members/${memberId}`);
      return response.data;
    },
  });

  const formatDate = (dateString: string | null | undefined) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('th-TH', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
    });
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!member) {
    return (
      <div className="text-center py-20">
        <p className="text-lg text-slate-500">ไม่พบข้อมูลสมาชิก</p>
        <Link href="/members" className="btn-secondary mt-4">
          กลับไปรายการสมาชิก
        </Link>
      </div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Link href="/members" className="p-2 hover:bg-slate-100 rounded-lg">
            <ArrowLeft size={20} />
          </Link>
          <div>
            <h1 className="text-2xl font-display font-bold text-slate-900">
              {member.firstName} {member.lastName}
            </h1>
            <p className="text-slate-500 mt-1">
              เลขสมาชิก: {member.memberNo}
            </p>
          </div>
        </div>
        <div className="flex gap-2">
          <Link href={`/members/${memberId}/profile`} className="btn-secondary">
            <BarChart3 size={18} />
            Dashboard รายบุคคล
          </Link>
          <Link href={`/members/${memberId}/edit`} className="btn-primary">
            <Edit size={18} />
            แก้ไขข้อมูล
          </Link>
        </div>
      </div>

      {/* Status Badge */}
      <div className="flex items-center gap-3">
        <span className={statusConfig[member.status].class}>
          {statusConfig[member.status].label}
        </span>
        {member.status === 'DECEASED' && member.deathDate && (
          <span className="text-sm text-slate-500">
            เสียชีวิตเมื่อ {formatDate(member.deathDate)}
          </span>
        )}
        {member.status === 'RESIGNED' && member.resignDate && (
          <span className="text-sm text-slate-500">
            ลาออกเมื่อ {formatDate(member.resignDate)}
          </span>
        )}
      </div>

      {/* Main Info Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Personal Info */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <User className="w-5 h-5 text-primary-500" />
            ข้อมูลส่วนตัว
          </h3>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span className="text-slate-500">เลขสมาชิก</span>
              <span className="font-mono font-medium">{member.memberNo}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">ชื่อ-นามสกุล</span>
              <span className="font-medium">{member.firstName} {member.lastName}</span>
            </div>
            {member.idCardNo && (
              <div className="flex justify-between">
                <span className="text-slate-500">เลขบัตรประชาชน</span>
                <span className="font-mono text-sm">{member.idCardNo}</span>
              </div>
            )}
            {member.birthDate && (
              <div className="flex justify-between">
                <span className="text-slate-500">วันเกิด</span>
                <span>{formatDate(member.birthDate)}</span>
              </div>
            )}
            {member.phone && (
              <div className="flex justify-between items-center">
                <span className="text-slate-500 flex items-center gap-1">
                  <Phone size={14} />
                  โทรศัพท์
                </span>
                <a href={`tel:${member.phone}`} className="text-primary-600 hover:text-primary-700">
                  {member.phone}
                </a>
              </div>
            )}
            {member.address && (
              <div className="flex items-start justify-between">
                <span className="text-slate-500 flex items-center gap-1">
                  <MapPin size={14} />
                  ที่อยู่
                </span>
                <span className="text-right max-w-xs">{member.address}</span>
              </div>
            )}
            <div className="flex justify-between">
              <span className="text-slate-500 flex items-center gap-1">
                <Calendar size={14} />
                วันที่สมัคร
              </span>
              <span>{formatDate(member.joinDate)}</span>
            </div>
          </div>
        </div>

        {/* Organization Info */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Building2 className="w-5 h-5 text-primary-500" />
            ข้อมูลองค์กร
          </h3>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span className="text-slate-500">โรงเรียน</span>
              <span className="font-medium">{member.school.name}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-slate-500">ประเภทสมาชิก</span>
              <span>{member.memberType.name}</span>
            </div>
            {member.group && (
              <div className="flex justify-between">
                <span className="text-slate-500">กลุ่ม</span>
                <span>{member.group.name}</span>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Beneficiaries */}
      {member.beneficiaries && member.beneficiaries.length > 0 && (
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Users className="w-5 h-5 text-primary-500" />
            ผู้รับผลประโยชน์ ({member.beneficiaries.length} คน)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {member.beneficiaries.map((beneficiary, index) => (
              <div key={beneficiary.id} className="p-4 bg-slate-50 rounded-xl">
                <div className="flex items-center gap-2 mb-2">
                  <div className="w-6 h-6 bg-primary-100 rounded-full flex items-center justify-center text-primary-700 text-xs font-semibold">
                    {beneficiary.priority || index + 1}
                  </div>
                  <span className="font-medium">{beneficiary.fullName}</span>
                </div>
                <p className="text-sm text-slate-500 mb-1">{beneficiary.relationship}</p>
                {beneficiary.phone && (
                  <a
                    href={`tel:${beneficiary.phone}`}
                    className="text-sm text-primary-600 hover:text-primary-700 flex items-center gap-1"
                  >
                    <Phone size={12} />
                    {beneficiary.phone}
                  </a>
                )}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Recent Contributions */}
      {member.contributions && member.contributions.length > 0 && (
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ประวัติการชำระเงินสงเคราะห์ (12 เดือนล่าสุด)</h3>
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>งวด</th>
                  <th className="text-right">ยอดที่ต้องชำระ</th>
                  <th className="text-right">ชำระแล้ว</th>
                  <th>วันที่ชำระ</th>
                  <th>สถานะ</th>
                </tr>
              </thead>
              <tbody>
                {member.contributions.map((contrib: any) => (
                  <tr key={contrib.id}>
                    <td>
                      {contrib.period.year + 543}/{String(contrib.period.month).padStart(2, '0')}
                    </td>
                    <td className="text-right">{formatCurrency(contrib.totalAmount)}</td>
                    <td className="text-right font-medium text-emerald-600">
                      {formatCurrency(contrib.paidAmount)}
                    </td>
                    <td>{contrib.paidDate ? formatDate(contrib.paidDate) : '-'}</td>
                    <td>
                      {Number(contrib.paidAmount) > 0 ? (
                        <span className="badge-success">ชำระแล้ว</span>
                      ) : contrib.isArrears ? (
                        <span className="badge-danger">ค้างชำระ</span>
                      ) : (
                        <span className="badge-warning">รอชำระ</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Death Claims */}
      {member.deathClaims && member.deathClaims.length > 0 && (
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
            <Flower2 className="w-5 h-5 text-rose-500" />
            การแจ้งเสียชีวิต
          </h3>
          <div className="space-y-3">
            {member.deathClaims.map((claim: any) => (
              <div key={claim.id} className="p-4 bg-rose-50 rounded-xl border border-rose-100">
                <div className="flex items-center justify-between mb-2">
                  <span className="font-mono text-sm text-slate-500">{claim.claimNo}</span>
                  <span className="font-semibold text-rose-600">
                    {formatCurrency(claim.netToPay)}
                  </span>
                </div>
                <p className="text-sm text-slate-600">
                  เสียชีวิตเมื่อ {formatDate(claim.deathDate)}
                </p>
                <p className="text-sm text-slate-500 mt-1">
                  ผู้รับผลประโยชน์: {claim.mainBeneficiary}
                </p>
                {claim.payment ? (
                  <span className="badge-success mt-2">จ่ายแล้ว</span>
                ) : (
                  <span className="badge-warning mt-2">รอจ่าย</span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}
    </motion.div>
  );
}


