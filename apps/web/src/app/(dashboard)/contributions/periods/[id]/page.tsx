'use client';

import { useParams } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Calendar, Users, DollarSign, CheckCircle, AlertCircle } from 'lucide-react';
import Link from 'next/link';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { api } from '@/lib/api';

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
    firstName: string;
    lastName: string;
    phone?: string;
    group?: { name: string };
  };
  school: { name: string };
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

  const { data: period } = useQuery<Period>({
    queryKey: ['period', periodId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}`);
      return response.data;
    },
  });

  const { data: contributions, isLoading } = useQuery<Contribution[]>({
    queryKey: ['period-contributions', periodId],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods/${periodId}/contributions`);
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

  const paymentMutation = useMutation({
    mutationFn: ({ id, amount }: { id: string; amount: number }) =>
      api.patch(`/contributions/${id}/payment`, {
        amount,
        paidDate: new Date().toISOString(),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['period-contributions'] });
      queryClient.invalidateQueries({ queryKey: ['period-summary'] });
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
      `ยืนยันการรับชำระเงิน ${formatCurrency(contribution.totalAmount)} จาก ${contribution.member.firstName} ${contribution.member.lastName}?`,
      () => paymentMutation.mutate({ id: contribution.id, amount: contribution.totalAmount }),
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
            อัตราสงเคราะห์ {formatCurrency(period?.welfareRate || 0)} + ค่าบริการ {formatCurrency(period?.serviceFee || 0)}
          </p>
        </div>
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
            className="btn-secondary ml-auto"
          >
            ปิดงวด
          </button>
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
                    <td className="font-medium">
                      {contrib.member.firstName} {contrib.member.lastName}
                    </td>
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


