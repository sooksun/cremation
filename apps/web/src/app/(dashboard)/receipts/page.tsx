'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Receipt, Eye, X, Calendar, Building2, Printer } from 'lucide-react';
import { useForm, Controller } from 'react-hook-form';
import { showSuccess, showError } from '@/lib/toast';
import { api, type School } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import { canSelectAllSchools, filterSchoolsForUser } from '@/lib/school-scope';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import Link from 'next/link';
import { fieldId } from '@/lib/field-id';

interface ReceiptItem {
  id: string;
  receiptNo: string;
  date: string;
  type: string;
  description?: string;
  amount: number;
  school: School;
  bankAccount?: { bankName: string; accountNo: string };
  voidedAt?: string | null;
  voidReason?: string | null;
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

const THAI_MONTHS = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
];

// ช่วงวันที่ของตัวกรอง — เดือน 0 คือทั้งปี
function buildDateRange(year: number, month: number) {
  if (!month) {
    return { startDate: `${year}-01-01`, endDate: `${year}-12-31` };
  }
  const mm = String(month).padStart(2, '0');
  const lastDay = new Date(year, month, 0).getDate();
  return { startDate: `${year}-${mm}-01`, endDate: `${year}-${mm}-${lastDay}` };
}

export default function ReceiptsPage() {
  const queryClient = useQueryClient();
  const { user, selectedSchoolId, setSelectedSchool, selectedYear } = useAuthStore();
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedMonth, setSelectedMonth] = useState(0);

  const { startDate, endDate } = buildDateRange(selectedYear, selectedMonth);

  const { register, handleSubmit, reset, control, formState: { errors } } = useForm<ReceiptForm>({
    defaultValues: {
      date: new Date().toISOString().split('T')[0],
    },
  });

  const { data: receipts, isLoading } = useQuery<ReceiptItem[]>({
    queryKey: ['receipts', selectedSchoolId, selectedYear, selectedMonth],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('startDate', startDate);
      params.append('endDate', endDate);
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
    queryKey: ['receipts-summary', selectedSchoolId, selectedYear, selectedMonth],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      params.append('startDate', startDate);
      params.append('endDate', endDate);
      const response = await api.get(`/receipts/summary?${params}`);
      return response.data;
    },
  });

  const schoolOptions = filterSchoolsForUser(schools ?? [], user?.role, user?.schoolId);
  const selectedSchoolName =
    schoolOptions.find((school) => school.id === selectedSchoolId)?.name || 'ทุกโรงเรียน';
  const periodLabel = selectedMonth
    ? `${THAI_MONTHS[selectedMonth - 1]} ${selectedYear + 543}`
    : `ปี พ.ศ. ${selectedYear + 543}`;

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
            บันทึกรายรับของสมาคม — {selectedSchoolName} · {periodLabel}
          </p>
        </div>
        <button onClick={openModal} className="btn-primary">
          <Plus size={20} />
          บันทึกใบเสร็จ
        </button>
      </div>

      {/* Filters — พิมพ์ใบเสร็จต้องเลือกได้ทั้งรายโรงเรียนและรายเดือน */}
      <div className="card p-4 flex flex-col md:flex-row gap-4">
        <div className="flex-1">
          <label htmlFor="receipts-199" className="label flex items-center gap-2">
            <Building2 size={16} className="text-slate-400" />
            โรงเรียน
          </label>
          <select
            id="receipts-199"
            className="input"
            value={selectedSchoolId || ''}
            onChange={(e) => setSelectedSchool(e.target.value || null)}
            disabled={!canSelectAllSchools(user?.role)}
          >
            {canSelectAllSchools(user?.role) && <option value="">ทุกโรงเรียน</option>}
            {schoolOptions.map((school) => (
              <option key={school.id} value={school.id}>
                {school.name}
              </option>
            ))}
          </select>
        </div>
        <div className="flex-1">
          <label htmlFor="receipts-218" className="label flex items-center gap-2">
            <Calendar size={16} className="text-slate-400" />
            เดือน
          </label>
          <select
            id="receipts-218"
            className="input"
            value={selectedMonth}
            onChange={(e) => setSelectedMonth(Number(e.target.value))}
          >
            <option value={0}>ทั้งปี</option>
            {THAI_MONTHS.map((month, index) => (
              <option key={month} value={index + 1}>
                {month}
              </option>
            ))}
          </select>
        </div>
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
                  <tr key={receipt.id} className={receipt.voidedAt ? 'bg-rose-50/60' : undefined}>
                    <td className="font-mono text-sm">
                      <span className={receipt.voidedAt ? 'line-through text-slate-400' : undefined}>
                        {receipt.receiptNo}
                      </span>
                      {receipt.voidedAt && (
                        <span className="badge-danger ml-2" title={receipt.voidReason || undefined}>
                          ยกเลิก
                        </span>
                      )}
                    </td>
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
                    <td
                      className={
                        receipt.voidedAt
                          ? 'text-right font-semibold text-slate-400 line-through'
                          : 'text-right font-semibold text-emerald-600'
                      }
                    >
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
                  <label htmlFor={fieldId('schoolId')} className="label">โรงเรียน</label>
                  <select id={fieldId('schoolId')} {...register('schoolId', { required: true })} className="input">
                    <option value="">เลือกโรงเรียน</option>
                    {schools?.map((school) => (
                      <option key={school.id} value={school.id}>{school.name}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label htmlFor="receipts-date" className="label">วันที่</label>
                  <Controller
                    name="date"
                    control={control}
                    rules={{ required: true }}
                    render={({ field }) => (
                      <ThaiDatePicker
                        id="receipts-date"
                        value={field.value ? dayjs(field.value) : dayjs()}
                        onChange={(date) => field.onChange(date ? date.format('YYYY-MM-DD') : '')}
                        placeholder="เลือกวันที่"
                        style={{ width: '100%' }}
                      />
                    )}
                  />
                </div>

                <div>
                  <label htmlFor={fieldId('type')} className="label">ประเภท</label>
                  <select id={fieldId('type')} {...register('type')} className="input">
                    {Object.entries(typeLabels).map(([value, label]) => (
                      <option key={value} value={value}>{label}</option>
                    ))}
                  </select>
                </div>

                <div>
                  <label htmlFor={fieldId('description')} className="label">รายละเอียด</label>
                  <input id={fieldId('description')} {...register('description')} className="input" placeholder="รายละเอียด (ไม่บังคับ)" />
                </div>

                <div>
                  <label htmlFor={fieldId('amount')} className="label">จำนวนเงิน (บาท)</label>
                  <input
                    id={fieldId('amount')}
                    {...register('amount', { required: true, valueAsNumber: true, min: 0 })}
                    type="number"
                    className="input"
                    placeholder="0.00"
                  />
                </div>

                <div>
                  <label htmlFor={fieldId('bankAccountId')} className="label">บัญชีธนาคาร (ไม่บังคับ)</label>
                  <select id={fieldId('bankAccountId')} {...register('bankAccountId')} className="input">
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


