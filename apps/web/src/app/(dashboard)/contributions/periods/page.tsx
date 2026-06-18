'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion, AnimatePresence } from 'framer-motion';
import { Plus, Calendar, Lock, Unlock, Play, Eye, X, Users, DollarSign } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import Link from 'next/link';
import { api, type ContributionPeriod, type ContributionSettings, periodTotalPerPerson } from '@/lib/api';
import { useAuthStore } from '@/store/auth';

interface PeriodForm {
  year: number;
  month: number;
  welfareRate: number;
  serviceFee: number;
}

const monthNames = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
];

export default function ContributionPeriodsPage() {
  const queryClient = useQueryClient();
  const { selectedYear } = useAuthStore();
  const [modalOpen, setModalOpen] = useState(false);

  const { register, handleSubmit, reset, formState: { errors } } = useForm<PeriodForm>();

  const { data: periods, isLoading } = useQuery<ContributionPeriod[]>({
    queryKey: ['contribution-periods', selectedYear],
    queryFn: async () => {
      const response = await api.get(`/contributions/periods?year=${selectedYear}`);
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

  const settingsMutation = useMutation({
    mutationFn: (enabled: boolean) =>
      api.patch('/contributions/settings', { serviceFeeEnabled: enabled }),
    onSuccess: (response) => {
      queryClient.setQueryData(['contribution-settings'], response.data);
      showSuccess(response.data.serviceFeeEnabled ? 'เปิดใช้งานค่าบริการแล้ว' : 'ปิดค่าบริการแล้ว');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: PeriodForm) => api.post('/contributions/periods', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contribution-periods'] });
      showSuccess('เพิ่มงวดสำเร็จ');
      closeModal();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const generateMutation = useMutation({
    mutationFn: (periodId: string) => api.post(`/contributions/periods/${periodId}/generate`),
    onSuccess: (_, periodId) => {
      queryClient.invalidateQueries({ queryKey: ['contribution-periods'] });
      showSuccess('สร้างรายการเงินสงเคราะห์สำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const closePeriodMutation = useMutation({
    mutationFn: (periodId: string) => api.post(`/contributions/periods/${periodId}/close`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contribution-periods'] });
      showSuccess('ปิดงวดสำเร็จ');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openModal = () => {
    reset({
      year: selectedYear,
      month: new Date().getMonth() + 1,
      welfareRate: 100,
      serviceFee: serviceFeeEnabled ? 10 : 0,
    });
    setModalOpen(true);
  };

  const closeModal = () => {
    setModalOpen(false);
    reset();
  };

  const onSubmit = (data: PeriodForm) => {
    createMutation.mutate({
      ...data,
      serviceFee: serviceFeeEnabled ? data.serviceFee : 0,
    });
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
      minimumFractionDigits: 0,
    }).format(amount);
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
            งวดเงินสงเคราะห์
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการงวดเงินสงเคราะห์ประจำเดือน ปี พ.ศ. {selectedYear + 543}
          </p>
        </div>
        <button onClick={openModal} className="btn-primary">
          <Plus size={20} />
          เพิ่มงวด
        </button>
      </div>

      <div className="card p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <p className="font-medium text-slate-900">ค่าบริการ</p>
          <p className="text-sm text-slate-500 mt-0.5">
            ระบบฌาปนกิจสหกรณ์โดยปกติไม่มีค่าบริการ — เปิดเมื่อต้องการเก็บค่าบริการแยกจากเงินสงเคราะห์
          </p>
        </div>
        <div className="flex items-center gap-3">
          <span className={`text-sm font-medium ${serviceFeeEnabled ? 'text-slate-400' : 'text-slate-700'}`}>
            ปิด
          </span>
          <button
            type="button"
            role="switch"
            aria-checked={serviceFeeEnabled}
            onClick={() => settingsMutation.mutate(!serviceFeeEnabled)}
            disabled={settingsMutation.isPending}
            className={`relative inline-flex h-7 w-12 shrink-0 rounded-full transition-colors ${
              serviceFeeEnabled ? 'bg-primary-500' : 'bg-slate-300'
            } ${settingsMutation.isPending ? 'opacity-60' : ''}`}
          >
            <span
              className={`inline-block h-5 w-5 transform rounded-full bg-white shadow transition-transform mt-1 ${
                serviceFeeEnabled ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
          <span className={`text-sm font-medium ${serviceFeeEnabled ? 'text-primary-700' : 'text-slate-400'}`}>
            เปิด
          </span>
        </div>
      </div>

      {/* Periods Grid */}
      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      ) : periods?.length === 0 ? (
        <div className="card text-center py-20 text-slate-500">
          <Calendar className="w-16 h-16 mx-auto text-slate-300 mb-4" />
          <p className="text-lg font-medium">ยังไม่มีงวดเงินสงเคราะห์</p>
          <p className="text-sm mt-1">เริ่มต้นด้วยการเพิ่มงวดใหม่</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {periods?.map((period) => (
            <motion.div
              key={period.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              className={`card p-5 ${period.isClosed ? 'bg-slate-50' : ''}`}
            >
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-2">
                  <Calendar className="w-5 h-5 text-primary-500" />
                  <span className="font-semibold text-slate-900">
                    {monthNames[period.month - 1]} {period.year + 543}
                  </span>
                </div>
                {period.isClosed ? (
                  <span className="badge-neutral flex items-center gap-1">
                    <Lock size={12} /> ปิดแล้ว
                  </span>
                ) : (
                  <span className="badge-success flex items-center gap-1">
                    <Unlock size={12} /> เปิด
                  </span>
                )}
              </div>

              <div className="space-y-2 text-sm mb-4">
                <div className="flex justify-between">
                  <span className="text-slate-500">อัตราสงเคราะห์</span>
                  <span className="font-medium">{formatCurrency(period.welfareRate)}</span>
                </div>
                {serviceFeeEnabled && (
                  <div className="flex justify-between">
                    <span className="text-slate-500">ค่าบริการ</span>
                    <span className="font-medium">{formatCurrency(period.serviceFee)}</span>
                  </div>
                )}
                <div className="flex justify-between pt-2 border-t border-slate-100">
                  <span className="text-slate-500">รวม/คน</span>
                  <span className="font-semibold text-primary-600">
                    {formatCurrency(periodTotalPerPerson(period, serviceFeeEnabled))}
                  </span>
                </div>
              </div>

              <div className="flex items-center gap-1.5 text-sm text-slate-500 mb-4">
                <Users size={14} />
                <span>{period._count?.contributions || 0} รายการ</span>
              </div>

              <div className="flex gap-2">
                {!period.isClosed && (
                  <>
                    <button
                      onClick={() => {
                        showConfirm(
                          'ต้องการสร้างรายการเงินสงเคราะห์สำหรับสมาชิกทุกคน?',
                          () => generateMutation.mutate(period.id),
                        );
                      }}
                      className="btn-secondary flex-1 text-xs py-2"
                      disabled={generateMutation.isPending}
                    >
                      <Play size={14} />
                      สร้างรายการ
                    </button>
                    <button
                      onClick={() => {
                        showConfirm(
                          'ต้องการปิดงวดนี้? จะไม่สามารถแก้ไขได้อีก',
                          () => closePeriodMutation.mutate(period.id),
                        );
                      }}
                      className="btn-secondary text-xs py-2 px-3"
                      disabled={closePeriodMutation.isPending}
                    >
                      <Lock size={14} />
                    </button>
                  </>
                )}
                <Link
                  href={`/contributions/periods/${period.id}`}
                  className="btn-secondary flex-1 text-xs py-2"
                >
                  <Eye size={14} />
                  ดูรายละเอียด
                </Link>
              </div>
            </motion.div>
          ))}
        </div>
      )}

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
                <h2 className="text-xl font-semibold">เพิ่มงวดเงินสงเคราะห์</h2>
                <button onClick={closeModal} className="p-2 hover:bg-slate-100 rounded-lg">
                  <X size={20} />
                </button>
              </div>

              <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="label">ปี (ค.ศ.)</label>
                    <input
                      {...register('year', { required: true, valueAsNumber: true })}
                      type="number"
                      className="input"
                    />
                  </div>
                  <div>
                    <label className="label">เดือน</label>
                    <select {...register('month', { valueAsNumber: true })} className="input">
                      {monthNames.map((name, index) => (
                        <option key={index} value={index + 1}>{name}</option>
                      ))}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="label">อัตราเงินสงเคราะห์ (บาท/คน)</label>
                  <input
                    {...register('welfareRate', { required: true, valueAsNumber: true, min: 0 })}
                    type="number"
                    className="input"
                    placeholder="100"
                  />
                </div>

                {serviceFeeEnabled && (
                  <div>
                    <label className="label">ค่าบริการ (บาท/คน)</label>
                    <input
                      {...register('serviceFee', { required: true, valueAsNumber: true, min: 0 })}
                      type="number"
                      className="input"
                      placeholder="10"
                    />
                  </div>
                )}

                <div className="flex gap-3 pt-4">
                  <button type="button" onClick={closeModal} className="btn-secondary flex-1">
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="btn-primary flex-1"
                    disabled={createMutation.isPending}
                  >
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


