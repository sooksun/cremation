'use client';

import { useMemo } from 'react';
import { useParams } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Calendar, Users, DollarSign, CheckCircle, AlertCircle, Building2, Banknote } from 'lucide-react';
import Link from 'next/link';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api, type ContributionSettings, periodTotalPerPerson } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { canSelectAllSchools } from '@/lib/school-scope';

interface Contribution {
  id: string;
  welfareAmount: number;
  serviceAmount: number;
  totalAmount: number;
  paidAmount: number;
  paidDate?: string;
  isArrears: boolean;
  member: {
    id: string;
    memberNo: string;
    firstName?: string;
    lastName?: string;
    phone?: string;
    group?: { name: string };
    associationMember?: {
      firstName: string;
      lastName: string;
      phone?: string;
    };
  };
  school: { id: string; name: string; code?: string };
}

interface SchoolSummaryRow {
  schoolId: string;
  schoolName: string;
  schoolCode: string;
  totalMembers: number;
  paidMembers: number;
  unpaidMembers: number;
  totalAmount: number;
  paidAmount: number;
}

interface SchoolSummaryResponse {
  schools: SchoolSummaryRow[];
  totals: {
    totalMembers: number;
    paidMembers: number;
    unpaidMembers: number;
    totalAmount: number;
    paidAmount: number;
  };
}

interface PayAllResponse {
  message: string;
  batch: {
    total: number;
    success: number;
    failed: number;
    results?: Array<{ success: boolean; error?: string }>;
  };
  newlyPaidBySchool: Array<{
    schoolId: string;
    schoolName: string;
    schoolCode: string;
    paidCount: number;
    paidAmount: number;
  }>;
  periodSummaryBySchool: SchoolSummaryResponse;
}

interface Period {
  id: string;
  year: number;
  month: number;
  welfareRate: number;
  serviceFee: number;
  isClosed: boolean;
}

interface Summary {
  totalContributions: number;
  paidContributions: number;
  unpaidContributions: number;
  totalAmount: number;
  paidAmount: number;
  unpaidAmount: number;
}

const monthNames = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
];

export default function PeriodDetailPage() {
  const params = useParams();
  const periodId = params.id as string;
  const queryClient = useQueryClient();
  const { user, selectedSchoolId } = useAuthStore();
  const scopedSchoolId = canSelectAllSchools(user?.role)
    ? (selectedSchoolId ?? undefined)
    : user?.schoolId;
  const schoolQuery = scopedSchoolId ? `?schoolId=${scopedSchoolId}` : '';

  const { data: period } = useQuery<Period>({
    queryKey: ['period', periodId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}`);
      return response.data;
    },
  });

  const { data: contributions, isLoading } = useQuery<Contribution[]>({
    queryKey: ['period-contributions', periodId, scopedSchoolId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}/contributions${schoolQuery}`);
      return response.data;
    },
  });

  const { data: summary } = useQuery<Summary>({
    queryKey: ['period-summary', periodId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}/summary`);
      return response.data;
    },
  });

  const { data: settings } = useQuery<ContributionSettings>({
    queryKey: ['contribution-settings'],
    queryFn: async () => {
      const response = await api.get('/contributions/settings');
      return response.data;
    },
  });

  const serviceFeeEnabled = settings?.serviceFeeEnabled ?? false;

  const { data: schoolSummary } = useQuery<SchoolSummaryResponse>({
    queryKey: ['period-school-summary', periodId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}/summary-by-school`);
      return response.data;
    },
    enabled: !!periodId,
  });

  const unpaidCount = useMemo(
    () => contributions?.filter((c) => Number(c.paidAmount) === 0).length ?? 0,
    [contributions],
  );

  const memberName = (contrib: Contribution) => {
    const first = contrib.member.firstName ?? contrib.member.associationMember?.firstName ?? '';
    const last = contrib.member.lastName ?? contrib.member.associationMember?.lastName ?? '';
    return `${first} ${last}`.trim() || '-';
  };

  const payAllMutation = useMutation({
    mutationFn: () =>
      api.post<PayAllResponse>(`/contributions/periods/${periodId}/pay-all`, undefined, {
        timeout: 300000,
      }),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['period-contributions', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-summary', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-school-summary', periodId] });
      const { batch, newlyPaidBySchool } = res.data;
      const schoolLines = newlyPaidBySchool
        .map((s) => `${s.schoolName} ${s.paidCount} คน`)
        .join(', ');

      if (batch.failed > 0) {
        const sampleError = res.data.batch.results?.find((r) => !r.success)?.error;
        showError(
          `บันทึกสำเร็จ ${batch.success} รายการ ล้มเหลว ${batch.failed} รายการ${
            sampleError ? ` — ${sampleError}` : ''
          }`,
        );
        return;
      }

      showSuccess(
        `${res.data.message}${schoolLines ? ` (${schoolLines})` : ''}`,
      );
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const arrearsNoticeMutation = useMutation({
    mutationFn: () => api.post(`/contributions/periods/${periodId}/send-arrears-notice`),
    onSuccess: (res) => {
      queryClient.invalidateQueries({ queryKey: ['period-contributions', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-summary', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-school-summary', periodId] });
      showSuccess(res.data.message || 'แจ้งเตือนค้างชำระสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const paymentMutation = useMutation({
    mutationFn: ({ id, amount }: { id: string; amount: number }) =>
      api.patch(`/contributions/${id}/payment`, {
        amount,
        paidDate: new Date().toISOString(),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['period-contributions', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-summary', periodId] });
      queryClient.invalidateQueries({ queryKey: ['period-school-summary', periodId] });
      showSuccess('บันทึกการชำระเงินสำเร็จ');
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

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('th-TH', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
    });
  };

  const handlePayment = (contribution: Contribution) => {
    showConfirm(
      `ยืนยันการรับชำระเงิน ${formatCurrency(contribution.totalAmount)} จาก ${memberName(contribution)}?`,
      () => paymentMutation.mutate({ id: contribution.id, amount: contribution.totalAmount }),
    );
  };

  const handlePayAll = () => {
    if (unpaidCount === 0) {
      showError('ไม่มีรายการที่ยังไม่ชำระ');
      return;
    }
    showConfirm(
      `บันทึกการชำระเงินสำหรับสมาชิกที่ยังไม่ชำระทั้งหมด ${unpaidCount} คนในงวดนี้?`,
      () => payAllMutation.mutate(),
    );
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link href="/contributions/periods" className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            งวด {period && `${monthNames[period.month - 1]} ${period.year + 543}`}
          </h1>
          <p className="text-slate-500 mt-1">
            อัตราสงเคราะห์ {formatCurrency(period?.welfareRate || 0)}
            {serviceFeeEnabled && period
              ? ` + ค่าบริการ ${formatCurrency(period.serviceFee)} (รวม ${formatCurrency(periodTotalPerPerson(period, true))}/คน)`
              : period
                ? ` (รวม ${formatCurrency(periodTotalPerPerson(period, false))}/คน)`
                : ''}
          </p>
        </div>
        {['ADMIN', 'SCHOOL_ADMIN', 'FINANCE', 'ACCOUNTING'].includes(user?.role || '') && (
          <Link href={`/reports/period-close-summary/${periodId}`} className="btn-secondary text-sm">
            สรุปปิดงวด
          </Link>
        )}
        {period?.isClosed ? (
          <div className="ml-auto flex items-center gap-2">
            <span className="badge-neutral">ปิดงวดแล้ว</span>
            <button
              onClick={() => {
                showConfirm(
                  'ต้องการเปิดงวดนี้หรือไม่? หลังจากเปิดแล้วจะสามารถบันทึกการชำระเงินได้อีก',
                  () => {
                    api.patch(`/contributions/periods/${periodId}`, { isClosed: false })
                      .then(() => {
                        queryClient.invalidateQueries({ queryKey: ['period', periodId] });
                        queryClient.invalidateQueries({ queryKey: ['period-contributions', periodId] });
                        queryClient.invalidateQueries({ queryKey: ['period-summary', periodId] });
                        showSuccess('เปิดงวดสำเร็จ');
                      })
                      .catch((error: any) => {
                        showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
                      });
                  }
                );
              }}
              className="btn-secondary text-sm"
            >
              เปิดงวด
            </button>
          </div>
        ) : (
          <div className="ml-auto flex items-center gap-2">
          <button
            onClick={handlePayAll}
            disabled={payAllMutation.isPending || unpaidCount === 0}
            className="btn-primary text-sm"
          >
            <Banknote size={16} />
            แจ้งชำระทุกคน
            {unpaidCount > 0 ? ` (${unpaidCount})` : ''}
          </button>
          <button
            onClick={() => {
              showConfirm(
                'แจ้งเตือนสมาชิกสมทบที่ค้างชำระในงวดนี้? ระบบจะทำเครื่องหมายค้างชำระและดำเนินการตามระเบียบ (3 งวดหลังแจ้ง)',
                () => arrearsNoticeMutation.mutate(),
              );
            }}
            disabled={arrearsNoticeMutation.isPending}
            className="btn-secondary text-sm"
          >
            แจ้งเตือนค้างชำระ
          </button>
          <button
            onClick={() => {
              showConfirm(
                'ต้องการปิดงวดนี้หรือไม่? หลังจากปิดแล้วจะไม่สามารถบันทึกการชำระเงินได้อีก',
                () => {
                  api.post(`/contributions/periods/${periodId}/close`)
                    .then(() => {
                      queryClient.invalidateQueries({ queryKey: ['period', periodId] });
                      queryClient.invalidateQueries({ queryKey: ['period-contributions', periodId] });
                      queryClient.invalidateQueries({ queryKey: ['period-summary', periodId] });
                      showSuccess('ปิดงวดสำเร็จ');
                    })
                    .catch((error: any) => {
                      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
                    });
                }
              );
            }}
            className="btn-secondary"
          >
            ปิดงวด
          </button>
          </div>
        )}
      </div>

      {/* Summary */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="stat-card">
          <div className="flex items-center gap-2">
            <Users className="w-5 h-5 text-slate-400" />
            <span className="stat-label">รายการทั้งหมด</span>
          </div>
          <p className="stat-value">{summary?.totalContributions || 0}</p>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-2">
            <CheckCircle className="w-5 h-5 text-emerald-500" />
            <span className="stat-label">ชำระแล้ว</span>
          </div>
          <p className="text-2xl font-bold text-emerald-600">{summary?.paidContributions || 0}</p>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-5 h-5 text-amber-500" />
            <span className="stat-label">ยังไม่ชำระ</span>
          </div>
          <p className="text-2xl font-bold text-amber-600">{summary?.unpaidContributions || 0}</p>
        </div>
        <div className="stat-card">
          <div className="flex items-center gap-2">
            <DollarSign className="w-5 h-5 text-primary-500" />
            <span className="stat-label">ยอดเก็บได้</span>
          </div>
          <p className="text-xl font-bold text-primary-600">{formatCurrency(summary?.paidAmount || 0)}</p>
        </div>
      </div>

      {schoolSummary && schoolSummary.schools.length > 0 && (
        <div className="card overflow-hidden">
          <div className="p-4 border-b border-slate-100 flex items-center gap-2">
            <Building2 size={18} className="text-primary-500" />
            <div>
              <h2 className="font-semibold text-slate-900">สรุปการชำระแยกรายโรงเรียน</h2>
              <p className="text-sm text-slate-500">
                ชำระแล้ว {schoolSummary.totals.paidMembers} คน จาก {schoolSummary.totals.totalMembers} คน
                {' '}({formatCurrency(schoolSummary.totals.paidAmount)})
              </p>
            </div>
          </div>
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>โรงเรียน</th>
                  <th className="text-center">ทั้งหมด</th>
                  <th className="text-center">ชำระแล้ว</th>
                  <th className="text-center">ยังไม่ชำระ</th>
                  <th className="text-right">ยอดเก็บได้</th>
                </tr>
              </thead>
              <tbody>
                {schoolSummary.schools.map((row) => (
                  <tr key={row.schoolId}>
                    <td className="font-medium">{row.schoolName}</td>
                    <td className="text-center">{row.totalMembers}</td>
                    <td className="text-center text-emerald-600 font-medium">{row.paidMembers}</td>
                    <td className="text-center text-amber-600">{row.unpaidMembers}</td>
                    <td className="text-right font-medium">{formatCurrency(row.paidAmount)}</td>
                  </tr>
                ))}
              </tbody>
              <tfoot>
                <tr className="bg-slate-50 font-semibold">
                  <td>รวมทั้งหมด</td>
                  <td className="text-center">{schoolSummary.totals.totalMembers}</td>
                  <td className="text-center text-emerald-700">{schoolSummary.totals.paidMembers}</td>
                  <td className="text-center text-amber-700">{schoolSummary.totals.unpaidMembers}</td>
                  <td className="text-right text-primary-700">
                    {formatCurrency(schoolSummary.totals.paidAmount)}
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      )}

      {/* Contributions Table */}
      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="flex justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : contributions?.length === 0 ? (
          <div className="text-center py-20 text-slate-500">
            <Users className="w-16 h-16 mx-auto text-slate-300 mb-4" />
            <p className="text-lg font-medium">ยังไม่มีรายการ</p>
            <p className="text-sm mt-1">กรุณา "สร้างรายการ" จากหน้ารายการงวดก่อน</p>
          </div>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>เลขสมาชิก</th>
                  <th>ชื่อ-นามสกุล</th>
                  <th>โรงเรียน</th>
                  <th>กลุ่ม</th>
                  <th className="text-right">ยอดที่ต้องชำระ</th>
                  <th className="text-right">ชำระแล้ว</th>
                  <th>วันที่ชำระ</th>
                  <th>สถานะ</th>
                  <th className="text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {contributions?.map((contrib) => (
                  <tr key={contrib.id}>
                    <td className="font-mono text-sm">{contrib.member.memberNo}</td>
                    <td className="font-medium">{memberName(contrib)}</td>
                    <td className="text-slate-500">{contrib.school.name}</td>
                    <td className="text-slate-500">{contrib.member.group?.name || '-'}</td>
                    <td className="text-right">{formatCurrency(contrib.totalAmount)}</td>
                    <td className="text-right font-medium text-emerald-600">
                      {formatCurrency(contrib.paidAmount)}
                    </td>
                    <td>
                      {contrib.paidDate ? (
                        <span className="flex items-center gap-1 text-sm">
                          <Calendar size={14} className="text-slate-400" />
                          {formatDate(contrib.paidDate)}
                        </span>
                      ) : '-'}
                    </td>
                    <td>
                      {Number(contrib.paidAmount) > 0 ? (
                        <span className="badge-success">ชำระแล้ว</span>
                      ) : contrib.isArrears ? (
                        <span className="badge-danger">ค้างชำระ</span>
                      ) : (
                        <span className="badge-warning">รอชำระ</span>
                      )}
                    </td>
                    <td className="text-right">
                      {Number(contrib.paidAmount) === 0 && !period?.isClosed && (
                        <button
                          onClick={() => handlePayment(contrib)}
                          className="btn-primary text-xs py-1.5 px-3"
                          disabled={paymentMutation.isPending}
                        >
                          รับชำระ
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </motion.div>
  );
}


