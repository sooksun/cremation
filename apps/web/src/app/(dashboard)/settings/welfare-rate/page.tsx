'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Settings, Calculator, Users, AlertTriangle, Edit2, Plus } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { api, type ContributionSettings, periodTotalPerPerson } from '@/lib/api';
import { showSuccess, showError, showConfirm } from '@/lib/toast';
import { useAuthStore } from '@/store/auth';

interface ContributionPeriod {
  id: string;
  year: number;
  month: number;
  welfareRate: number;
  serviceFee: number;
  isClosed: boolean;
}

interface PeriodForm {
  welfareRate: number;
  serviceFee: number;
}

const monthNames = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
];

export default function WelfareRateSettingsPage() {
  const queryClient = useQueryClient();
  const { selectedYear } = useAuthStore();
  const [editingPeriod, setEditingPeriod] = useState<ContributionPeriod | null>(null);
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

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: string; data: PeriodForm }) =>
      api.patch(`/contributions/periods/${id}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['contribution-periods'] });
      showSuccess('อัปเดตอัตราเงินสงเคราะห์สำเร็จ');
      setEditingPeriod(null);
      reset();
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const openEditModal = (period: ContributionPeriod) => {
    setEditingPeriod(period);
    reset({
      welfareRate: period.welfareRate,
      serviceFee: period.serviceFee,
    });
  };

  const closeModal = () => {
    setEditingPeriod(null);
    reset();
  };

  const onSubmit = (data: PeriodForm) => {
    if (!editingPeriod) return;
    
    showConfirm(
      `ยืนยันการแก้ไขอัตราเงินสงเคราะห์สำหรับงวด ${monthNames[editingPeriod.month - 1]} ${editingPeriod.year + 543}?`,
      () => {
        updateMutation.mutate({
          id: editingPeriod.id,
          data: {
            ...data,
            serviceFee: serviceFeeEnabled ? data.serviceFee : 0,
          },
        });
      }
    );
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
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            อัตราเงินสงเคราะห์
          </h1>
          <p className="text-slate-500 mt-1">
            จัดการอัตราเงินสงเคราะห์และค่าบริการสำหรับแต่ละงวด
          </p>
        </div>
      </div>

      {/* Info Card */}
      <div className="card p-6 bg-blue-50 border-blue-200">
        <h3 className="font-semibold text-blue-900 mb-3 flex items-center gap-2">
          <Settings className="w-5 h-5" />
          หลักการจ่ายเงินสงเคราะห์ศพ
        </h3>
        <div className="space-y-2 text-sm text-blue-800">
          <p>ระบบนี้ใช้วิธีการคำนวณเงินสงเคราะห์ศพแบบ <strong>"กองทุนกลาง"</strong> ดังนี้:</p>
          <p>• อัตราเงินสงเคราะห์กำหนดแยกตามแต่ละงวด{serviceFeeEnabled ? ' และค่าบริการ (เมื่อเปิดใช้งาน)' : ''}</p>
          <p>• สามารถแก้ไขอัตราได้เฉพาะงวดที่ยังไม่ปิด</p>
        </div>
      </div>

      {/* Periods Table */}
      <div className="card overflow-hidden">
        <div className="p-6 border-b border-slate-200">
          <h3 className="font-semibold text-slate-900">อัตราเงินสงเคราะห์ตามงวด</h3>
          <p className="text-sm text-slate-500 mt-1">ปี พ.ศ. {selectedYear + 543}</p>
        </div>
        
        {isLoading ? (
          <div className="flex justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : periods?.length === 0 ? (
          <div className="text-center py-20 text-slate-500">
            <Calculator className="w-16 h-16 mx-auto text-slate-300 mb-4" />
            <p className="text-lg font-medium">ยังไม่มีงวด</p>
            <p className="text-sm mt-1">กรุณาสร้างงวดจากหน้า "งวดเงินสงเคราะห์" ก่อน</p>
          </div>
        ) : (
          <div className="table-container border-0">
            <table className="table">
              <thead>
                <tr>
                  <th>งวด</th>
                  <th className="text-right">อัตราเงินสงเคราะห์</th>
                  {serviceFeeEnabled && <th className="text-right">ค่าบริการ</th>}
                  <th className="text-right">รวมต่อคน</th>
                  <th>สถานะ</th>
                  <th className="text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {periods?.map((period) => (
                  <tr key={period.id}>
                    <td className="font-medium">
                      {monthNames[period.month - 1]} {period.year + 543}
                    </td>
                    <td className="text-right">{formatCurrency(period.welfareRate)}</td>
                    {serviceFeeEnabled && (
                      <td className="text-right">{formatCurrency(period.serviceFee)}</td>
                    )}
                    <td className="text-right font-semibold text-primary-600">
                      {formatCurrency(periodTotalPerPerson(period, serviceFeeEnabled))}
                    </td>
                    <td>
                      {period.isClosed ? (
                        <span className="badge-neutral">ปิดงวดแล้ว</span>
                      ) : (
                        <span className="badge-success">เปิดอยู่</span>
                      )}
                    </td>
                    <td className="text-right">
                      {!period.isClosed && (
                        <button
                          onClick={() => openEditModal(period)}
                          className="btn-secondary text-xs py-1.5 px-3"
                        >
                          <Edit2 size={14} className="mr-1" />
                          แก้ไข
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

      {/* Calculation Method */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="card p-6">
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 rounded-xl bg-emerald-100">
              <Calculator className="w-6 h-6 text-emerald-600" />
            </div>
            <h3 className="font-semibold text-slate-900">สูตรการคำนวณ</h3>
          </div>
          <div className="space-y-4">
            <div className="p-4 bg-slate-50 rounded-xl">
              <p className="text-sm text-slate-600 mb-2">ยอดเงินสงเคราะห์ศพ (ระเบียบ ข้อ 13–16) =</p>
              <div className="text-lg font-semibold text-slate-900">
                (สมาชิกที่ส่ง × 100 หรือ 50 บาท) × 90% − หักอื่นๆ
              </div>
              <p className="text-xs text-slate-500 mt-2">10% ที่เหลือเข้ากองทุนฌาปนกิจสงเคราะห์</p>
            </div>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between py-2 border-b border-slate-100">
                <span className="text-slate-600">อัตราเก็บเมื่อสมาชิกเสียชีวิต</span>
                <span className="font-semibold text-emerald-600">100 บาท/คน</span>
              </div>
              <div className="flex justify-between py-2 border-b border-slate-100">
                <span className="text-slate-600">อัตราเก็บเมื่อญาติที่คุ้มครองเสียชีวิต</span>
                <span className="font-semibold text-emerald-600">50 บาท/คน</span>
              </div>
              <div className="flex justify-between py-2 border-b border-slate-100">
                <span className="text-slate-600">จำนวนสมาชิกใช้คำนวณ</span>
                <span className="font-semibold">ACTIVE (ไม่รวมผู้เสียชีวิต)</span>
              </div>
            </div>
          </div>
        </div>

        <div className="card p-6">
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 rounded-xl bg-purple-100">
              <Users className="w-6 h-6 text-purple-600" />
            </div>
            <h3 className="font-semibold text-slate-900">ตัวอย่างการคำนวณ</h3>
          </div>
          <div className="space-y-3">
            <div className="p-4 bg-purple-50 rounded-xl">
              <p className="text-sm text-purple-600 mb-2">กรณีสมาชิกเสียชีวิต มีผู้ส่งเงิน 50 คน × 100 บาท</p>
              <div className="space-y-1 text-sm">
                <div className="flex justify-between">
                  <span>ยอดเก็บรวม</span>
                  <span><strong>5,000 บาท</strong></span>
                </div>
                <div className="flex justify-between">
                  <span>เข้ากองทุน 10%</span>
                  <span><strong>500 บาท</strong></span>
                </div>
                <div className="flex justify-between">
                  <span>จ่ายผู้รับ 90%</span>
                  <span><strong>4,500 บาท</strong></span>
                </div>
                <div className="flex justify-between pt-2 border-t border-purple-200 mt-2">
                  <span className="font-semibold">ยอดจ่ายสุทธิ</span>
                  <span className="font-bold text-purple-700">4,500 บาท</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Notice */}
      <div className="card p-6 bg-amber-50 border-amber-200">
        <div className="flex items-start gap-3">
          <AlertTriangle className="w-6 h-6 text-amber-600 flex-shrink-0 mt-0.5" />
          <div>
            <h3 className="font-semibold text-amber-900 mb-2">หมายเหตุสำคัญ</h3>
            <ul className="text-sm text-amber-800 space-y-1 list-disc ml-4">
              <li>อัตราเงินสงเคราะห์กำหนดตามมติคณะกรรมการ</li>
              <li>อัตราเก็บเงินสงเคราะห์ศพคงที่ตามระเบียบ (ไม่ใช่อัตรางวดรายเดือน)</li>
              <li>ยอดจ่ายจริงอาจแตกต่างกันในแต่ละรายการตามเงื่อนไข</li>
              <li>การเปลี่ยนแปลงอัตราต้องผ่านมติที่ประชุมคณะกรรมการ</li>
              <li>สามารถแก้ไขอัตราได้เฉพาะงวดที่ยังไม่ปิด</li>
            </ul>
          </div>
        </div>
      </div>

      {/* Edit Modal */}
      {editingPeriod && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-white rounded-2xl w-full max-w-md p-6 shadow-xl"
          >
            <h2 className="text-xl font-bold text-slate-900 mb-4">
              แก้ไขอัตราเงินสงเคราะห์
            </h2>
            <p className="text-sm text-slate-500 mb-6">
              งวด {monthNames[editingPeriod.month - 1]} {editingPeriod.year + 543}
            </p>

            <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
              <div>
                <label className="label">อัตราเงินสงเคราะห์ (บาท/คน)</label>
                <input
                  {...register('welfareRate', { 
                    required: 'กรุณากรอกอัตราเงินสงเคราะห์',
                    valueAsNumber: true,
                    min: { value: 0, message: 'ต้องมากกว่าหรือเท่ากับ 0' }
                  })}
                  type="number"
                  step="0.01"
                  className="input"
                  placeholder="100"
                />
                {errors.welfareRate && (
                  <p className="text-red-500 text-sm mt-1">{errors.welfareRate.message}</p>
                )}
              </div>

              {serviceFeeEnabled && (
                <div>
                  <label className="label">ค่าบริการ (บาท/คน)</label>
                  <input
                    {...register('serviceFee', { 
                      required: 'กรุณากรอกค่าบริการ',
                      valueAsNumber: true,
                      min: { value: 0, message: 'ต้องมากกว่าหรือเท่ากับ 0' }
                    })}
                    type="number"
                    step="0.01"
                    className="input"
                    placeholder="10"
                  />
                  {errors.serviceFee && (
                    <p className="text-red-500 text-sm mt-1">{errors.serviceFee.message}</p>
                  )}
                </div>
              )}

              <div className="flex gap-3 pt-4">
                <button
                  type="button"
                  onClick={closeModal}
                  className="btn-secondary flex-1"
                  disabled={updateMutation.isPending}
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  className="btn-primary flex-1"
                  disabled={updateMutation.isPending}
                >
                  {updateMutation.isPending ? 'กำลังบันทึก...' : 'บันทึก'}
                </button>
              </div>
            </form>
          </motion.div>
        </div>
      )}
    </motion.div>
  );
}
