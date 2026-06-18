'use client';

import { formatThaiDate } from '@/components/ThaiDatePicker';
import {
  DEATH_CLAIM_STATUS_LABELS,
  DEATH_COLLECTION_CHANNEL_LABELS,
  type DeathClaimStatus,
  type DeathCollectionChannel,
  type DocumentChecklistItem,
} from '@/lib/api';

interface DeathClaimPrintProps {
  claim: {
    claimNo: string;
    reportedDate: string;
    deathDate: string;
    causeOfDeath?: string | null;
    mainBeneficiary: string;
    beneficiaryPhone?: string | null;
    claimType?: string;
    deceasedType?: string;
    deceasedName?: string | null;
    relationshipNote?: string | null;
    activeMemberCount: number;
    welfareRate: number;
    totalContribution: number;
    associationSupport: number;
    payoutRatio?: number;
    otherDeductions: number;
    netToPay: number;
    member: {
      memberNo: string;
      joinDate: string;
      associationMember?: {
        firstName: string;
        lastName: string;
        memberType?: { name: string };
      };
    };
    school: { name: string };
    payment?: {
      payDate: string;
      amount: number;
      method: string;
    };
    status?: DeathClaimStatus;
    collectionChannel?: DeathCollectionChannel;
    notifyAuthorityDeadline?: string | null;
    collectionDeadline?: string;
    documentDeadline?: string;
    paymentDeadline?: string;
    collectedAmount?: number;
    documentsComplete?: boolean;
    documentChecklist?: DocumentChecklistItem[];
    approvedAt?: string | null;
    approverName?: string | null;
    approverSignature?: string | null;
  };
}

export function DeathClaimPrint({ claim }: DeathClaimPrintProps) {
  const am = claim.member.associationMember;
  const formatCurrency = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  return (
    <div id="death-claim-print" className="hidden print:block p-8 text-black bg-white">
      <div className="text-center mb-6 border-b pb-4">
        <h1 className="text-xl font-bold">แบบฟอร์มแจ้งเสียชีวิต / คำนวณเงินสงเคราะห์</h1>
        <p className="text-sm mt-1">สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อ.แม่ฟ้าหลวง</p>
        <p className="font-mono mt-2">เลขที่ {claim.claimNo}</p>
      </div>

      <section className="mb-4">
        <h2 className="font-semibold border-b mb-2">ข้อมูลสมาชิก</h2>
        <table className="w-full text-sm">
          <tbody>
            <tr><td className="w-40 py-1">ชื่อ-นามสกุล</td><td>{am ? `${am.firstName} ${am.lastName}` : '-'}</td></tr>
            <tr><td className="py-1">เลขสมาชิก</td><td>{claim.member.memberNo}</td></tr>
            <tr><td className="py-1">โรงเรียน</td><td>{claim.school.name}</td></tr>
            <tr><td className="py-1">ประเภท</td><td>{am?.memberType?.name || '-'}</td></tr>
            <tr><td className="py-1">วันที่สมัคร</td><td>{formatThaiDate(claim.member.joinDate)}</td></tr>
          </tbody>
        </table>
      </section>

      <section className="mb-4">
        <h2 className="font-semibold border-b mb-2">ข้อมูลการเสียชีวิต</h2>
        <table className="w-full text-sm">
          <tbody>
            <tr>
              <td className="w-40 py-1">ประเภทผู้เสียชีวิต</td>
              <td>
                {claim.deceasedType === 'MEMBER'
                  ? 'ตัวสมาชิก'
                  : claim.deceasedType === 'PARENT'
                    ? 'บิดา/มารดาที่คุ้มครอง'
                    : claim.deceasedType === 'CHILD'
                      ? 'บุตร/ธิดาที่คุ้มครอง'
                      : claim.deceasedType === 'SPOUSE'
                        ? 'คู่สมรสที่คุ้มครอง'
                        : claim.claimType === 'PROTECTED_DEATH'
                          ? 'ญาติที่คุ้มครอง'
                          : 'สมาชิก'}
              </td>
            </tr>
            {claim.deceasedName && (
              <tr><td className="py-1">ชื่อผู้เสียชีวิต</td><td>{claim.deceasedName}</td></tr>
            )}
            {claim.relationshipNote && (
              <tr><td className="py-1">ความสัมพันธ์</td><td>{claim.relationshipNote}</td></tr>
            )}
            <tr><td className="w-40 py-1">วันที่รายงาน</td><td>{formatThaiDate(claim.reportedDate)}</td></tr>
            <tr><td className="py-1">วันที่เสียชีวิต</td><td>{formatThaiDate(claim.deathDate)}</td></tr>
            {claim.causeOfDeath && (
              <tr><td className="py-1">สาเหตุ</td><td>{claim.causeOfDeath}</td></tr>
            )}
          </tbody>
        </table>
      </section>

      {(claim.status || claim.collectionDeadline) && (
        <section className="mb-4">
          <h2 className="font-semibold border-b mb-2">สถานะและกำหนดเวลา</h2>
          <table className="w-full text-sm">
            <tbody>
              {claim.status && (
                <tr><td className="w-40 py-1">สถานะ</td><td>{DEATH_CLAIM_STATUS_LABELS[claim.status]}</td></tr>
              )}
              {claim.collectionChannel && (
                <tr><td className="py-1">ช่องทางเก็บเงิน</td><td>{DEATH_COLLECTION_CHANNEL_LABELS[claim.collectionChannel]}</td></tr>
              )}
              {claim.notifyAuthorityDeadline && (
                <tr><td className="py-1">แจ้ง สพป.</td><td>{formatThaiDate(claim.notifyAuthorityDeadline)}</td></tr>
              )}
              {claim.collectionDeadline && (
                <tr><td className="py-1">ครบกำหนดเก็บเงิน</td><td>{formatThaiDate(claim.collectionDeadline)}</td></tr>
              )}
              {claim.documentDeadline && (
                <tr><td className="py-1">ครบกำหนดเอกสาร</td><td>{formatThaiDate(claim.documentDeadline)}</td></tr>
              )}
              {claim.paymentDeadline && (
                <tr><td className="py-1">ครบกำหนดจ่าย</td><td>{formatThaiDate(claim.paymentDeadline)}</td></tr>
              )}
              {claim.collectedAmount !== undefined && (
                <tr><td className="py-1">ยอดเก็บแล้ว</td><td>{formatCurrency(Number(claim.collectedAmount))}</td></tr>
              )}
            </tbody>
          </table>
        </section>
      )}

      {claim.documentChecklist && claim.documentChecklist.length > 0 && (
        <section className="mb-4">
          <h2 className="font-semibold border-b mb-2">เอกสารประกอบ (ข้อ 17)</h2>
          <ul className="text-sm list-disc pl-5">
            {claim.documentChecklist.map((item) => (
              <li key={item.key}>
                {item.checked ? '☑' : '☐'} {item.label}
              </li>
            ))}
          </ul>
        </section>
      )}

      <section className="mb-4">
        <h2 className="font-semibold border-b mb-2">ผู้รับผลประโยชน์</h2>
        <p className="text-sm">{claim.mainBeneficiary}{claim.beneficiaryPhone ? ` (${claim.beneficiaryPhone})` : ''}</p>
      </section>

      <section className="mb-6">
        <h2 className="font-semibold border-b mb-2">การคำนวณเงินสงเคราะห์</h2>
        <table className="w-full text-sm">
          <tbody>
            <tr><td className="py-1">ประเภทเคลม</td><td className="text-right">{claim.claimType === 'PROTECTED_DEATH' ? 'ญาติที่คุ้มครอง' : 'สมาชิก'}</td></tr>
            <tr><td className="py-1">สมาชิกที่ต้องส่งเงิน</td><td className="text-right">{claim.activeMemberCount} คน</td></tr>
            <tr><td className="py-1">อัตราเก็บต่อคน</td><td className="text-right">{formatCurrency(Number(claim.welfareRate))}</td></tr>
            <tr><td className="py-1">ยอดเก็บรวม</td><td className="text-right">{formatCurrency(Number(claim.totalContribution))}</td></tr>
            <tr><td className="py-1">เข้ากองทุน ({Math.round((claim.payoutRatio ?? 0.9) * 100) === 90 ? '10' : '—'}%)</td><td className="text-right">{formatCurrency(Number(claim.associationSupport))}</td></tr>
            {Number(claim.otherDeductions) > 0 && (
              <tr><td className="py-1">หักอื่นๆ</td><td className="text-right">-{formatCurrency(Number(claim.otherDeductions))}</td></tr>
            )}
            <tr className="font-bold border-t">
              <td className="py-2">ยอดสุทธิจ่าย</td>
              <td className="text-right py-2">{formatCurrency(Number(claim.netToPay))}</td>
            </tr>
          </tbody>
        </table>
      </section>

      {claim.approvedAt && (
        <section className="mb-4">
          <h2 className="font-semibold border-b mb-2">การอนุมัติเบิก (ข้อ 13.6)</h2>
          <p className="text-sm">ผู้อนุมัติ: {claim.approverName} | วันที่ {formatThaiDate(claim.approvedAt)}</p>
          {claim.approverSignature && (
            <img src={claim.approverSignature} alt="ลายเซ็น" className="max-h-16 mt-2 object-contain" />
          )}
        </section>
      )}

      {claim.payment && (
        <section className="mb-8 text-sm">
          <p>จ่ายแล้วเมื่อ {formatThaiDate(claim.payment.payDate)} จำนวน {formatCurrency(Number(claim.payment.amount))} ({claim.payment.method})</p>
        </section>
      )}

      <div className="grid grid-cols-2 gap-16 mt-16 text-sm text-center">
        <div>
          <p className="mb-16">ผู้จัดทำ</p>
          <p>..................................</p>
        </div>
        <div>
          <p className="mb-16">ผู้อนุมัติ</p>
          <p>..................................</p>
        </div>
      </div>
    </div>
  );
}