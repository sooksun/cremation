'use client';

import { useRouter } from 'next/navigation';
import { useQuery, useMutation } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Save, Plus, Trash2 } from 'lucide-react';
import { useForm, useFieldArray, Controller } from 'react-hook-form';
import { showSuccess, showError } from '@/lib/toast';
import Link from 'next/link';
import { api, type Group } from '@/lib/api';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

interface AssociationMemberOption {
  id: string;
  firstName: string;
  lastName: string;
  school: { id: string; name: string };
  memberType: { id: string; name: string };
  cremationMember?: { id: string } | null;
}

interface MemberForm {
  associationMemberId: string;
  memberNo?: string;
  groupId?: string;
  joinDate: string;
  salaryDeduction?: boolean;
  beneficiaries: {
    fullName: string;
    relationship: string;
    phone?: string;
  }[];
}

export default function NewMemberPage() {
  const router = useRouter();

  const { register, handleSubmit, control, formState: { errors } } = useForm<MemberForm>({
    defaultValues: {
      associationMemberId: '',
      joinDate: new Date().toISOString().split('T')[0],
      beneficiaries: [],
    },
  });

  const { data: associationMembersRes } = useQuery<{ data: AssociationMemberOption[] }>({
    queryKey: ['association-members-all'],
    queryFn: async () => {
      const res = await api.get('/association-members?limit=500');
      return res.data;
    },
  });
  const associationMembers = associationMembersRes?.data?.filter((am) => !am.cremationMember) ?? [];

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'beneficiaries',
  });

  const { data: groups } = useQuery<Group[]>({
    queryKey: ['groups'],
    queryFn: async () => {
      const response = await api.get('/groups');
      return response.data;
    },
  });

  const createMutation = useMutation({
    mutationFn: (data: MemberForm) => api.post('/members', data),
    onSuccess: () => {
      showSuccess('เพิ่มสมาชิกสำเร็จ');
      router.push('/members');
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const onSubmit = (data: MemberForm) => {
    const payload: Record<string, unknown> = {
      associationMemberId: data.associationMemberId,
      joinDate: data.joinDate,
      salaryDeduction: data.salaryDeduction ?? false,
      beneficiaries: data.beneficiaries,
    };
    if (data.memberNo?.trim()) payload.memberNo = data.memberNo;
    if (data.groupId?.trim()) payload.groupId = data.groupId;
    createMutation.mutate(payload as any);
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link href="/members" className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            เพิ่มสมาชิกใหม่
          </h1>
          <p className="text-slate-500 mt-1">
            เลือกสมาชิกสมาคมที่ต้องการเข้าร่วมฌาปนกิจ และกรอกข้อมูลการเข้าร่วม
          </p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ข้อมูลการเข้าร่วมฌาปนกิจ</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div className="md:col-span-2">
              <label className="label">เลือกสมาชิกสมาคม *</label>
              <select
                {...register('associationMemberId', { required: 'กรุณาเลือกสมาชิกสมาคม' })}
                className="input"
              >
                <option value="">-- เลือกสมาชิกที่ยังไม่ได้เข้าร่วมฌาปนกิจ --</option>
                {associationMembers.map((am) => (
                  <option key={am.id} value={am.id}>
                    {am.firstName} {am.lastName} ({am.school.name} - {am.memberType.name})
                  </option>
                ))}
              </select>
              {errors.associationMemberId && (
                <p className="text-sm text-red-500 mt-1">{errors.associationMemberId.message}</p>
              )}
              {associationMembers.length === 0 && (
                <p className="text-sm text-slate-500 mt-1">ไม่มีสมาชิกสมาคมที่ยังไม่ได้เข้าร่วมฌาปนกิจ หรือให้เพิ่มสมาชิกที่เมนู สมาชิกสมาคม ก่อน</p>
              )}
            </div>

            <div>
              <label className="label">เลขทะเบียนสมาชิกฌาปนกิจ</label>
              <input
                {...register('memberNo')}
                className="input"
                placeholder="เว้นว่างให้ระบบสร้างอัตโนมัติ"
              />
            </div>

            <div>
              <label className="label">กลุ่ม</label>
              <select {...register('groupId')} className="input">
                <option value="">ไม่ระบุกลุ่ม</option>
                {groups?.map((group) => (
                  <option key={group.id} value={group.id}>{group.name}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="label">วันที่สมัครเข้าร่วมฌาปนกิจ *</label>
              <Controller
                name="joinDate"
                control={control}
                rules={{ required: 'กรุณาเลือกวันที่สมัคร' }}
                render={({ field }) => (
                  <ThaiDatePicker
                    value={field.value ? dayjs(field.value) : null}
                    onChange={(date) => field.onChange(date ? date.format('YYYY-MM-DD') : '')}
                    placeholder="เลือกวันที่สมัคร"
                    style={{ width: '100%' }}
                  />
                )}
              />
              {errors.joinDate && (
                <p className="text-sm text-red-500 mt-1">{errors.joinDate.message}</p>
              )}
            </div>

            <div className="md:col-span-2">
              <label className="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  {...register('salaryDeduction')}
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <span className="label mb-0">หักผ่านเงินเดือนจากสำนักงานเขตพื้นที่</span>
              </label>
            </div>
          </div>
        </div>

        {/* Beneficiaries */}
        <div className="card p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-semibold text-slate-900">ผู้รับผลประโยชน์</h3>
            {fields.length < 3 && (
              <button
                type="button"
                onClick={() => append({ fullName: '', relationship: '', phone: '' })}
                className="btn-secondary text-sm"
              >
                <Plus size={16} />
                เพิ่มผู้รับผลประโยชน์
              </button>
            )}
          </div>

          {fields.length === 0 ? (
            <div className="text-center py-8 text-slate-500 border-2 border-dashed border-slate-200 rounded-xl">
              <p>ยังไม่มีผู้รับผลประโยชน์</p>
              <p className="text-sm mt-1">คลิกปุ่ม "เพิ่มผู้รับผลประโยชน์" เพื่อเพิ่ม (สูงสุด 3 คน)</p>
            </div>
          ) : (
            <div className="space-y-4">
              {fields.map((field, index) => (
                <div key={field.id} className="flex gap-4 items-start p-4 bg-slate-50 rounded-xl">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center text-primary-700 font-semibold">
                    {index + 1}
                  </div>
                  <div className="flex-1 grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                      <label className="label">ชื่อ-นามสกุล *</label>
                      <input
                        {...register(`beneficiaries.${index}.fullName`, { required: true })}
                        className="input"
                        placeholder="ชื่อ-นามสกุล"
                      />
                    </div>
                    <div>
                      <label className="label">ความสัมพันธ์ *</label>
                      <input
                        {...register(`beneficiaries.${index}.relationship`, { required: true })}
                        className="input"
                        placeholder="เช่น คู่สมรส, บุตร"
                      />
                    </div>
                    <div>
                      <label className="label">เบอร์โทรศัพท์</label>
                      <input
                        {...register(`beneficiaries.${index}.phone`)}
                        className="input"
                        placeholder="08x-xxx-xxxx"
                      />
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => remove(index)}
                    className="p-2 hover:bg-red-100 rounded-lg text-red-500"
                  >
                    <Trash2 size={18} />
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Actions */}
        <div className="flex justify-end gap-3">
          <Link href="/members" className="btn-secondary">
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
