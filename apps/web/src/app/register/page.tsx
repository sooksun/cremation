'use client';

import { Suspense, useCallback, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';
import { useForm, useFieldArray, Controller } from 'react-hook-form';
import { motion } from 'framer-motion';
import {
  ArrowLeft,
  Download,
  FileText,
  Printer,
  ExternalLink,
} from 'lucide-react';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import { MembershipRegisterPrint } from '@/components/MembershipRegisterPrint';
import { exportMembershipRegisterPdf, printMembershipRegisterPdf } from '@/lib/membership-register-pdf';
import { showError, showSuccess } from '@/lib/toast';
import { api } from '@/lib/api';
import {
  MEMBERSHIP_TYPE_CONFIG,
  createDefaultForm,
  type AddressFields,
  type MembershipRegisterForm,
  type MembershipType,
} from '@/lib/membership-register';
import dayjs from 'dayjs';

function AddressFieldsSection({
  prefix,
  register,
  title,
}: {
  prefix: 'registeredAddress' | 'contactAddress';
  register: ReturnType<typeof useForm<MembershipRegisterForm>>['register'];
  title: string;
}) {
  const fields: { key: keyof AddressFields; label: string; className?: string }[] = [
    { key: 'houseNo', label: 'บ้านเลขที่' },
    { key: 'moo', label: 'หมู่ที่' },
    { key: 'road', label: 'ถนน' },
    { key: 'soi', label: 'ซอย' },
    { key: 'subdistrict', label: 'ตำบล' },
    { key: 'district', label: 'อำเภอ' },
    { key: 'province', label: 'จังหวัด' },
    { key: 'zip', label: 'รหัสไปรษณีย์' },
    { key: 'phone', label: 'เบอร์โทร', className: 'md:col-span-2' },
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <p className="md:col-span-2 lg:col-span-3 text-sm font-medium text-slate-700">{title}</p>
      {fields.map((f) => (
        <div key={f.key} className={f.className}>
          <label className="label">{f.label}</label>
          <input className="input" autoComplete="off" {...register(`${prefix}.${f.key}`)} />
        </div>
      ))}
    </div>
  );
}

function RegisterForm() {
  const searchParams = useSearchParams();
  const initialType = (searchParams.get('type') === 'contributory' ? 'contributory' : 'ordinary') as MembershipType;

  const [isExporting, setIsExporting] = useState(false);
  const [isPrinting, setIsPrinting] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showPreview, setShowPreview] = useState(false);

  const { register, handleSubmit, control, watch, setValue, getValues } = useForm<MembershipRegisterForm>({
    defaultValues: createDefaultForm(initialType),
  });

  const memberType = watch('type');
  const config = MEMBERSHIP_TYPE_CONFIG[memberType];

  const bloodRelativesArray = useFieldArray({ control, name: 'bloodRelatives' });
  const beneficiariesArray = useFieldArray({ control, name: 'beneficiaries' });

  const switchType = (type: MembershipType) => {
    const current = getValues();
    setValue('type', type);
    if (!current.governmentAgency) return;
  };

  const handleBirthDateChange = (date: string | null) => {
    if (date) {
      const age = dayjs().diff(dayjs(date), 'year');
      if (age >= 0 && age < 120) setValue('age', String(age));
    }
  };

  const handleExportPdf = useCallback(async () => {
    setIsExporting(true);
    try {
      const typeLabel = memberType === 'ordinary' ? 'สามัญ' : 'สมทบ';
      await exportMembershipRegisterPdf(getValues(), `ใบสมัครฌาปนกิจ-${typeLabel}.pdf`);
      showSuccess('ดาวน์โหลดใบสมัครสำเร็จ');
    } catch {
      showError('เกิดข้อผิดพลาดในการสร้าง PDF');
    } finally {
      setIsExporting(false);
    }
  }, [getValues, memberType]);

  const handlePrint = useCallback(async () => {
    setIsPrinting(true);
    try {
      await printMembershipRegisterPdf(getValues());
    } catch {
      showError('เกิดข้อผิดพลาดในการพิมพ์');
    } finally {
      setIsPrinting(false);
    }
  }, [getValues]);

  const onSubmit = async (data: MembershipRegisterForm) => {
    setIsSubmitting(true);
    try {
      const response = await api.post('/member-applications/submit', {
        type: data.type,
        governmentAgency: data.governmentAgency,
        memberNo: data.memberNo || undefined,
        applicationDate: data.applicationDate || undefined,
        fullName: data.fullName,
        birthDate: data.birthDate || undefined,
        nationalId: data.nationalId || undefined,
        registeredAddress: data.registeredAddress,
        contactAddress: data.contactAddress,
        maritalStatus: data.maritalStatus,
        spouseName: data.spouseName || undefined,
        bloodRelatives: data.bloodRelatives,
        beneficiaries: data.beneficiaries,
      });
      showSuccess(
        `${response.data.message} (เลขสมาชิก: ${response.data.memberNo})`,
      );
      await handleExportPdf();
    } catch (err: unknown) {
      const message =
        (err as { response?: { data?: { message?: string } } })?.response?.data?.message ||
        'ส่งใบสมัครไม่สำเร็จ';
      showError(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const formData = watch();

  return (
    <>
    <div className="min-h-screen bg-slate-50 print:hidden">
      <div className="h-1 bg-gradient-to-r from-accent-500 via-accent-400 to-accent-500" />

      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200 shadow-sm">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">
          <Link href="/" className="flex items-center gap-2 text-slate-600 hover:text-primary-700 text-sm">
            <ArrowLeft size={18} />
            หน้าหลัก
          </Link>
          <div className="flex items-center gap-2">
            <Image src="/logo.png" alt="" width={32} height={32} className="object-contain" />
            <span className="font-display font-semibold text-sm text-slate-900 hidden sm:inline">
              ใบสมัครสมาชิกฌาปนกิจ
            </span>
          </div>
          <a
            href={config.blankPdf}
            target="_blank"
            rel="noopener noreferrer"
            className="btn-secondary text-sm py-2 px-3"
          >
            <FileText size={16} />
            <span className="hidden sm:inline">แบบฟอร์มว่าง</span>
          </a>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 sm:px-6 py-8 space-y-6">
        <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}>
          <h1 className="font-display text-2xl font-bold text-slate-900">กรอกใบสมัครออนไลน์</h1>
          <p className="text-slate-600 mt-1 text-sm">
            กรอกข้อมูลตามแบบฟอร์ม แล้วดาวน์โหลด PDF นำไปลงนามและส่งให้กรรมการรับสมัคร
          </p>
        </motion.div>

        <div className="flex flex-wrap gap-2">
          {(['ordinary', 'contributory'] as MembershipType[]).map((t) => {
            const c = MEMBERSHIP_TYPE_CONFIG[t];
            const active = memberType === t;
            return (
              <button
                key={t}
                type="button"
                onClick={() => switchType(t)}
                className={`px-4 py-2.5 rounded-xl text-sm font-medium transition-all border ${
                  active
                    ? 'bg-primary-600 text-white border-primary-600 shadow-md'
                    : 'bg-white text-slate-700 border-slate-200 hover:border-primary-300'
                }`}
              >
                {c.memberClass}
              </button>
            );
          })}
        </div>

        <div className="card p-4 bg-primary-50 border-primary-100">
          <p className="font-semibold text-primary-900 text-sm">{config.title}</p>
          <p className="text-primary-700 text-xs mt-1">{config.subtitle}</p>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <section className="card p-6 space-y-4">
            <h2 className="font-semibold text-slate-900">ข้อมูลการสมัคร</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="md:col-span-2">
                <label className="label">ส่วนราชการ / โรงเรียน *</label>
                <input
                  className="input"
                  {...register('governmentAgency', { required: true })}
                  placeholder="เช่น โรงเรียนแม่ฟ้าหลวง"
                />
                <p className="text-xs text-slate-500 mt-1">
                  ระบุชื่อโรงเรียนให้ตรงกับทะเบียนในระบบ (ไม่รองรับชื่อย่อหรือค้นหาบางส่วน)
                </p>
              </div>
              <div>
                <label className="label">วันที่สมัคร</label>
                <Controller
                  name="applicationDate"
                  control={control}
                  render={({ field }) => (
                    <ThaiDatePicker value={field.value} onChange={(d) => field.onChange(d?.format('YYYY-MM-DD') ?? '')} />
                  )}
                />
              </div>
              <div>
                <label className="label">เลขทะเบียนสมาชิก (ถ้ามี)</label>
                <input className="input" {...register('memberNo')} placeholder="สำหรับเจ้าหน้าที่กรอก" />
              </div>
            </div>
          </section>

          <section className="card p-6 space-y-4">
            <h2 className="font-semibold text-slate-900">ข้อมูลส่วนตัว</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              <div className="md:col-span-2 lg:col-span-3">
                <label className="label">ชื่อ-นามสกุล *</label>
                <input className="input" {...register('fullName', { required: true })} />
              </div>
              <div>
                <label className="label">วันเกิด</label>
                <Controller
                  name="birthDate"
                  control={control}
                  render={({ field }) => (
                    <ThaiDatePicker
                      value={field.value}
                      onChange={(d) => {
                        const iso = d?.format('YYYY-MM-DD') ?? '';
                        field.onChange(iso);
                        handleBirthDateChange(iso || null);
                      }}
                    />
                  )}
                />
              </div>
              <div>
                <label className="label">อายุ (ปี)</label>
                <input className="input" type="number" min={1} max={120} {...register('age')} />
              </div>
              <div>
                <label className="label">เลขประจำตัวประชาชน</label>
                <input className="input" maxLength={13} {...register('nationalId')} />
              </div>
              <div className="md:col-span-2 lg:col-span-3 flex flex-wrap gap-6 items-center">
                <span className="label mb-0">สถานภาพ</span>
                <label className="flex items-center gap-2 text-sm">
                  <input type="radio" value="single" {...register('maritalStatus')} />
                  โสด
                </label>
                <label className="flex items-center gap-2 text-sm">
                  <input type="radio" value="married" {...register('maritalStatus')} />
                  มีคู่สมรส
                </label>
              </div>
              {watch('maritalStatus') === 'married' && (
                <div className="md:col-span-2">
                  <label className="label">ชื่อคู่สมรส</label>
                  <input className="input" {...register('spouseName')} />
                </div>
              )}
            </div>
          </section>

          <section className="card p-6">
            <h2 className="font-semibold text-slate-900 mb-4">ที่อยู่</h2>
            <div className="space-y-6">
              <AddressFieldsSection prefix="registeredAddress" register={register} title="ที่อยู่ตามทะเบียนราษฎร" />
              <hr className="border-slate-100" />
              <AddressFieldsSection prefix="contactAddress" register={register} title="ที่อยู่ที่สามารถติดต่อได้" />
            </div>
          </section>

          <section className="card p-6 space-y-4">
            <h2 className="font-semibold text-slate-900">บุคคลที่มีความเกี่ยวข้องทางสายเลือด (7 รายการ)</h2>
            <p className="text-xs text-slate-500">บิดา/มารดา/สามี/ภรรยา/บุตร/ธิดา ตามแบบฟอร์ม</p>
            {bloodRelativesArray.fields.map((field, i) => (
              <div key={field.id} className="grid grid-cols-1 md:grid-cols-2 gap-3 p-3 bg-slate-50 rounded-xl">
                <div>
                  <label className="label">ลำดับ {i + 1} — ชื่อ-สกุล</label>
                  <input className="input" {...register(`bloodRelatives.${i}.name`)} />
                </div>
                <div>
                  <label className="label">เกี่ยวข้องเป็น</label>
                  <input className="input" {...register(`bloodRelatives.${i}.relationship`)} placeholder="เช่น บิดา, มารดา" />
                </div>
              </div>
            ))}
          </section>

          <section className="card p-6 space-y-4">
            <h2 className="font-semibold text-slate-900">ผู้รับมอบเงินสงเคราะห์ศพ (3 รายการ)</h2>
            {beneficiariesArray.fields.map((field, i) => (
              <div key={field.id} className="p-4 border border-slate-200 rounded-xl space-y-3">
                <p className="font-medium text-sm text-primary-800">ลำดับ {i + 1}</p>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                  <div>
                    <label className="label">ชื่อ-สกุล</label>
                    <input className="input" autoComplete="off" {...register(`beneficiaries.${i}.name`)} />
                  </div>
                  <div>
                    <label className="label">เกี่ยวข้องเป็น</label>
                    <input className="input" {...register(`beneficiaries.${i}.relationship`)} />
                  </div>
                  <div className="md:col-span-2">
                    <label className="label">เลขประจำตัวประชาชน</label>
                    <input className="input" maxLength={13} {...register(`beneficiaries.${i}.nationalId`)} />
                  </div>
                  <div>
                    <label className="label">บ้านเลขที่</label>
                    <input className="input" {...register(`beneficiaries.${i}.houseNo`)} />
                  </div>
                  <div>
                    <label className="label">หมู่ที่</label>
                    <input className="input" {...register(`beneficiaries.${i}.moo`)} />
                  </div>
                  <div>
                    <label className="label">ถนน</label>
                    <input className="input" {...register(`beneficiaries.${i}.road`)} />
                  </div>
                  <div>
                    <label className="label">ซอย</label>
                    <input className="input" {...register(`beneficiaries.${i}.soi`)} />
                  </div>
                  <div>
                    <label className="label">ตำบล</label>
                    <input className="input" {...register(`beneficiaries.${i}.subdistrict`)} />
                  </div>
                  <div>
                    <label className="label">อำเภอ</label>
                    <input className="input" autoComplete="off" {...register(`beneficiaries.${i}.district`)} />
                  </div>
                  <div>
                    <label className="label">จังหวัด</label>
                    <input className="input" autoComplete="off" {...register(`beneficiaries.${i}.province`)} />
                  </div>
                  <div>
                    <label className="label">รหัสไปรษณีย์</label>
                    <input className="input" {...register(`beneficiaries.${i}.zip`)} />
                  </div>
                  <div>
                    <label className="label">เบอร์โทร</label>
                    <input className="input" {...register(`beneficiaries.${i}.phone`)} />
                  </div>
                  <div>
                    <label className="label">บุคคลที่ติดต่อได้</label>
                    <input className="input" {...register(`beneficiaries.${i}.contactPerson`)} />
                  </div>
                  <div>
                    <label className="label">เบอร์โทรผู้ติดต่อ</label>
                    <input className="input" {...register(`beneficiaries.${i}.contactPhone`)} />
                  </div>
                </div>
              </div>
            ))}
          </section>

          <section className="card p-6 space-y-4">
            <h2 className="font-semibold text-slate-900">ลายมือชื่อผู้สมัคร</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="label">ชื่อสำหรับลงนาม (พิมพ์ชื่อ)</label>
                <input className="input" {...register('applicantSignatureName')} />
              </div>
              <div>
                <label className="label">วันที่ลงนาม</label>
                <Controller
                  name="applicantSignatureDate"
                  control={control}
                  render={({ field }) => (
                    <ThaiDatePicker value={field.value} onChange={(d) => field.onChange(d?.format('YYYY-MM-DD') ?? '')} />
                  )}
                />
              </div>
            </div>
            <p className="text-xs text-slate-500">
              ส่วนคำรับรองผู้บังคับบัญชาและกรรมการรับสมัคร จะปรากฏใน PDF เป็นช่องว่างสำหรับลงนามภายหลัง
            </p>
          </section>

          <div className="flex flex-col sm:flex-row gap-3 sticky bottom-4 z-30">
            <button
              type="button"
              onClick={() => setShowPreview((v) => !v)}
              className="btn-secondary flex-1"
            >
              <ExternalLink size={18} />
              {showPreview ? 'ซ่อนตัวอย่าง' : 'ดูตัวอย่าง'}
            </button>
            <button
              type="button"
              onClick={handlePrint}
              disabled={isPrinting || isExporting}
              className="btn-secondary flex-1"
            >
              {isPrinting ? (
                <div className="w-5 h-5 border-2 border-slate-300 border-t-slate-600 rounded-full animate-spin" />
              ) : (
                <>
                  <Printer size={18} />
                  พิมพ์
                </>
              )}
            </button>
            <button
              type="submit"
              disabled={isExporting || isPrinting || isSubmitting}
              className="btn-primary flex-1"
            >
              {isSubmitting || isExporting ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <Download size={18} />
                  ส่งใบสมัครและดาวน์โหลด PDF
                </>
              )}
            </button>
          </div>
        </form>

        {showPreview && (
          <section className="register-print-preview card p-4 overflow-x-auto print:p-0 print:shadow-none print:border-0">
            <p className="text-sm text-slate-500 mb-4 print:hidden">ตัวอย่างใบสมัครก่อนดาวน์โหลด</p>
            <MembershipRegisterPrint data={formData} />
          </section>
        )}

      </main>
    </div>
    </>
  );
}

export default function RegisterPage() {
  return (
    <Suspense
      fallback={
        <div className="min-h-screen flex items-center justify-center">
          <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      }
    >
      <RegisterForm />
    </Suspense>
  );
}