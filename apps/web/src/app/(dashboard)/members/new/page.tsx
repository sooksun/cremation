'use client';

import { useRouter } from 'next/navigation';
import { useQuery, useMutation } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Save, Plus, Trash2 } from 'lucide-react';
import { useForm, useFieldArray, Controller } from 'react-hook-form';
import { showSuccess, showError } from '@/lib/toast';
import Link from 'next/link';
import { api, type School, type MemberType, type Group } from '@/lib/api';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';

interface MemberForm {
  memberNo: string;
  schoolId: string;
  memberTypeId: string;
  groupId?: string;
  firstName: string;
  lastName: string;
  idCardNo?: string;
  birthDate?: string;
  address?: string;
  phone?: string;
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
      joinDate: new Date().toISOString().split('T')[0],
      beneficiaries: [],
    },
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'beneficiaries',
  });

  const { data: schools } = useQuery<School[]>({
    queryKey: ['schools'],
    queryFn: async () => {
      const response = await api.get('/schools');
      return response.data;
    },
  });

  const { data: memberTypes } = useQuery<MemberType[]>({
    queryKey: ['member-types'],
    queryFn: async () => {
      const response = await api.get('/member-types');
      return response.data;
    },
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
    // Clean up empty optional fields
    if (!data.groupId) delete data.groupId;
    if (!data.idCardNo) delete data.idCardNo;
    if (!data.birthDate) delete data.birthDate;
    if (!data.address) delete data.address;
    if (!data.phone) delete data.phone;
    
    createMutation.mutate(data);
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
            กรอกข้อมูลสมาชิกและผู้รับผลประโยชน์
          </p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ข้อมูลพื้นฐาน</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div>
              <label className="label">เลขทะเบียนสมาชิก *</label>
              <input
                {...register('memberNo', { required: 'กรุณากรอกเลขทะเบียน' })}
                className="input"
                placeholder="M0001"
              />
              {errors.memberNo && (
                <p className="text-sm text-red-500 mt-1">{errors.memberNo.message}</p>
              )}
            </div>

            <div>
              <label className="label">โรงเรียน *</label>
              <select {...register('schoolId', { required: 'กรุณาเลือกโรงเรียน' })} className="input">
                <option value="">เลือกโรงเรียน</option>
                {schools?.map((school) => (
                  <option key={school.id} value={school.id}>{school.name}</option>
                ))}
              </select>
              {errors.schoolId && (
                <p className="text-sm text-red-500 mt-1">{errors.schoolId.message}</p>
              )}
            </div>

            <div>
              <label className="label">ประเภทสมาชิก *</label>
              <select {...register('memberTypeId', { required: 'กรุณาเลือกประเภท' })} className="input">
                <option value="">เลือกประเภท</option>
                {memberTypes?.map((type) => (
                  <option key={type.id} value={type.id}>{type.name}</option>
                ))}
              </select>
              {errors.memberTypeId && (
                <p className="text-sm text-red-500 mt-1">{errors.memberTypeId.message}</p>
              )}
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
              <label className="label">ชื่อ *</label>
              <input
                {...register('firstName', { required: 'กรุณากรอกชื่อ' })}
                className="input"
                placeholder="ชื่อ"
              />
              {errors.firstName && (
                <p className="text-sm text-red-500 mt-1">{errors.firstName.message}</p>
              )}
            </div>

            <div>
              <label className="label">นามสกุล *</label>
              <input
                {...register('lastName', { required: 'กรุณากรอกนามสกุล' })}
                className="input"
                placeholder="นามสกุล"
              />
              {errors.lastName && (
                <p className="text-sm text-red-500 mt-1">{errors.lastName.message}</p>
              )}
            </div>

            <div>
              <label className="label">เลขบัตรประชาชน</label>
              <input
                {...register('idCardNo')}
                className="input"
                placeholder="x-xxxx-xxxxx-xx-x"
              />
            </div>

            <div>
              <label className="label">วันเกิด</label>
              <Controller
                name="birthDate"
                control={control}
                render={({ field }) => (
                  <ThaiDatePicker
                    value={field.value ? dayjs(field.value) : null}
                    onChange={(date) => field.onChange(date ? date.format('YYYY-MM-DD') : '')}
                    placeholder="เลือกวันเกิด"
                    style={{ width: '100%' }}
                  />
                )}
              />
            </div>

            <div>
              <label className="label">วันที่สมัครสมาชิก *</label>
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
              <p className="text-sm text-slate-500 mt-1 ml-6">
                สมาชิกส่วนใหญ่จะหักผ่านเงินเดือนจากสำนักงานเขตพื้นที่ (ประมาณ 90%)
              </p>
            </div>

            <div>
              <label className="label">เบอร์โทรศัพท์</label>
              <input
                {...register('phone')}
                className="input"
                placeholder="08x-xxx-xxxx"
              />
            </div>

            <div className="md:col-span-2">
              <label className="label">ที่อยู่</label>
              <textarea
                {...register('address')}
                className="input"
                rows={2}
                placeholder="ที่อยู่"
              />
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
