'use client';

import { useParams, useRouter } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Flower2, User, Calendar, Phone, DollarSign, CheckCircle, Printer, CreditCard } from 'lucide-react';
import Link from 'next/link';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api } from '@/lib/api';
import { formatThaiDate } from '@/components/ThaiDatePicker';

// ประเภทผู้เสียชีวิต
const deceasedTypeLabels: Record<string, string> = {
  MEMBER: 'ตัวสมาชิกเอง',
  PARENT: 'บิดา/มารดา',
  CHILD: 'บุตร/ธิดา',
};

interface DeathClaimDetail {
  id: string;
  claimNo: string;
  reportedDate: string;
  deathDate: string;
  causeOfDeath?: string;
  deceasedType: string;
  deceasedName?: string;
  relationshipNote?: string;
  mainBeneficiary: string;
  beneficiaryPhone?: string;
  welfareBaseAmount: number;
  paymentPercent: number;
  calculatedAmount: number;
  otherDeductions: number;
  netToPay: number;
  member: {
    id: string;
    memberNo: string;
    firstName: string;
    lastName: string;
    phone?: string;
    joinDate: string;
  };
  school: {
    id: string;
    name: string;
  };
  payment?: {
    id: string;
    payDate: string;
    amount: number;
    method: string;
    bankAccount?: {
      bankName: string;
      accountNo: string;
    };
  };
}

export default function DeathClaimDetailPage() {
  const params = useParams();
  const router = useRouter();
  const claimId = params.id as string;
  const queryClient = useQueryClient();

  const { data: claim, isLoading } = useQuery<DeathClaimDetail>({
    queryKey: ['death-claim', claimId],
    queryFn: async () => {
      const response = await api.get(`/death-claims/${claimId}`);
      return response.data;
    },
  });

  const payMutation = useMutation({
    mutationFn: () => api.post(`/death-claims/${claimId}/pay`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['death-claim', claimId] });
      queryClient.invalidateQueries({ queryKey: ['death-claims'] });
      showSuccess('บันทึกการจ่ายเงินสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
  };

  // ใช้ formatThaiDate จาก ThaiDatePicker component แสดงปี พ.ศ.
  const formatDate = formatThaiDate;

  const handlePay = () => {
    showConfirm(
      `ยืนยันการจ่ายเงินสงเคราะห์ ${formatCurrency(claim?.netToPay || 0)} ให้ ${claim?.mainBeneficiary}?`,
      () => payMutation.mutate(),
    );
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!claim) {
    return (
      <div className="text-center py-20">
        <p className="text-lg text-slate-500">ไม่พบข้อมูลการแจ้งเสียชีวิต</p>
        <Link href="/death-claims" className="btn-secondary mt-4">
          กลับไปรายการ
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
          <Link href="/death-claims" className="p-2 hover:bg-slate-100 rounded-lg">
            <ArrowLeft size={20} />
          </Link>
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl font-display font-bold text-slate-900">
                {claim.claimNo}
              </h1>
              {claim.payment ? (
                <span className="badge-success flex items-center gap-1">
                  <CheckCircle size={14} />
                  จ่ายแล้ว
                </span>
              ) : (
                <span className="badge-warning">รอจ่าย</span>
              )}
            </div>
            <p className="text-slate-500 mt-1">
              {claim.member.firstName} {claim.member.lastName}
            </p>
          </div>
        </div>

        <div className="flex gap-2">
          <button className="btn-secondary">
            <Printer size={18} />
            พิมพ์
          </button>
          {!claim.payment && (
            <button
              onClick={handlePay}
              className="btn-primary"
              disabled={payMutation.isPending}
            >
              {payMutation.isPending ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <CreditCard size={18} />
                  บันทึกการจ่ายเงิน
                </>
              )}
            </button>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Main Info */}
        <div className="lg:col-span-2 space-y-6">
          {/* Member Info */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-primary-500" />
              ข้อมูลสมาชิก
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-slate-500">ชื่อ-นามสกุล</p>
                <p className="font-medium">{claim.member.firstName} {claim.member.lastName}</p>
              </div>
              <div>
                <p className="text-sm text-slate-500">เลขสมาชิก</p>
                <p className="font-mono">{claim.member.memberNo}</p>
              </div>
              <div>
                <p className="text-sm text-slate-500">โรงเรียน</p>
                <p className="font-medium">{claim.school.name}</p>
              </div>
              <div>
                <p className="text-sm text-slate-500">วันที่สมัคร</p>
                <p>{formatDate(claim.member.joinDate)}</p>
              </div>
            </div>
          </div>

          {/* Death Info */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <Flower2 className="w-5 h-5 text-rose-500" />
              ข้อมูลการเสียชีวิต
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div className="col-span-2">
                <p className="text-sm text-slate-500">ประเภทผู้เสียชีวิต</p>
                <span className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${
                  claim.deceasedType === 'MEMBER' 
                    ? 'bg-rose-100 text-rose-700' 
                    : 'bg-amber-100 text-amber-700'
                }`}>
                  {deceasedTypeLabels[claim.deceasedType]} ({claim.paymentPercent}%)
                </span>
              </div>
              {claim.deceasedType !== 'MEMBER' && claim.deceasedName && (
                <>
                  <div>
                    <p className="text-sm text-slate-500">ชื่อผู้เสียชีวิต</p>
                    <p className="font-medium">{claim.deceasedName}</p>
                  </div>
                  {claim.relationshipNote && (
                    <div>
                      <p className="text-sm text-slate-500">ความสัมพันธ์</p>
                      <p>{claim.relationshipNote}</p>
                    </div>
                  )}
                </>
              )}
              <div>
                <p className="text-sm text-slate-500">วันที่รายงาน</p>
                <p>{formatDate(claim.reportedDate)}</p>
              </div>
              <div>
                <p className="text-sm text-slate-500">วันที่เสียชีวิต</p>
                <p>{formatDate(claim.deathDate)}</p>
              </div>
              {claim.causeOfDeath && (
                <div className="col-span-2">
                  <p className="text-sm text-slate-500">สาเหตุการเสียชีวิต</p>
                  <p>{claim.causeOfDeath}</p>
                </div>
              )}
            </div>
          </div>

          {/* Beneficiary Info */}
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <User className="w-5 h-5 text-emerald-500" />
              ผู้รับผลประโยชน์
            </h3>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-slate-500">ชื่อ-นามสกุล</p>
                <p className="font-medium">{claim.mainBeneficiary}</p>
              </div>
              {claim.beneficiaryPhone && (
                <div>
                  <p className="text-sm text-slate-500">เบอร์โทรศัพท์</p>
                  <p className="flex items-center gap-1">
                    <Phone size={14} className="text-slate-400" />
                    <a href={`tel:${claim.beneficiaryPhone}`} className="text-primary-600 hover:text-primary-700">
                      {claim.beneficiaryPhone}
                    </a>
                  </p>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Payment Summary */}
        <div className="space-y-6">
          <div className="card p-6">
            <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
              <DollarSign className="w-5 h-5 text-sky-500" />
              สรุปเงินสงเคราะห์
            </h3>
            <div className="space-y-3">
              <div className="flex justify-between">
                <span className="text-slate-500">อัตราพื้นฐาน</span>
                <span className="font-medium">{formatCurrency(claim.welfareBaseAmount)}</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">เปอร์เซ็นต์การจ่าย</span>
                <span className="font-medium">{claim.paymentPercent}%</span>
              </div>
              <div className="flex justify-between">
                <span className="text-slate-500">ยอดหลังคำนวณ</span>
                <span className="font-medium">{formatCurrency(claim.calculatedAmount)}</span>
              </div>
              <hr className="my-2" />
              {claim.otherDeductions > 0 && (
                <div className="flex justify-between text-red-600">
                  <span>หัก: รายการอื่นๆ</span>
                  <span>-{formatCurrency(claim.otherDeductions)}</span>
                </div>
              )}
              <hr className="my-2" />
              <div className="flex justify-between text-lg font-bold">
                <span>ยอดสุทธิ</span>
                <span className="text-primary-600">{formatCurrency(claim.netToPay)}</span>
              </div>
            </div>
          </div>

          {/* Payment Status */}
          {claim.payment && (
            <div className="card p-6 bg-emerald-50 border-emerald-200">
              <h3 className="font-semibold text-emerald-800 mb-4 flex items-center gap-2">
                <CheckCircle className="w-5 h-5" />
                ข้อมูลการจ่ายเงิน
              </h3>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-emerald-700">วันที่จ่าย</span>
                  <span className="font-medium text-emerald-900">{formatDate(claim.payment.payDate)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-emerald-700">จำนวนเงิน</span>
                  <span className="font-medium text-emerald-900">{formatCurrency(claim.payment.amount)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-emerald-700">ช่องทาง</span>
                  <span className="font-medium text-emerald-900">{claim.payment.method}</span>
                </div>
                {claim.payment.bankAccount && (
                  <div className="flex justify-between">
                    <span className="text-emerald-700">บัญชี</span>
                    <span className="font-medium text-emerald-900">
                      {claim.payment.bankAccount.bankName}
                    </span>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </motion.div>
  );
}

