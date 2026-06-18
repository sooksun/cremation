'use client';

import { forwardRef } from 'react';
import { formatThaiDate, formatThaiDateShort } from '@/components/ThaiDatePicker';
import {
  MEMBERSHIP_TYPE_CONFIG,
  formatAddressLine,
  formatBeneficiaryAddress,
  type Beneficiary,
  type MembershipRegisterForm,
} from '@/lib/membership-register';

interface MembershipRegisterPrintProps {
  data: MembershipRegisterForm;
}

function Field({ label, value }: { label: string; value?: string }) {
  const display = value?.trim() || '................................';
  return (
    <p className="text-[11px] leading-relaxed">
      <span className="text-slate-600">{label}</span> {display}
    </p>
  );
}

function BeneficiaryBlock({ ben, index }: { ben: Beneficiary; index: number }) {
  return (
    <div className="mb-3 pl-2 border-b border-dashed border-slate-200 pb-2 last:border-0">
      <p className="text-[11px] font-medium">
        {index + 1}. {ben.name || '........................................................'}
        {' '}เกี่ยวข้องเป็น {ben.relationship || '..........................................'}
      </p>
      <p className="text-[10px] pl-4 mt-0.5">
        เลขประจำตัวประชาชน {ben.nationalId || '........................................................'}
      </p>
      <p className="text-[10px] pl-4">{formatBeneficiaryAddress(ben)}</p>
      <p className="text-[10px] pl-4">
        บุคคลที่สามารถติดต่อได้ {ben.contactPerson || '........................................'}
        {' '}เบอร์โทร {ben.contactPhone || '........................................'}
      </p>
    </div>
  );
}

const pageClass =
  'bg-white text-black p-6 text-[11px] leading-snug box-border';

export const MembershipRegisterPrint = forwardRef<HTMLDivElement, MembershipRegisterPrintProps>(
  function MembershipRegisterPrint({ data }, ref) {
    const config = MEMBERSHIP_TYPE_CONFIG[data.type];
    const [ben1, ben2, ben3] = data.beneficiaries;

    return (
      <div ref={ref} className="membership-register-print">
        {/* หน้า 1 — ตามต้นฉบับ ref1-1.pdf */}
        <div className={pageClass} style={{ width: '210mm' }}>
          <div className="text-right text-[10px] mb-2 text-slate-500">
            เลขทะเบียนสมาชิกอันดับที่ {data.memberNo || '...........................'}
            {' '}เป็นสมาชิกเมื่อ {data.memberSince ? formatThaiDateShort(data.memberSince) : '...........................'}
          </div>

          <div className="text-center mb-4">
            <h1 className="text-sm font-bold">{config.title}</h1>
            <p className="text-[11px] mt-1">{config.subtitle}</p>
          </div>

          <Field label="ส่วนราชการ" value={data.governmentAgency} />
          <p className="text-[11px] mt-1">
            วันที่ {data.applicationDate ? formatThaiDate(data.applicationDate) : '................เดือน................พ.ศ................'}
          </p>

          <div className="mt-3 space-y-1">
            <p className="text-[11px]">
              ข้าพเจ้า <span className="font-medium">{data.fullName || '........................................................'}</span>
              {' '}เกิด(ว.ด.ป.) {data.birthDate ? formatThaiDateShort(data.birthDate) : '........................'}
              {' '}อายุ {data.age || '..........'} ปี
            </p>
            <Field label="เลขประจำตัวประชาชน" value={data.nationalId} />
            <Field label="ที่อยู่ตามทะเบียนราษฎร" value={formatAddressLine(data.registeredAddress)} />
            <p className="text-[11px]">
              ข้าพเจ้า{' '}
              {data.maritalStatus === 'single' ? '☑ เป็นโสด  ☐ มีคู่สมรส' : '☐ เป็นโสด  ☑ มีคู่สมรส'}
              {data.maritalStatus === 'married' && (
                <> ชื่อ {data.spouseName || '........................................................'}</>
              )}
            </p>
            <p className="text-[11px] mt-2">
              ข้าพเจ้าขอสมัครเข้าเป็น{config.memberClass}ฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง
              โดยได้รับทราบและยินดีปฏิบัติตามเงื่อนไขที่กำหนดไว้
            </p>
            <Field label="ที่อยู่ที่สามารถติดต่อได้" value={formatAddressLine(data.contactAddress)} />
          </div>

          <div className="mt-4">
            <p className="text-[11px] mb-2">
              เพื่อให้เกิดความถูกต้องในการเบิกจ่ายเงินสงเคราะห์ศพตามระเบียบข้อบังคับ
              และหลักการของฌาปนกิจสงเคราะห์ จึงได้ระบุชื่อ-สกุล บุคคลที่มีความเกี่ยวข้องทางสายเลือด
              และหรือมีความเกี่ยวข้องตามกฎหมาย (บิดา/มารดา/สามี/ภรรยา/บุตร/ธิดา) ของข้าพเจ้า ดังนี้
            </p>
            {data.bloodRelatives.map((rel, i) => (
              <p key={i} className="text-[11px] pl-2">
                {i + 1}. {rel.name || '........................................................'}
                {' '}เกี่ยวข้องเป็น {rel.relationship || '..........................................'}
              </p>
            ))}
          </div>

          <div className="mt-4">
            <p className="text-[11px] mb-2">
              เมื่อข้าพเจ้าถึงแก่กรรมในขณะที่ยังเป็นสมาชิกภาพของฌาปนกิจสงเคราะห์ครูอำเภอแม่ฟ้าหลวงอยู่
              ข้าพเจ้าขอมอบเงินสงเคราะห์ศพในส่วนที่จะได้รับตามข้อบังคับของฌาปนกิจสงเคราะห์ครูอำเภอแม่ฟ้าหลวง
              ให้กับผู้มีรายนามเรียงตามลำดับ ดังนี้
            </p>
            {ben1 && <BeneficiaryBlock ben={ben1} index={0} />}
          </div>
        </div>

        {/* หน้า 2 — ผู้รับมอบ 2–3, ลายเซ็น, คำรับรองผู้บังคับบัญชา */}
        <div
          className={`${pageClass} membership-register-page-2`}
          style={{ width: '210mm' }}
        >
          {ben2 && <BeneficiaryBlock ben={ben2} index={1} />}
          {ben3 && <BeneficiaryBlock ben={ben3} index={2} />}

          <div className="mt-10 text-center">
            <p className="text-[11px]">(ลงชื่อ) ........................................................ ผู้สมัคร</p>
            <p className="text-[11px] mt-1">
              ({data.applicantSignatureName || '........................................................'})
            </p>
            <p className="text-[11px] mt-1">
              วันที่ {data.applicantSignatureDate ? formatThaiDate(data.applicantSignatureDate) : '.............................................'}
            </p>
          </div>

          <div className="mt-10">
            <p className="text-[11px] font-semibold text-center mb-4 whitespace-nowrap">
              คำรับรองของผู้บังคับบัญชา
            </p>
            <p className="text-[11px]">ข้าพเจ้าผู้มีนามข้างท้ายนี้ขอรับรองว่า</p>
            <ol className="text-[10px] list-decimal list-inside space-y-1 mt-2">
              <li>ผู้สมัครรายนี้เป็นผู้มีคุณสมบัติตามระเบียบว่าด้วยการเป็นสมาชิกของฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง</li>
              <li>{config.supervisorCertLine2}</li>
              <li>
                ผู้สมัครตกลงให้เก็บเงินสงเคราะห์รายกรณีเสียชีวิตของสมาชิกสามัญ และสมาชิกสมทบ บิดา มารดา
                และบุตร ธิดาสายตรงของสมาชิก ตามระเบียบข้อบังคับของกองทุนฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง
              </li>
              <li>
                ข้อความทั้งหมดตามที่ผู้สมัครได้กล่าวไว้นั้นเป็นความจริงทุกประการ และผู้สมัครได้ลงชื่อต่อหน้าคณะกรรมการ
              </li>
            </ol>
            <div className="mt-8 text-center space-y-1">
              <p className="text-[11px]">ผู้บังคับบัญชารับรอง ........................................................</p>
              <p className="text-[11px]">(........................................................)</p>
              <p className="text-[11px]">ตำแหน่ง ........................................................</p>
              <p className="text-[10px] text-slate-600">(ผู้อำนวยการโรงเรียน หรือรักษาการแทนในตำแหน่ง)</p>
            </div>
            <div className="mt-8 text-center">
              <p className="text-[11px]">ตรวจสอบถูกต้องแล้ว</p>
              <p className="text-[11px] mt-2">(ลงชื่อ) ...................................................... กรรมการรับสมัคร</p>
              <p className="text-[11px]">(.........................................................)</p>
              <p className="text-[11px] mt-1">....../....../......</p>
            </div>
          </div>
        </div>

        <style jsx>{`
          @media screen {
            .membership-register-page-2 {
              margin-top: 1.5rem;
              border-top: 2px dashed #cbd5e1;
              padding-top: 1.5rem;
            }
          }
        `}</style>
      </div>
    );
  },
);