'use client';

import { useRef, useState } from 'react';
import { useParams } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  ArrowLeft,
  Flower2,
  User,
  Phone,
  DollarSign,
  CheckCircle,
  Printer,
  CreditCard,
  ClipboardList,
  CalendarClock,
  AlertTriangle,
  ClipboardCheck,
} from 'lucide-react';
import Link from 'next/link';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import {
  api,
  DEATH_CLAIM_STATUS_LABELS,
  DEATH_COLLECTION_CHANNEL_LABELS,
  type DeathClaim,
  type DocumentChecklistItem,
} from '@/lib/api';
import { formatThaiDate } from '@/components/ThaiDatePicker';
import { DeathClaimPrint } from '@/components/DeathClaimPrint';
import { isDeadlineOverdue, statusBadgeClass } from '@/lib/death-claim-workflow';

export default function DeathClaimDetailPage() {
  const params = useParams();
  const claimId = params.id as string;
  const queryClient = useQueryClient();
  const printRef = useRef<HTMLDivElement>(null);
  const [collectedInput, setCollectedInput] = useState<string>('');

  const { data: claim, isLoading } = useQuery<DeathClaim>({
    queryKey: ['death-claim', claimId],
    queryFn: async () => {
      const response = await api.get(`/death-claims/${claimId}`);
      return response.data;
    },
  });

  const workflowMutation = useMutation({
    mutationFn: (payload: { collectedAmount?: number; startCollecting?: boolean }) =>
      api.patch(`/death-claims/${claimId}/workflow`, payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['death-claim', claimId] });
      queryClient.invalidateQueries({ queryKey: ['death-claims'] });
      queryClient.invalidateQueries({ queryKey: ['death-claims-stats'] });
      showSuccess('อัปเดตสถานะการเก็บเงินสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const documentsMutation = useMutation({
    mutationFn: (items: { key: string; checked: boolean }[]) =>
      api.patch(`/death-claims/${claimId}/documents`, { items }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['death-claim', claimId] });
      queryClient.invalidateQueries({ queryKey: ['death-claims'] });
      showSuccess('อัปเดตเอกสารสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const approveMutation = useMutation({
    mutationFn: () => api.post(`/death-claims/${claimId}/approve`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['death-claim', claimId] });
      queryClient.invalidateQueries({ queryKey: ['death-claims'] });
      showSuccess('อนุมัติเบิกเงินสำเร็จ (ข้อ 13.6)');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const payMutation = useMutation({
    mutationFn: () =>
      api.post(`/death-claims/${claimId}/payment`, {
        payDate: new Date().toISOString().split('T')[0],
        method: 'cash',
        amount: claim?.netToPay,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['death-claim', claimId] });
      queryClient.invalidateQueries({ queryKey: ['death-claims'] });
      showSuccess('บันทึกการจ่ายเงินสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB', minimumFractionDigits: 0 }).format(amount);

  const handlePrint = () => window.print();

  const handleApprove = () => {
    showConfirm(
      `ยืนยันอนุมัติเบิกเงินสงเคราะห์ ${formatCurrency(claim?.netToPay || 0)} ด้วยลายเซ็นอิเล็กทรอนิกส์?`,
      () => approveMutation.mutate(),
    );
  };

  const handlePay = () => {
    showConfirm(
      `ยืนยันการจ่ายเงินสงเคราะห์ ${formatCurrency(claim?.netToPay || 0)} ให้ ${claim?.mainBeneficiary}?`,
      () => payMutation.mutate(),
    );
  };

  const handleStartCollection = () => {
    workflowMutation.mutate({ startCollecting: true });
  };

  const handleSaveCollected = () => {
    const amount = Number(collectedInput);
    if (Number.isNaN(amount) || amount < 0) {
      showError('กรุณากรอกยอดเก็บเงินที่ถูกต้อง');
      return;
    }
    workflowMutation.mutate({ collectedAmount: amount });
  };

  const handleChecklistToggle = (item: DocumentChecklistItem) => {
    if (!claim?.documentChecklist) return;
    const items = claim.documentChecklist.map((i) => ({
      key: i.key,
      checked: i.key === item.key ? !i.checked : i.checked,
    }));
    documentsMutation.mutate(items);
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
        <Link href="/death-claims" className="btn-secondary mt-4">กลับไปรายการ</Link>
      </div>
    );
  }

  const memberName = claim.member.associationMember
    ? `${claim.member.associationMember.firstName} ${claim.member.associationMember.lastName}`
    : '';

  const isPaid = !!claim.payment || claim.status === 'PAID';
  const canApprove = claim.status === 'READY_TO_PAY' && !isPaid && !claim.approvedAt;
  const canPay = claim.status === 'READY_TO_PAY' && !isPaid && !!claim.approvedAt;
  const collectedAmount = Number(claim.collectedAmount ?? 0);
  const targetAmount = Number(claim.totalContribution ?? 0);
  const collectionProgress = targetAmount > 0 ? Math.min(100, (collectedAmount / targetAmount) * 100) : 0;

  const deadlines = [
    {
      label: 'แจ้ง สพป. (สามัญ)',
      date: claim.notifyAuthorityDeadline,
      overdue: isDeadlineOverdue(claim.notifyAuthorityDeadline, collectedAmount >= targetAmount),
      show: !!claim.notifyAuthorityDeadline,
    },
    {
      label: 'ครบกำหนดเก็บเงิน',
      date: claim.collectionDeadline,
      overdue: isDeadlineOverdue(claim.collectionDeadline, collectedAmount >= targetAmount),
      show: true,
    },
    {
      label: 'ครบกำหนดเอกสาร (ข้อ 17)',
      date: claim.documentDeadline,
      overdue: isDeadlineOverdue(claim.documentDeadline, claim.documentsComplete),
      show: true,
    },
    {
      label: 'ครบกำหนดจ่ายเงิน',
      date: claim.paymentDeadline,
      overdue: isDeadlineOverdue(claim.paymentDeadline, isPaid),
      show: true,
    },
  ].filter((d) => d.show && d.date);

  return (
    <>
      <motion.div
        ref={printRef}
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="space-y-6 print:hidden"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Link href="/death-claims" className="p-2 hover:bg-slate-100 rounded-lg">
              <ArrowLeft size={20} />
            </Link>
            <div>
              <div className="flex items-center gap-3 flex-wrap">
                <h1 className="text-2xl font-display font-bold text-slate-900">{claim.claimNo}</h1>
                <span className={statusBadgeClass(claim.status, !!claim.payment)}>
                  {isPaid ? 'จ่ายแล้ว' : DEATH_CLAIM_STATUS_LABELS[claim.status || 'REPORTED']}
                </span>
              </div>
              <p className="text-slate-500 mt-1">{memberName}</p>
            </div>
          </div>
          <div className="flex gap-2">
            <button type="button" onClick={handlePrint} className="btn-secondary">
              <Printer size={18} />พิมพ์
            </button>
            {canApprove && (
              <button type="button" onClick={handleApprove} className="btn-secondary" disabled={approveMutation.isPending}>
                {approveMutation.isPending ? (
                  <div className="w-5 h-5 border-2 border-slate-300 border-t-slate-600 rounded-full animate-spin" />
                ) : (
                  <><ClipboardCheck size={18} />อนุมัติเบิกเงิน</>
                )}
              </button>
            )}
            {canPay && (
              <button type="button" onClick={handlePay} className="btn-primary" disabled={payMutation.isPending}>
                {payMutation.isPending ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <><CreditCard size={18} />บันทึกการจ่ายเงิน</>
                )}
              </button>
            )}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <CalendarClock className="w-5 h-5 text-amber-500" />
                กำหนดเวลาและช่องทางเก็บเงิน
              </h3>
              <div className="mb-4">
                <p className="text-sm text-slate-500">ช่องทางเก็บเงิน</p>
                <p className="font-medium">
                  {claim.collectionChannel
                    ? DEATH_COLLECTION_CHANNEL_LABELS[claim.collectionChannel]
                    : '-'}
                </p>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {deadlines.map((d) => (
                  <div
                    key={d.label}
                    className={`rounded-lg border p-3 ${d.overdue ? 'border-red-200 bg-red-50' : 'border-slate-200'}`}
                  >
                    <div className="flex items-center gap-2">
                      {d.overdue && <AlertTriangle size={14} className="text-red-500" />}
                      <p className="text-sm text-slate-600">{d.label}</p>
                    </div>
                    <p className={`font-medium mt-1 ${d.overdue ? 'text-red-700' : ''}`}>
                      {formatThaiDate(d.date!)}
                      {d.overdue && <span className="text-xs ml-2 text-red-600">เลยกำหนด</span>}
                    </p>
                  </div>
                ))}
              </div>
            </div>

            {!isPaid && (
              <div className="card p-6">
                <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-sky-500" />
                  การเก็บเงินสงเคราะห์
                </h3>
                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between text-sm mb-2">
                      <span>ยอดเก็บแล้ว {formatCurrency(collectedAmount)}</span>
                      <span>เป้าหมาย {formatCurrency(targetAmount)}</span>
                    </div>
                    <div className="h-2 bg-slate-100 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-sky-500 transition-all"
                        style={{ width: `${collectionProgress}%` }}
                      />
                    </div>
                  </div>

                  {claim.status === 'REPORTED' && (
                    <button
                      type="button"
                      onClick={handleStartCollection}
                      className="btn-secondary"
                      disabled={workflowMutation.isPending}
                    >
                      เริ่มดำเนินการเก็บเงิน
                    </button>
                  )}

                  {claim.status !== 'REPORTED' && (
                    <div className="flex gap-2 items-end">
                      <div className="flex-1">
                        <label className="text-sm text-slate-500">บันทึกยอดเก็บเงิน (บาท)</label>
                        <input
                          type="number"
                          className="input mt-1"
                          placeholder={String(collectedAmount || targetAmount)}
                          value={collectedInput}
                          onChange={(e) => setCollectedInput(e.target.value)}
                          min={0}
                        />
                      </div>
                      <button
                        type="button"
                        onClick={handleSaveCollected}
                        className="btn-primary"
                        disabled={workflowMutation.isPending}
                      >
                        บันทึกยอด
                      </button>
                    </div>
                  )}
                </div>
              </div>
            )}

            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <ClipboardList className="w-5 h-5 text-violet-500" />
                เอกสารประกอบ (ข้อ 17)
                {claim.documentsComplete && (
                  <span className="badge-success text-xs ml-2">ครบแล้ว</span>
                )}
              </h3>
              <div className="space-y-2">
                {(claim.documentChecklist ?? []).map((item) => (
                  <label
                    key={item.key}
                    className={`flex items-center gap-3 p-3 rounded-lg border ${
                      item.checked ? 'border-emerald-200 bg-emerald-50' : 'border-slate-200'
                    } ${isPaid ? 'pointer-events-none opacity-70' : 'cursor-pointer'}`}
                  >
                    <input
                      type="checkbox"
                      checked={item.checked}
                      disabled={isPaid || documentsMutation.isPending}
                      onChange={() => handleChecklistToggle(item)}
                      className="w-4 h-4"
                    />
                    <span className="text-sm">
                      {item.label}
                      {item.required && <span className="text-red-500 ml-1">*</span>}
                    </span>
                  </label>
                ))}
              </div>
            </div>

            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <User className="w-5 h-5 text-primary-500" />ข้อมูลสมาชิก
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div><p className="text-sm text-slate-500">ชื่อ-นามสกุล</p><p className="font-medium">{memberName}</p></div>
                <div><p className="text-sm text-slate-500">เลขสมาชิก</p><p className="font-mono">{claim.member.memberNo}</p></div>
                <div><p className="text-sm text-slate-500">โรงเรียน</p><p className="font-medium">{claim.school.name}</p></div>
              </div>
            </div>

            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Flower2 className="w-5 h-5 text-rose-500" />ข้อมูลการเสียชีวิต
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-slate-500">ประเภทผู้เสียชีวิต</p>
                  <p className="font-medium">
                    {claim.deceasedType === 'MEMBER'
                      ? 'ตัวสมาชิก'
                      : claim.deceasedType === 'PARENT'
                        ? 'บิดา/มารดาที่คุ้มครอง'
                        : claim.deceasedType === 'CHILD'
                          ? 'บุตร/ธิดาที่คุ้มครอง'
                          : claim.deceasedType === 'SPOUSE'
                            ? 'คู่สมรสที่คุ้มครอง'
                            : claim.claimType === 'PROTECTED_DEATH'
                              ? 'ญาติที่คุ้มครอง'
                              : 'สมาชิก'}
                  </p>
                </div>
                {claim.deceasedName && (
                  <div><p className="text-sm text-slate-500">ชื่อผู้เสียชีวิต</p><p className="font-medium">{claim.deceasedName}</p></div>
                )}
                <div><p className="text-sm text-slate-500">วันที่รายงาน</p><p>{formatThaiDate(claim.reportedDate)}</p></div>
                <div><p className="text-sm text-slate-500">วันที่เสียชีวิต</p><p>{formatThaiDate(claim.deathDate)}</p></div>
              </div>
            </div>

            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <User className="w-5 h-5 text-emerald-500" />
                {claim.claimType === 'PROTECTED_DEATH' ? 'ผู้รับเงินสงเคราะห์ (สมาชิก)' : 'ผู้รับผลประโยชน์'}
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div><p className="text-sm text-slate-500">ชื่อ-นามสกุล</p><p className="font-medium">{claim.mainBeneficiary}</p></div>
                {claim.beneficiaryPhone && (
                  <div>
                    <p className="text-sm text-slate-500">เบอร์โทรศัพท์</p>
                    <p className="flex items-center gap-1">
                      <Phone size={14} className="text-slate-400" />
                      <a href={`tel:${claim.beneficiaryPhone}`} className="text-primary-600">{claim.beneficiaryPhone}</a>
                    </p>
                  </div>
                )}
              </div>
            </div>
          </div>

          <div className="space-y-6">
            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <DollarSign className="w-5 h-5 text-sky-500" />สรุปเงินสงเคราะห์
              </h3>
              <div className="space-y-3 text-sm">
                <div className="flex justify-between"><span className="text-slate-500">ยอดเก็บรวม</span><span>{formatCurrency(targetAmount)}</span></div>
                <div className="flex justify-between"><span className="text-slate-500">เข้ากองทุน (10%)</span><span>{formatCurrency(Number(claim.associationSupport ?? 0))}</span></div>
                <hr />
                <div className="flex justify-between text-lg font-bold">
                  <span>ยอดสุทธิจ่าย</span>
                  <span className="text-primary-600">{formatCurrency(Number(claim.netToPay))}</span>
                </div>
              </div>
            </div>

            {claim.approvedAt && (
              <div className="card p-6 bg-violet-50 border-violet-200">
                <h3 className="font-semibold text-violet-800 mb-4 flex items-center gap-2">
                  <ClipboardCheck className="w-5 h-5" />การอนุมัติเบิก (ข้อ 13.6)
                </h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between"><span className="text-violet-700">ผู้อนุมัติ</span><span>{claim.approverName}</span></div>
                  <div className="flex justify-between"><span className="text-violet-700">วันที่อนุมัติ</span><span>{formatThaiDate(claim.approvedAt)}</span></div>
                  {claim.approverSignature && (
                    <div className="mt-2 p-2 bg-white rounded border flex justify-center">
                      <img src={claim.approverSignature} alt="ลายเซ็นผู้อนุมัติ" className="max-h-16 object-contain" />
                    </div>
                  )}
                </div>
              </div>
            )}

            {claim.payment && (
              <div className="card p-6 bg-emerald-50 border-emerald-200">
                <h3 className="font-semibold text-emerald-800 mb-4 flex items-center gap-2">
                  <CheckCircle className="w-5 h-5" />ข้อมูลการจ่ายเงิน
                </h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between"><span className="text-emerald-700">วันที่จ่าย</span><span>{formatThaiDate(claim.payment.payDate)}</span></div>
                  <div className="flex justify-between"><span className="text-emerald-700">จำนวนเงิน</span><span>{formatCurrency(Number(claim.payment.amount))}</span></div>
                  <div className="flex justify-between"><span className="text-emerald-700">ช่องทาง</span><span>{claim.payment.method}</span></div>
                </div>
              </div>
            )}
          </div>
        </div>
      </motion.div>

      <DeathClaimPrint claim={claim} />
    </>
  );
}