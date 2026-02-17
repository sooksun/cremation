'use client';

import { useParams, useRouter } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Save, Plus, Trash2 } from 'lucide-react';
import { useForm, useFieldArray, Controller } from 'react-hook-form';
import { useEffect } from 'react';
import { showSuccess, showError } from '@/lib/toast';
import Link from 'next/link';
import { api, type School, type MemberType, type Group, type Member } from '@/lib/api';
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
  status?: string;
  salaryDeduction?: boolean;
  beneficiaries: {
    fullName: string;
    relationship: string;
    phone?: string;
  }[];
}

export default function EditMemberPage() {
  const params = useParams();
  const router = useRouter();
  const memberId = params.id as string;

  const { register, handleSubmit, control, reset, formState: { errors } } = useForm<MemberForm>();

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'beneficiaries',
  });

  // Fetch member data
  const { data: member, isLoading: loadingMember } = useQuery<Member & { beneficiaries?: any[] }>({
    queryKey: ['member', memberId],
    queryFn: async () => {
      const response = await api.get(`/members/${memberId}`);
      return response.data;
    },
    enabled: !!memberId,
  });

  // Load form data when member is fetched
  useEffect(() => {
    if (member) {
      const birthDate = member.birthDate ? new Date(member.birthDate).toISOString().split('T')[0] : '';
      const joinDate = member.joinDate ? new Date(member.joinDate).toISOString().split('T')[0] : '';
      const resignDate = member.resignDate ? new Date(member.resignDate).toISOString().split('T')[0] : '';
      const deathDate = member.deathDate ? new Date(member.deathDate).toISOString().split('T')[0] : '';

      reset({
        memberNo: member.memberNo,
        schoolId: member.school.id,
        memberTypeId: member.memberType.id,
        groupId: member.group?.id || '',
        firstName: member.firstName,
        lastName: member.lastName,
        idCardNo: member.idCardNo || '',
        birthDate,
        address: member.address || '',
        phone: member.phone || '',
        joinDate,
        status: member.status,
        salaryDeduction: (member as any).salaryDeduction || false,
        beneficiaries: member.beneficiaries?.map((b: any) => ({
          fullName: b.fullName,
          relationship: b.relationship,
          phone: b.phone || '',
        })) || [],
      });
    }
  }, [member, reset]);

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

  const queryClient = useQueryClient();

  const updateMutation = useMutation({
    mutationFn: (data: Partial<MemberForm>) => api.patch(`/members/${memberId}`, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member', memberId] });
      queryClient.invalidateQueries({ queryKey: ['members'] });
      showSuccess('แก้ไขข้อมูลสมาชิกสำเร็จ');
      router.push(`/members/${memberId}`);
    },
    onError: (error: any) => {
      showError(error.response?.data?.message || 'เกิดข้อผิดพลาด');
    },
  });

  const onSubmit = (data: MemberForm) => {
    // Build update data - only include changed fields
    const updateData: Record<string, any> = {
      memberTypeId: data.memberTypeId,
      firstName: data.firstName,
      lastName: data.lastName,
      status: data.status,
    };

    if (data.groupId && data.groupId.trim() !== '') {
      updateData.groupId = data.groupId;
    } else {
      updateData.groupId = null;
    }

    if (data.idCardNo && data.idCardNo.trim() !== '') {
      updateData.idCardNo = data.idCardNo;
    }
    if (data.birthDate && data.birthDate.trim() !== '') {
      updateData.birthDate = data.birthDate;
    }
    if (data.address && data.address.trim() !== '') {
      updateData.address = data.address;
    }
    if (data.phone && data.phone.trim() !== '') {
      updateData.phone = data.phone;
    }
    if (data.joinDate && data.joinDate.trim() !== '') {
      updateData.joinDate = data.joinDate;
    }

    // Handle status dates
    if (data.status === 'RESIGNED' && member?.resignDate) {
      updateData.resignDate = new Date(member.resignDate).toISOString().split('T')[0];
    }
    if (data.status === 'DECEASED' && member?.deathDate) {
      updateData.deathDate = new Date(member.deathDate).toISOString().split('T')[0];
    }

    console.log('Submitting update data:', updateData);
    updateMutation.mutate(updateData);
  };

  if (loadingMember) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!member) {
    return (
      <div className="text-center py-20">
        <p className="text-lg text-slate-500">ไม่พบข้อมูลสมาชิก</p>
        <Link href="/members" className="btn-secondary mt-4">
          กลับไปรายการสมาชิก
        </Link>
      </div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex items-center gap-4">
        <Link href={`/members/${memberId}`} className="p-2 hover:bg-slate-100 rounded-lg">
          <ArrowLeft size={20} />
        </Link>
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            แก้ไขข้อมูลสมาชิก
          </h1>
          <p className="text-slate-500 mt-1">
            {member.memberNo} - {member.firstName} {member.lastName}
          </p>
        </div>
      </div>

      <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
        {/* Basic Info */}
        <div className="card p-6">
          <h3 className="font-semibold text-slate-900 mb-4">ข้อมูลพื้นฐาน</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div>
              <label className="label">เลขทะเบียนสมาชิก</label>
              <input
                {...register('memberNo')}
                className="input bg-slate-50"
                disabled
                readOnly
              />
              <p className="text-xs text-slate-400 mt-1">ไม่สามารถแก้ไขได้</p>
            </div>

            <div>
              <label className="label">โรงเรียน</label>
              <input
                value={member.school.name}
                className="input bg-slate-50"
                disabled
                readOnly
              />
              <p className="text-xs text-slate-400 mt-1">ไม่สามารถแก้ไขได้</p>
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
                {groups?.filter(g => g.school.id === member.school.id).map((group) => (
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
              <label className="label">วันที่สมัครสมาชิก</label>
              <Controller
                name="joinDate"
                control={control}
                render={({ field }) => (
                  <ThaiDatePicker
                    value={field.value ? dayjs(field.value) : null}
                    onChange={(date) => field.onChange(date ? date.format('YYYY-MM-DD') : '')}
                    placeholder="เลือกวันที่สมัคร"
                    style={{ width: '100%' }}
                  />
                )}
              />
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

            <div>
              <label className="label">สถานะ</label>
              <select {...register('status')} className="input">
                <option value="ACTIVE">ปกติ</option>
                <option value="ARREARS">ค้างชำระ</option>
                <option value="RESIGNED">ลาออก</option>
                <option value="DECEASED">เสียชีวิต</option>
                <option value="SUSPENDED">พักสมาชิก</option>
              </select>
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
          <Link href={`/members/${memberId}`} className="btn-secondary">
            ยกเลิก
          </Link>
          <button
            type="submit"
            className="btn-primary"
            disabled={updateMutation.isPending}
          >
            {updateMutation.isPending ? (
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
