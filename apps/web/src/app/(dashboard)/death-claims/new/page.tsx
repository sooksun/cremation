'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useQuery, useMutation } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Save, Search, User, AlertCircle } from 'lucide-react';
import { useForm, Controller } from 'react-hook-form';
import Link from 'next/link';
import { showSuccess, showError } from '@/lib/toast';
import { api, type School, type Member } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';

// ประเภทผู้เสียชีวิต
enum DeceasedType {
  MEMBER = 'MEMBER',   // ตัวสมาชิกเอง - จ่าย 100%
  PARENT = 'PARENT',   // บิดา/มารดา - จ่าย 50%
  CHILD = 'CHILD',     // บุตร/ธิดา - จ่าย 50%
}

const deceasedTypeLabels: Record<DeceasedType, string> = {
  [DeceasedType.MEMBER]: 'ตัวสมาชิกเอง (จ่าย 100%)',
  [DeceasedType.PARENT]: 'บิดา/มารดา (จ่าย 50%)',
  [DeceasedType.CHILD]: 'บุตร/ธิดา (จ่าย 50%)',
};

interface DeathClaimForm {
  memberId: string;
  schoolId: string;
  reportedDate: string;
  deathDate: string;
  causeOfDeath?: string;
  deceasedType: DeceasedType;
  deceasedName?: string;
  relationshipNote?: string;
  mainBeneficiary: string;
  beneficiaryPhone?: string;
  otherDeductions?: number;
}

export default function NewDeathClaimPage() {
  const router = useRouter();
  const { selectedSchoolId } = useAuthStore();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedMember, setSelectedMember] = useState<Member | null>(null);

  const { register, handleSubmit, setValue, watch, control, formState: { errors } } = useForm<DeathClaimForm>({
    defaultValues: {
      schoolId: selectedSchoolId || '',
      reportedDate: new Date().toISOString().split('T')[0],
      deathDate: new Date().toISOString().split('T')[0],
      deceasedType: DeceasedType.MEMBER,
      otherDeductions: 0,
    },
  });

  const watchSchoolId = watch('schoolId');
  const watchDeceasedType = watch('deceasedType');

  const { data: schools } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  // แก้ไข: API return { data: [...], meta: {...} } ไม่ใช่ array โดยตรง
  const { data: membersData } = useQuery<{ data: Member[]; meta: any }>({
    queryKey: ['members-search', watchSchoolId, searchTerm],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (watchSchoolId) params.append('schoolId', watchSchoolId);
      if (searchTerm) params.append('search', searchTerm);
      params.append('status', 'ACTIVE');
      const response = await api.get(`/members?${params}`);
      return response.data;
    },
    enabled: !!watchSchoolId,
  });

  const members = membersData?.data || [];

  // ดึงอัตราเงินช่วยเหลือปัจจุบัน
  const { data: welfareData } = useQuery<{ welfareAmountPerCase: number }>({
    queryKey: ['current-welfare-amount'],
    queryFn: async () => {
      const response = await api.get('/death-claims/current-welfare-amount');
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: DeathClaimForm) => api.post('/death-claims', data),
    onSuccess: () => {
      showSuccess('บันทึกการแจ้งเสียชีวิตสำเร็จ');
      router.push('/death-claims');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const handleSelectMember = (member: Member) => {
    setSelectedMember(member);
    setValue('memberId', member.id);
    // Set main beneficiary from member's first beneficiary if available
    if ((member as any).beneficiaries?.length > 0) {
      const firstBeneficiary = (member as any).beneficiaries[0];
      setValue('mainBeneficiary', firstBeneficiary.fullName);
      if (firstBeneficiary.phone) {
        setValue('beneficiaryPhone', firstBeneficiary.phone);
      }
    }
  };

  // คำนวณยอดเงินที่จะได้รับ
  const calculateAmount = () => {
    if (!welfareData?.welfareAmountPerCase) return { baseAmount: 0, percent: 100, calculated: 0 };
    const baseAmount = welfareData.welfareAmountPerCase;
    const percent = watchDeceasedType === DeceasedType.MEMBER ? 100 : 50;
    const calculated = (baseAmount * percent) / 100;
    return { baseAmount, percent, calculated };
  };

  const { baseAmount, percent, calculated } = calculateAmount();

  const onSubmit = (data: DeathClaimForm) => {
    if (!data.memberId) {
      showError('กรุณาเลือกสมาชิก');
      return;
    }
    
    // Clean up empty optional fields
    const submitData: any = { ...data };
    if (!submitData.causeOfDeath) delete submitData.causeOfDeath;
    if (!submitData.deceasedName) delete submitData.deceasedName;
    if (!submitData.relationshipNote) delete submitData.relationshipNote;
    if (!submitData.beneficiaryPhone) delete submitData.beneficiaryPhone;
    if (!submitData.otherDeductions) submitData.otherDeductions = 0;

    createMutation.mutate(submitData);
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
      <div className="flex items-center gap-4">
        <Link href="/death-claims" className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            บันทึกการแจ้งเสียชีวิต
          </h1>
          <p className="text-slate-500 mt-1">
            กรอกข้อมูลการเสียชีวิตของสมาชิก
          </p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Select School & Member */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ข้อมูลสมาชิก</h3>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label className="label">โรงเรียน *</label>
              <select
                {...register('schoolId', { required: 'กรุณาเลือกโรงเรียน' })}
                className="input"
                onChange={(e) => {
                  setValue('schoolId', e.target.value);
                  setSelectedMember(null);
                  setValue('memberId', '');
                }}
              >
                <option value="">เลือกโรงเรียน</option>
                {schools?.map((school) => (
                  <option key={school.id} value={school.id}>
                    {school.name}
                  </option>
                ))}
              </select>
              {errors.schoolId && (
                <p className="text-sm text-red-500 mt-1">{errors.schoolId.message}</p>
              )}
            </div>

            <div>
              <label className="label">ค้นหาสมาชิก</label>
              <div className="relative">
                <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                <input
                  type="text"
                  className="input pl-10"
                  placeholder="ค้นหาชื่อ, เลขสมาชิก..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  disabled={!watchSchoolId}
                />
              </div>
            </div>
          </div>

          {/* Selected Member */}
          {selectedMember && (
            <div className="p-4 bg-primary-50 rounded-xl border border-primary-100 mb-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center">
                  <User className="w-6 h-6 text-primary-600" />
                </div>
                <div>
                  <p className="font-semibold text-slate-900">
                    {selectedMember.firstName} {selectedMember.lastName}
                  </p>
                  <p className="text-sm text-slate-500">
                    เลขสมาชิก: {selectedMember.memberNo} • {selectedMember.memberType.name}
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Member List */}
          {watchSchoolId && !selectedMember && members.length > 0 && (
            <div className="border border-slate-200 rounded-xl max-h-60 overflow-y-auto">
              {members.map((member) => (
                <button
                  key={member.id}
                  type="button"
                  onClick={() => handleSelectMember(member)}
                  className="w-full p-3 flex items-center gap-3 hover:bg-slate-50 border-b border-slate-100 last:border-b-0 text-left"
                >
                  <div className="w-10 h-10 bg-slate-100 rounded-full flex items-center justify-center">
                    <User className="w-5 h-5 text-slate-500" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">
                      {member.firstName} {member.lastName}
                    </p>
                    <p className="text-sm text-slate-500">
                      {member.memberNo} • {member.memberType.name}
                    </p>
                  </div>
                </button>
              ))}
            </div>
          )}

          <input type="hidden" {...register('memberId', { required: 'กรุณาเลือกสมาชิก' })} />
          {errors.memberId && (
            <p className="text-sm text-red-500 mt-2">{errors.memberId.message}</p>
          )}
        </div>

        {/* Death Information */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ข้อมูลการเสียชีวิต</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* ประเภทผู้เสียชีวิต */}
            <div className="md:col-span-2">
              <label className="label">ประเภทผู้เสียชีวิต *</label>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                {Object.entries(deceasedTypeLabels).map(([value, label]) => (
                  <label
                    key={value}
                    className={`flex items-center gap-3 p-4 border-2 rounded-xl cursor-pointer transition-all ${
                      watchDeceasedType === value
                        ? 'border-primary-500 bg-primary-50'
                        : 'border-slate-200 hover:border-slate-300'
                    }`}
                  >
                    <input
                      {...register('deceasedType', { required: 'กรุณาเลือกประเภทผู้เสียชีวิต' })}
                      type="radio"
                      value={value}
                      className="w-4 h-4 text-primary-600"
                    />
                    <span className={watchDeceasedType === value ? 'text-primary-700 font-medium' : 'text-slate-700'}>
                      {label}
                    </span>
                  </label>
                ))}
              </div>
              {errors.deceasedType && (
                <p className="text-sm text-red-500 mt-1">{errors.deceasedType.message}</p>
              )}
            </div>

            {/* ชื่อผู้เสียชีวิต - แสดงเฉพาะกรณีบิดา/มารดา หรือ บุตร/ธิดา */}
            {watchDeceasedType !== DeceasedType.MEMBER && (
              <>
                <div>
                  <label className="label">ชื่อผู้เสียชีวิต *</label>
                  <input
                    {...register('deceasedName', { 
                      required: 'กรุณากรอกชื่อผู้เสียชีวิต'
                    })}
                    className="input"
                    placeholder="ชื่อ-นามสกุล ผู้เสียชีวิต"
                  />
                  {errors.deceasedName && (
                    <p className="text-sm text-red-500 mt-1">{errors.deceasedName.message}</p>
                  )}
                </div>

                <div>
                  <label className="label">รายละเอียดความสัมพันธ์</label>
                  <input
                    {...register('relationshipNote')}
                    className="input"
                    placeholder="เช่น บิดาของสมาชิก, มารดาของสมาชิก"
                  />
                </div>
              </>
            )}

            <div>
              <label className="label">วันที่รายงาน *</label>
              <Controller
                name="reportedDate"
                control={control}
                rules={{ required: 'กรุณากรอกวันที่รายงาน' }}
                render={({ field }) => (
                  <ThaiDatePicker
                    value={field.value}
                    onChange={field.onChange}
                    placeholder="เลือกวันที่รายงาน"
                    returnString
                  />
                )}
              />
              {errors.reportedDate && (
                <p className="text-sm text-red-500 mt-1">{errors.reportedDate.message}</p>
              )}
            </div>

            <div>
              <label className="label">วันที่เสียชีวิต *</label>
              <Controller
                name="deathDate"
                control={control}
                rules={{ required: 'กรุณากรอกวันที่เสียชีวิต' }}
                render={({ field }) => (
                  <ThaiDatePicker
                    value={field.value}
                    onChange={field.onChange}
                    placeholder="เลือกวันที่เสียชีวิต"
                    returnString
                  />
                )}
              />
              {errors.deathDate && (
                <p className="text-sm text-red-500 mt-1">{errors.deathDate.message}</p>
              )}
            </div>

            <div className="md:col-span-2">
              <label className="label">สาเหตุการเสียชีวิต</label>
              <input
                {...register('causeOfDeath')}
                className="input"
                placeholder="เช่น โรคประจำตัว, อุบัติเหตุ"
              />
            </div>
          </div>
        </div>

        {/* การคำนวณเงินช่วยเหลือ */}
        <div className="card p-6 bg-blue-50 border-blue-200">
          <h3 className="font-semibold text-blue-900 mb-4 flex items-center gap-2">
            <AlertCircle className="w-5 h-5" />
            ยอดเงินช่วยเหลือ (คำนวณอัตโนมัติ)
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="p-4 bg-white rounded-xl">
              <p className="text-sm text-slate-500">อัตราพื้นฐาน</p>
              <p className="text-xl font-bold text-slate-900">{formatCurrency(baseAmount)}</p>
              <p className="text-xs text-slate-400">ตามมติคณะกรรมการ</p>
            </div>
            <div className="p-4 bg-white rounded-xl">
              <p className="text-sm text-slate-500">เปอร์เซ็นต์การจ่าย</p>
              <p className="text-xl font-bold text-slate-900">{percent}%</p>
              <p className="text-xs text-slate-400">
                {watchDeceasedType === DeceasedType.MEMBER ? 'ตัวสมาชิกเอง' : 'บิดา/มารดา/บุตร'}
              </p>
            </div>
            <div className="p-4 bg-primary-100 rounded-xl">
              <p className="text-sm text-primary-700">ยอดที่จะได้รับ</p>
              <p className="text-2xl font-bold text-primary-700">{formatCurrency(calculated)}</p>
              <p className="text-xs text-primary-600">ก่อนหักรายการอื่นๆ</p>
            </div>
          </div>
        </div>

        {/* Beneficiary Information */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ผู้รับผลประโยชน์</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="label">ชื่อผู้รับผลประโยชน์หลัก *</label>
              <input
                {...register('mainBeneficiary', { required: 'กรุณากรอกชื่อผู้รับผลประโยชน์' })}
                className="input"
                placeholder="ชื่อ-นามสกุล"
              />
              {errors.mainBeneficiary && (
                <p className="text-sm text-red-500 mt-1">{errors.mainBeneficiary.message}</p>
              )}
            </div>

            <div>
              <label className="label">เบอร์โทรศัพท์ผู้รับผลประโยชน์</label>
              <input
                {...register('beneficiaryPhone')}
                className="input"
                placeholder="08x-xxx-xxxx"
              />
            </div>
          </div>
        </div>

        {/* Deductions */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">รายการหักเงิน</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="label">รายการหักอื่นๆ (บาท)</label>
              <input
                {...register('otherDeductions', { valueAsNumber: true })}
                type="number"
                className="input"
                placeholder="0"
              />
              <p className="text-xs text-slate-400 mt-1">เช่น ค่าใช้จ่ายที่ต้องหัก, หนี้สินคงค้าง</p>
            </div>

            <div className="flex items-end">
              <div className="p-4 bg-emerald-50 rounded-xl w-full border border-emerald-200">
                <p className="text-sm text-emerald-700">ยอดสุทธิที่จะจ่าย</p>
                <p className="text-2xl font-bold text-emerald-700">
                  {formatCurrency(calculated - (watch('otherDeductions') || 0))}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Actions */}
        <div className="flex justify-end gap-3">
          <Link href="/death-claims" className="btn-secondary">
            ยกเลิก
          </Link>
          <button
            type="submit"
            className="btn-primary"
            disabled={createMutation.isPending}
          >
            {createMutation.isPending ? (
              <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <>
                <Save size={18} />
                บันทึก
              </>
            )}
          </button>
        </div>
      </form>
    </motion.div>
  );
}

