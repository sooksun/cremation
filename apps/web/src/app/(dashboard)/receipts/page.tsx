'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Receipt, Eye, X, Calendar, Building2, Printer } from 'lucide-react';
import { useForm, Controller } from 'react-hook-form';
import { showSuccess, showError } from '@/lib/toast';
import { api, type School } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import Link from 'next/link';

interface ReceiptItem {
  id: string;
  receiptNo: string;
  date: string;
  type: string;
  description?: string;
  amount: number;
  school: School;
  bankAccount?: { bankName: string; accountNo: string };
}

interface ReceiptForm {
  schoolId: string;
  date: string;
  type: string;
  description?: string;
  amount: number;
  bankAccountId?: string;
}

const typeLabels: Record<string, string> = {
  MEMBER_CONTRIBUTION: 'เงินสงเคราะห์',
  MEMBERSHIP_FEE: 'ค่าสมาชิก',
  BOOK_FEE: 'ค่าสมุด',
  ANNUAL_FEE: 'ค่าบำรุงประจำปี',
  ADVANCE_WELFARE: 'เงินสงเคราะห์ล่วงหน้า',
  OTHER: 'อื่นๆ',
};

export default function ReceiptsPage() {
  const queryClient = useQueryClient();
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [modalOpen, setModalOpen] = useState(false);

  const { register, handleSubmit, reset, control, formState: { errors } } = useForm<ReceiptForm>({
    defaultValues: {
      date: new Date().toISOString().split('T')[0],
    },
  });

  const { data: receipts, isLoading } = useQuery<ReceiptItem[]>({
    queryKey: ['receipts', selectedSchoolId, selectedYear],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('startDate', `${selectedYear}-01-01`);
      params.append('endDate', `${selectedYear}-12-31`);
      const response = await api.get(`/receipts?${params}`);
      return response.data;
    },
  });

  const { data: schools } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  const { data: bankAccounts } = useQuery({
    queryKey: ['bank-accounts', selectedSchoolId],
    queryFn: async () => {
      const params = selectedSchoolId ? `?schoolId=${selectedSchoolId}` : '';
      const response = await api.get(`/bank-accounts${params}`);
      return response.data;
    },
  });

  const { data: summary } = useQuery({
    queryKey: ['receipts-summary', selectedSchoolId, selectedYear],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('startDate', `${selectedYear}-01-01`);
      params.append('endDate', `${selectedYear}-12-31`);
      const response = await api.get(`/receipts/summary?${params}`);
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: ReceiptForm) => api.post('/receipts', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['receipts'] });
      queryClient.invalidateQueries({ queryKey: ['receipts-summary'] });
      showSuccess('บันทึกใบเสร็จสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = () => {
    reset({
      schoolId: selectedSchoolId || '',
      date: new Date().toISOString().split('T')[0],
      type: 'MEMBER_CONTRIBUTION',
      amount: 0,
    });
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    reset();
  };

  const onSubmit = (data: ReceiptForm) => {
    if (!data.bankAccountId) delete data.bankAccountId;
    createMutation.mutate(data);
  };

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

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            ใบเสร็จรับเงิน
          </h1>
          <p className="text-slate-500 mt-1">
            บันทึกรายรับของสมาคม ปี พ.ศ. {selectedYear + 543}
          </p>
        </div>
        <button onClick={openModal} className="btn-primary">
          <Plus size={20} />
          บันทึกใบเสร็จ
        </button>
      </div>

      {/* Summary */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="stat-card">
          <p className="stat-label">รายรับทั้งหมด</p>
          <p className="text-xl font-bold text-emerald-600">
            {formatCurrency(summary?.total?.amount || 0)}
          </p>
          <p className="text-sm text-slate-500">{summary?.total?.count || 0} รายการ</p>
        </div>
        {summary?.byType?.slice(0, 3).map((item: any) => (
          <div key={item.type} className="stat-card">
            <p className="stat-label">{typeLabels[item.type]}</p>
            <p className="text-xl font-bold text-slate-900">
              {formatCurrency(item.amount)}
            </p>
            <p className="text-sm text-slate-500">{item.count} รายการ</p>
          </div>
        ))}
      </div>

      {/* Table */}
      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : receipts?.length === 0 ? (
          <div className="text-center py-20 text-slate-500">
            <Receipt className="w-16 h-16 mx-auto text-slate-300 mb-4" />
            <p className="text-lg font-medium">ยังไม่มีใบเสร็จ</p>
          </div>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>เลขที่</th>
                  <th>วันที่</th>
                  <th>ประเภท</th>
                  <th>รายละเอียด</th>
                  <th>โรงเรียน</th>
                  <th className="text-right">จำนวนเงิน</th>
                  <th className="text-center">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {receipts?.map((receipt) => (
                  <tr key={receipt.id}>
                    <td className="font-mono text-sm">{receipt.receiptNo}</td>
                    <td>
                      <span className="flex items-center gap-1 text-sm">
                        <Calendar size={14} className="text-slate-400" />
                        {formatDate(receipt.date)}
                      </span>
                    </td>
                    <td>
                      <span className="badge-success">{typeLabels[receipt.type]}</span>
                    </td>
                    <td className="text-slate-500 text-sm max-w-xs truncate">
                      {receipt.description || '-'}
                    </td>
                    <td className="text-slate-500 text-sm">{receipt.school?.name || '-'}</td>
                    <td className="text-right font-semibold text-emerald-600">
                      {formatCurrency(receipt.amount)}
                    </td>
                    <td>
                      <div className="flex justify-center gap-1">
                        <Link
                          href={`/receipts/${receipt.id}`}
                          className="p-2 rounded-lg hover:bg-slate-100 text-slate-500 hover:text-primary-600"
                          title="ดูรายละเอียด/พิมพ์"
                        >
                          <Printer size={18} />
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modal */}
      <AnimatePresence>
        {modalOpen && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
            onClick={closeModal}
          >
            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 20 }}
              className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="flex items-center justify-between mb-6">
                <h2 className="text-xl font-semibold">บันทึกใบเสร็จรับเงิน</h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div>
                  <label className="label">โรงเรียน</label>
                  <select {...register('schoolId', { required: true })} className="input">
                    <option value="">เลือกโรงเรียน</option>
                    {schools?.map((school) => (
                      <option key={school.id} value={school.id}>{school.name}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="label">วันที่</label>
                  <Controller
                    name="date"
                    control={control}
                    rules={{ required: true }}
                    render={({ field }) => (
                      <ThaiDatePicker
                        value={field.value ? dayjs(field.value) : dayjs()}
                        onChange={(date) => field.onChange(date ? date.format('YYYY-MM-DD') : '')}
                        placeholder="เลือกวันที่"
                        style={{ width: '100%' }}
                      />
                    )}
                  />
                </div>

                <div>
                  <label className="label">ประเภท</label>
                  <select {...register('type')} className="input">
                    {Object.entries(typeLabels).map(([value, label]) => (
                      <option key={value} value={value}>{label}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="label">รายละเอียด</label>
                  <input {...register('description')} className="input" placeholder="รายละเอียด (ไม่บังคับ)" />
                </div>

                <div>
                  <label className="label">จำนวนเงิน (บาท)</label>
                  <input
                    {...register('amount', { required: true, valueAsNumber: true, min: 0 })}
                    type="number"
                    className="input"
                    placeholder="0.00"
                  />
                </div>

                <div>
                  <label className="label">บัญชีธนาคาร (ไม่บังคับ)</label>
                  <select {...register('bankAccountId')} className="input">
                    <option value="">เงินสด</option>
                    {bankAccounts?.map((acc: any) => (
                      <option key={acc.id} value={acc.id}>
                        {acc.bankName} - {acc.accountNo}
                      </option>
                    ))}
                  </select>
                </div>

                <div className="flex gap-3 pt-4">
                  <button type="button" onClick={closeModal} className="btn-secondary flex-1">
                    ยกเลิก
                  </button>
                  <button type="submit" className="btn-primary flex-1" disabled={createMutation.isPending}>
                    {createMutation.isPending ? (
                      <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                    ) : (
                      'บันทึก'
                    )}
                  </button>
                </div>
              </form>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}


