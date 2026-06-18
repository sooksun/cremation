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

type DeathClaimType = 'MEMBER_DEATH' | 'PROTECTED_DEATH';

enum DeceasedType {
  MEMBER = 'MEMBER',
  PARENT = 'PARENT',
  CHILD = 'CHILD',
  SPOUSE = 'SPOUSE',
}

const deceasedTypeLabels: Record<DeceasedType, string> = {
  [DeceasedType.MEMBER]: 'ตัวสมาชิกเอง (เก็บ 100 บาท/คน)',
  [DeceasedType.PARENT]: 'บิดา/มารดาที่คุ้มครอง (เก็บ 50 บาท/คน)',
  [DeceasedType.CHILD]: 'บุตร/ธิดาที่คุ้มครอง (เก็บ 50 บาท/คน)',
  [DeceasedType.SPOUSE]: 'คู่สมรสที่คุ้มครอง (เก็บ 50 บาท/คน)',
};

const deceasedTypeToRelationship: Partial<Record<DeceasedType, string>> = {
  [DeceasedType.PARENT]: 'PARENT',
  [DeceasedType.CHILD]: 'CHILD',
  [DeceasedType.SPOUSE]: 'SPOUSE',
};

function toClaimType(deceasedType: DeceasedType): DeathClaimType {
  return deceasedType === DeceasedType.MEMBER ? 'MEMBER_DEATH' : 'PROTECTED_DEATH';
}

interface DeathClaimForm {
  memberId: string;
  schoolId: string;
  reportedDate: string;
  deathDate: string;
  causeOfDeath?: string;
  deceasedType: DeceasedType;
  deceasedName?: string;
  protectedPersonId?: string;
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
  const watchMemberId = watch('memberId');
  const watchDeceasedType = watch('deceasedType');
  const watchOtherDeductions = watch('otherDeductions');

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

  const { data: memberDetail } = useQuery<Member>({
    queryKey: ['member', watchMemberId],
    queryFn: async () => {
      const response = await api.get(`/members/${watchMemberId}`);
      return response.data;
    },
    enabled: !!watchMemberId,
  });

  const activeProtectedPersons =
    memberDetail?.protectedPersons?.filter((p) => p.isActive) ?? [];
  const matchingProtectedPersons =
    watchDeceasedType === DeceasedType.MEMBER
      ? []
      : activeProtectedPersons.filter(
          (p) => p.relationship === deceasedTypeToRelationship[watchDeceasedType],
        );

  const { data: calcPreview } = useQuery({
    queryKey: ['death-calc-preview', watchDeceasedType, watchMemberId, watchOtherDeductions],
    queryFn: async () => {
      const params = new URLSearchParams({
        claimType: toClaimType(watchDeceasedType),
      });
      if (watchDeceasedType === DeceasedType.MEMBER && watchMemberId) {
        params.append('excludeMemberId', watchMemberId);
      }
      if (watchOtherDeductions) params.append('otherDeductions', String(watchOtherDeductions));
      const response = await api.get(`/death-claims/preview-calculation?${params}`);
      return response.data;
    },
    enabled: !!watchMemberId,
  });

  const createMutation = useMutation({
    mutationFn: (data: DeathClaimForm) =>
      api.post('/death-claims', {
        memberId: data.memberId,
        schoolId: data.schoolId,
        claimType: toClaimType(data.deceasedType),
        deceasedType: data.deceasedType,
        deceasedName: data.deceasedName,
        protectedPersonId: data.protectedPersonId,
        relationshipNote: data.relationshipNote,
        reportedDate: data.reportedDate,
        deathDate: data.deathDate,
        causeOfDeath: data.causeOfDeath,
        mainBeneficiary: data.mainBeneficiary,
        beneficiaryPhone: data.beneficiaryPhone,
        otherDeductions: data.otherDeductions || 0,
      }),
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
    setValue('protectedPersonId', '');
    setValue('deceasedName', '');
    const fullName = `${member.associationMember?.firstName ?? ''} ${member.associationMember?.lastName ?? ''}`.trim();
    if (watchDeceasedType === DeceasedType.MEMBER && (member as Member & { beneficiaries?: { fullName: string; phone?: string }[] }).beneficiaries?.length) {
      const firstBeneficiary = (member as Member & { beneficiaries: { fullName: string; phone?: string }[] }).beneficiaries[0];
      setValue('mainBeneficiary', firstBeneficiary.fullName);
      if (firstBeneficiary.phone) setValue('beneficiaryPhone', firstBeneficiary.phone);
    } else if (watchDeceasedType !== DeceasedType.MEMBER && fullName) {
      setValue('mainBeneficiary', fullName);
    }
  };

  const onSubmit = (data: DeathClaimForm) => {
    if (!data.memberId) {
      showError('กรุณาเลือกสมาชิก');
      return;
    }
    if (data.deceasedType !== DeceasedType.MEMBER && !data.protectedPersonId && !data.deceasedName?.trim()) {
      showError('กรุณาเลือกหรือกรอกชื่อผู้เสียชีวิตที่คุ้มครอง');
      return;
    }
    createMutation.mutate(data);
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
                    {selectedMember.associationMember?.firstName} {selectedMember.associationMember?.lastName}
                  </p>
                  <p className="text-sm text-slate-500">
                    เลขสมาชิก: {selectedMember.memberNo} • {selectedMember.associationMember?.memberType?.name}
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
                      {member.associationMember?.firstName} {member.associationMember?.lastName}
                    </p>
                    <p className="text-sm text-slate-500">
                      {member.memberNo} • {member.associationMember?.memberType?.name}
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
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
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
                {matchingProtectedPersons.length > 0 ? (
                  <div className="md:col-span-2">
                    <label className="label">เลือกผู้เสียชีวิตจากทะเบียนคุ้มครอง *</label>
                    <select
                      className="input"
                      {...register('protectedPersonId', {
                        onChange: (e) => {
                          const person = matchingProtectedPersons.find((p) => p.id === e.target.value);
                          if (person) {
                            setValue('deceasedName', person.fullName);
                            const memberName = `${memberDetail?.associationMember?.firstName ?? ''} ${memberDetail?.associationMember?.lastName ?? ''}`.trim();
                            if (memberName) setValue('mainBeneficiary', memberName);
                          }
                        },
                      })}
                    >
                      <option value="">— เลือก —</option>
                      {matchingProtectedPersons.map((p) => (
                        <option key={p.id} value={p.id}>
                          {p.fullName}
                        </option>
                      ))}
                    </select>
                    <p className="text-xs text-slate-500 mt-1">
                      จ่ายเงินสงเคราะห์ให้สมาชิกต้นสังกัด ตามระเบียบ ข้อ 20
                    </p>
                  </div>
                ) : (
                  <div>
                    <label className="label">ชื่อผู้เสียชีวิต *</label>
                    <input
                      {...register('deceasedName')}
                      className="input"
                      placeholder="ชื่อ-นามสกุล ผู้เสียชีวิต"
                    />
                  </div>
                )}

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
          {calcPreview ? (
            <>
              <p className="text-sm text-blue-800 mb-3">
                สมาชิกที่ต้องส่งเงิน {calcPreview.payingMemberCount} คน × อัตรา{' '}
                {formatCurrency(calcPreview.collectionRate)}/คน (ตามระเบียบ ข้อ 13)
              </p>
              <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div className="p-4 bg-white rounded-xl">
                  <p className="text-sm text-slate-500">ยอดเก็บรวม</p>
                  <p className="text-xl font-bold text-slate-900">
                    {formatCurrency(calcPreview.grossCollected)}
                  </p>
                </div>
                <div className="p-4 bg-white rounded-xl">
                  <p className="text-sm text-slate-500">เข้ากองทุน (10%)</p>
                  <p className="text-xl font-bold text-amber-700">
                    {formatCurrency(calcPreview.fundReserve)}
                  </p>
                  <p className="text-xs text-slate-400">ข้อ 16</p>
                </div>
                <div className="p-4 bg-white rounded-xl">
                  <p className="text-sm text-slate-500">จ่ายผู้รับ (90%)</p>
                  <p className="text-xl font-bold text-slate-900">
                    {formatCurrency(calcPreview.grossCollected * calcPreview.payoutRatio)}
                  </p>
                </div>
                <div className="p-4 bg-primary-100 rounded-xl">
                  <p className="text-sm text-primary-700">ยอดสุทธิจ่าย</p>
                  <p className="text-2xl font-bold text-primary-700">
                    {formatCurrency(calcPreview.netToPay)}
                  </p>
                  <p className="text-xs text-primary-600">หลังหักรายการอื่นๆ</p>
                </div>
              </div>
            </>
          ) : (
            <p className="text-sm text-blue-700">เลือกสมาชิกเพื่อดูการคำนวณตามระเบียบ</p>
          )}
        </div>

        {/* Beneficiary Information */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">
            {watchDeceasedType === DeceasedType.MEMBER ? 'ผู้รับผลประโยชน์' : 'ผู้รับเงินสงเคราะห์ (สมาชิกต้นสังกัด)'}
          </h3>
          {watchDeceasedType !== DeceasedType.MEMBER && (
            <p className="text-sm text-slate-500 mb-4">
              กรณีญาติที่คุ้มครองเสียชีวิต เงินสงเคราะห์จ่ายให้สมาชิกตามระเบียบ ข้อ 20
            </p>
          )}
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
                  {formatCurrency(calcPreview?.netToPay ?? 0)}
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

