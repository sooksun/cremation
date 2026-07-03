'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import {
  FileText,
  Users,
  Flower2,
  DollarSign,
  AlertTriangle,
  Printer,
  ClipboardCheck,
  Download,
} from 'lucide-react';
import { api, DEATH_CLAIM_STATUS_LABELS, type DeathClaimStatus } from '@/lib/api';
import { exportElementToPdf } from '@/lib/export-pdf';
import { useAuthStore } from '@/store/auth';
import { formatThaiDate, formatThaiDateShort } from '@/components/ThaiDatePicker';

const thaiMonths = [
  'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
  'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม',
];

interface BoardMonthlyReport {
  period: { year: number; month: number; label: string };
  members: {
    total: number;
    active: number;
    newThisMonth: number;
    resignedThisMonth: number;
    deceasedThisMonth: number;
    arrears: number;
  };
  finance: {
    receipts: number;
    receiptCount: number;
    payments: number;
    paymentCount: number;
    net: number;
  };
  contributions: {
    totalDue: number;
    totalPaid: number;
    memberCount: number;
    collectionRate: number;
  };
  deathClaims: {
    count: number;
    fundReserve: number;
    paid: number;
    pending: number;
    pendingApproval: number;
    overdueWorkflow: number;
    items: {
      id: string;
      claimNo: string;
      memberName: string;
      schoolName: string;
      reportedDate: string;
      netToPay: number;
      status: DeathClaimStatus;
      approved: boolean;
      approverName?: string;
      paid: boolean;
    }[];
  };
  generatedAt: string;
}

export default function BoardMonthlyReportPage() {
  const { selectedSchoolId, selectedYear } = useAuthStore();
  const [month, setMonth] = useState(new Date().getMonth() + 1);

  const { data: report, isLoading } = useQuery<BoardMonthlyReport>({
    queryKey: ['board-monthly', selectedYear, month, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams({
        year: selectedYear.toString(),
        month: month.toString(),
      });
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const response = await api.get(`/reports/board-monthly?${params}`);
      return response.data;
    },
  });

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB', minimumFractionDigits: 0 }).format(amount);

  const handlePrint = () => window.print();

  const contentRef = useRef<HTMLDivElement>(null);
  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `รายงานคณะกรรมการ-${selectedYear}-${month}.pdf`);
    }
  };

  return (
    <>
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="space-y-6 print:hidden"
      >
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-display font-bold text-slate-900 flex items-center gap-3">
              <FileText className="w-7 h-7 text-primary-600" />
              รายงานสรุปรายเดือน (คณะกรรมการ)
            </h1>
            <p className="text-slate-500 mt-1">ตามระเบียบ ข้อ 10–12, 11.2 — สำหรับเสนอคณะกรรมการ</p>
          </div>
          <div className="flex gap-2 items-center">
            <select
              className="input w-40"
              value={month}
              onChange={(e) => setMonth(Number(e.target.value))}
            >
              {thaiMonths.map((name, i) => (
                <option key={name} value={i + 1}>
                  {name} {selectedYear + 543}
                </option>
              ))}
            </select>
            <button type="button" onClick={handlePrint} className="btn-secondary">
              <Printer size={18} />พิมพ์
            </button>
            <button type="button" onClick={handleExportPdf} className="btn-secondary">
              <Download size={18} /> PDF
            </button>
          </div>
        </div>

        {isLoading ? (
          <div className="flex justify-center py-20">
            <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : report ? (
          <div ref={contentRef} className="space-y-6">
            {(report.deathClaims.pendingApproval > 0 || report.deathClaims.overdueWorkflow > 0) && (
              <div className="bg-amber-50 border border-amber-200 rounded-2xl p-4 flex items-start gap-3">
                <AlertTriangle className="w-5 h-5 text-amber-600 mt-0.5" />
                <div className="text-sm text-amber-800">
                  {report.deathClaims.pendingApproval > 0 && (
                    <p>รออนุมัติเบิกเงินสงเคราะห์ {report.deathClaims.pendingApproval} รายการ</p>
                  )}
                  {report.deathClaims.overdueWorkflow > 0 && (
                    <p>เลยกำหนด workflow {report.deathClaims.overdueWorkflow} รายการ</p>
                  )}
                </div>
              </div>
            )}

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="stat-card">
                <p className="stat-label">สมาชิกทั้งหมด</p>
                <p className="stat-value">{report.members.total}</p>
                <p className="text-sm text-emerald-600">{report.members.active} ปกติ</p>
              </div>
              <div className="stat-card">
                <p className="stat-label">รายรับเดือนนี้</p>
                <p className="text-xl font-bold text-emerald-600">{formatCurrency(report.finance.receipts)}</p>
                <p className="text-sm text-slate-500">{report.finance.receiptCount} รายการ</p>
              </div>
              <div className="stat-card">
                <p className="stat-label">รายจ่ายเดือนนี้</p>
                <p className="text-xl font-bold text-rose-600">{formatCurrency(report.finance.payments)}</p>
                <p className="text-sm text-slate-500">{report.finance.paymentCount} รายการ</p>
              </div>
              <div className="stat-card">
                <p className="stat-label">กองทุน 10% (เดือนนี้)</p>
                <p className="text-xl font-bold text-sky-600">{formatCurrency(report.deathClaims.fundReserve)}</p>
                <p className="text-sm text-slate-500">จากเคลม {report.deathClaims.count} รายการ</p>
              </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <div className="card p-6">
                <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                  <Users className="w-5 h-5 text-primary-500" />สมาชิก (ข้อ 10)
                </h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between"><span>เข้าใหม่เดือนนี้</span><span className="font-medium">{report.members.newThisMonth}</span></div>
                  <div className="flex justify-between"><span>ลาออกเดือนนี้</span><span>{report.members.resignedThisMonth}</span></div>
                  <div className="flex justify-between"><span>เสียชีวิตเดือนนี้</span><span>{report.members.deceasedThisMonth}</span></div>
                  <div className="flex justify-between text-amber-700"><span>ค้างชำระ</span><span>{report.members.arrears}</span></div>
                </div>
              </div>

              <div className="card p-6">
                <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                  <DollarSign className="w-5 h-5 text-emerald-500" />การเงิน (ข้อ 11)
                </h3>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between"><span>รายรับ</span><span className="text-emerald-600">{formatCurrency(report.finance.receipts)}</span></div>
                  <div className="flex justify-between"><span>รายจ่าย</span><span className="text-rose-600">{formatCurrency(report.finance.payments)}</span></div>
                  <div className="flex justify-between font-semibold border-t pt-2"><span>คงเหลือสุทธิ</span><span>{formatCurrency(report.finance.net)}</span></div>
                  <div className="flex justify-between text-slate-500 pt-2">
                    <span>เก็บเงินสงเคราะห์งวด</span>
                    <span>{Math.round(report.contributions.collectionRate * 100)}%</span>
                  </div>
                </div>
              </div>
            </div>

            <div className="card p-6">
              <h3 className="font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Flower2 className="w-5 h-5 text-rose-500" />การแจ้งเสียชีวิตเดือนนี้
              </h3>
              {report.deathClaims.items.length === 0 ? (
                <p className="text-slate-500 text-sm">ไม่มีรายการแจ้งเสียชีวิตในเดือนนี้</p>
              ) : (
                <div className="table-container border-0">
                  <table className="table text-sm">
                    <thead>
                      <tr>
                        <th>เลขที่</th>
                        <th>สมาชิก</th>
                        <th>โรงเรียน</th>
                        <th>ยอดจ่าย</th>
                        <th>สถานะ</th>
                        <th>อนุมัติเบิก</th>
                      </tr>
                    </thead>
                    <tbody>
                      {report.deathClaims.items.map((item) => (
                        <tr key={item.id}>
                          <td className="font-mono">{item.claimNo}</td>
                          <td>{item.memberName}</td>
                          <td className="text-slate-500">{item.schoolName}</td>
                          <td className="text-right">{formatCurrency(item.netToPay)}</td>
                          <td>
                            {item.paid ? (
                              <span className="badge-success">จ่ายแล้ว</span>
                            ) : (
                              <span className="badge-neutral">{DEATH_CLAIM_STATUS_LABELS[item.status]}</span>
                            )}
                          </td>
                          <td>
                            {item.approved ? (
                              <span className="flex items-center gap-1 text-emerald-700">
                                <ClipboardCheck size={14} />{item.approverName}
                              </span>
                            ) : (
                              <span className="text-amber-600">รออนุมัติ</span>
                            )}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </div>
          </div>
        ) : null}
      </motion.div>

      {report && (
        <div id="board-monthly-print" className="hidden print:block p-8 text-black bg-white text-sm">
          <div className="text-center mb-6 border-b pb-4">
            <h1 className="text-lg font-bold">รายงานสรุปรายเดือนต่อคณะกรรมการ</h1>
            <p>สมาคมฌาปนกิจสงเคราะห์ข้าราชการครูและบุคลากรทางการศึกษา อ.แม่ฟ้าหลวง</p>
            <p className="mt-2 font-medium">เดือน{thaiMonths[month - 1]} พ.ศ. {selectedYear + 543}</p>
            <p className="text-xs text-slate-600 mt-1">พิมพ์เมื่อ {formatThaiDate(report.generatedAt)}</p>
          </div>

          <section className="mb-4">
            <h2 className="font-semibold border-b mb-2">1. สมาชิก (ข้อ 10)</h2>
            <p>สมาชิกทั้งหมด {report.members.total} คน (ปกติ {report.members.active}) | เข้าใหม่ {report.members.newThisMonth} | ลาออก {report.members.resignedThisMonth} | เสียชีวิต {report.members.deceasedThisMonth} | ค้างชำระ {report.members.arrears}</p>
          </section>

          <section className="mb-4">
            <h2 className="font-semibold border-b mb-2">2. การเงิน (ข้อ 11)</h2>
            <p>รายรับ {formatCurrency(report.finance.receipts)} | รายจ่าย {formatCurrency(report.finance.payments)} | คงเหลือ {formatCurrency(report.finance.net)}</p>
            <p className="mt-1">อัตราเก็บเงินสงเคราะห์งวด {Math.round(report.contributions.collectionRate * 100)}%</p>
          </section>

          <section className="mb-4">
            <h2 className="font-semibold border-b mb-2">3. เงินสงเคราะห์ศพ</h2>
            <p>แจ้งเสียชีวิต {report.deathClaims.count} รายการ | กองทุน 10% รวม {formatCurrency(report.deathClaims.fundReserve)} | รออนุมัติเบิก {report.deathClaims.pendingApproval} รายการ</p>
          </section>

          {report.deathClaims.items.length > 0 && (
            <table className="w-full border-collapse text-xs mb-6">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-1">เลขที่</th>
                  <th className="text-left">สมาชิก</th>
                  <th className="text-right">ยอดจ่าย</th>
                  <th className="text-left">อนุมัติ</th>
                </tr>
              </thead>
              <tbody>
                {report.deathClaims.items.map((item) => (
                  <tr key={item.id} className="border-b">
                    <td className="py-1">{item.claimNo}</td>
                    <td>{item.memberName}</td>
                    <td className="text-right">{formatCurrency(item.netToPay)}</td>
                    <td>{item.approved ? item.approverName : 'รออนุมัติ'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}

          <div className="grid grid-cols-2 gap-16 mt-12 text-center">
            <div>
              <p className="mb-16">เลขานุการคณะกรรมการ</p>
              <p>..................................</p>
            </div>
            <div>
              <p className="mb-16">ประธานคณะกรรมการ</p>
              <p>..................................</p>
            </div>
          </div>
        </div>
      )}
    </>
  );
}