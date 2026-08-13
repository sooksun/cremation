'use client';

import { useState, useRef } from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { FileSpreadsheet, Scale, Download } from 'lucide-react';
import { api } from '@/lib/api';
import { useAuthStore } from '@/store/auth';
import ThaiDatePicker from '@/components/ThaiDatePicker';
import dayjs from 'dayjs';
import { exportElementToPdf } from '@/lib/export-pdf';
import { showSuccess, showError } from '@/lib/toast';

export default function FinancialStatementsPage() {
  const { selectedYear, selectedSchoolId } = useAuthStore();
  const [asOfDate, setAsOfDate] = useState(dayjs().format('YYYY-MM-DD'));
  const [plRange, setPlRange] = useState({
    startDate: `${selectedYear}-01-01`,
    endDate: `${selectedYear}-12-31`,
  });
  const contentRef = useRef<HTMLDivElement>(null);

  // งบดุลเป็นยอดทั้งสมาคม — ไม่ส่ง schoolId และไม่ใส่ selectedSchoolId ใน queryKey
  // เพราะการเปลี่ยนโรงเรียนที่เลือกไม่ทำให้ตัวเลขเปลี่ยน (ดูหมายเหตุใต้หัวข้องบดุล)
  const { data: balanceSheet, isLoading: loadingBS } = useQuery({
    queryKey: ['balance-sheet', asOfDate],
    queryFn: async () => {
      const params = new URLSearchParams({ asOfDate });
      const res = await api.get(`/accounts/reports/balance-sheet?${params}`);
      return res.data;
    },
  });

  const { data: profitLoss, isLoading: loadingPL } = useQuery({
    queryKey: ['profit-loss', plRange],
    queryFn: async () => {
      const params = new URLSearchParams(plRange);
      const res = await api.get(`/accounts/reports/profit-loss?${params}`);
      return res.data;
    },
  });

  const { data: journal, isLoading: loadingJournal } = useQuery({
    queryKey: ['journal', plRange],
    queryFn: async () => {
      const params = new URLSearchParams(plRange);
      const res = await api.get(`/accounts/journal?${params}`);
      return res.data;
    },
  });

  const { data: cashFlow, isLoading: loadingCashFlow } = useQuery({
    queryKey: ['cash-flow', plRange, selectedSchoolId],
    queryFn: async () => {
      const params = new URLSearchParams(plRange);
      if (selectedSchoolId) params.append('schoolId', selectedSchoolId);
      const res = await api.get(`/reports/cash-flow?${params}`);
      return res.data;
    },
  });

  // งบแสดงการเปลี่ยนแปลงในส่วนของทุนเป็นยอดทั้งสมาคมเช่นเดียวกับงบดุล — ไม่ส่ง schoolId
  const { data: changesInEquity, isLoading: loadingEquity } = useQuery({
    queryKey: ['changes-in-equity', plRange],
    queryFn: async () => {
      const params = new URLSearchParams(plRange);
      const res = await api.get(`/reports/changes-in-equity?${params}`);
      return res.data;
    },
  });

  const fmt = (n: number) =>
    new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB' }).format(n);

  const handleExportPdf = async () => {
    if (contentRef.current) {
      await exportElementToPdf(contentRef.current, `งบการเงิน-${asOfDate}.pdf`);
    }
  };

  const handleCloseYear = async () => {
    const year = dayjs(plRange.startDate).year();
    if (!confirm(`ยืนยันการปิดบัญชีประจำปี ${year}? การปิดบัญชีจะสร้างรายการปิด (closing entries) และควรทำเมื่อสิ้นปี`)) return;
    try {
      const res = await api.post(`/accounts/close-year?year=${year}`);
      showSuccess(res.data?.message || 'ปิดบัญชีสำเร็จ');
      // refresh
      window.location.reload();
    } catch (e: any) {
      showError(e.response?.data?.message || 'ปิดบัญชีล้มเหลว');
    }
  };

  return (
    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="space-y-6">
      <div>
        <h1 className="text-2xl font-display font-bold text-slate-900">งบการเงิน</h1>
        <p className="text-slate-500 mt-1">งบดุลและงบกำไรขาดทุน จากผังบัญชีและสมุดรายวัน</p>
        <div className="mt-3 rounded-lg border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800">
          <span className="font-semibold">ขอบเขตข้อมูล: ทั้งสมาคม</span> — งบดุล งบกำไรขาดทุน
          งบแสดงการเปลี่ยนแปลงในส่วนของทุน และสมุดรายวัน เป็นยอดรวม
          <span className="font-semibold">ทั้งสมาคม</span> ไม่ใช่เฉพาะโรงเรียนที่เลือกไว้ด้านบน
          เนื่องจากเงินกองทุนฌาปนกิจใช้บัญชีธนาคารชุดเดียวร่วมกันทั้งเขต
          การเปลี่ยนโรงเรียนที่เลือกจะไม่ทำให้ตัวเลขในหน้านี้เปลี่ยน
          <br />
          งบกระแสเงินสดแยกตามโรงเรียนได้เฉพาะส่วนใบเสร็จและใบสำคัญจ่าย
          ส่วนรายการเดินบัญชีธนาคารเป็นยอดทั้งสมาคมเสมอ ด้วยเหตุผลเดียวกัน
        </div>
      </div>

      <div ref={contentRef} className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="card p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-semibold flex items-center gap-2">
              <Scale size={20} />งบดุล
              <span className="rounded bg-slate-100 px-2 py-0.5 text-[11px] font-medium text-slate-600">
                ทั้งสมาคม
              </span>
            </h2>
            <div className="flex items-center gap-2">
              <ThaiDatePicker
                value={asOfDate}
                onChange={(d) => d && setAsOfDate(d.format('YYYY-MM-DD'))}
              />
              <button onClick={handleExportPdf} className="btn-secondary flex items-center gap-2 text-xs">
                <Download size={16} /> PDF
              </button>
            </div>
          </div>
          {loadingBS ? (
            <div className="h-32 flex items-center justify-center"><div className="w-6 h-6 border-2 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
          ) : balanceSheet ? (
            <div className="space-y-4 text-sm">
              <Section title="สินทรัพย์" rows={balanceSheet.assets} fmt={fmt} />
              {balanceSheet.fixedAssets && balanceSheet.fixedAssets.length > 0 && (
                <div className="mt-2">
                  <h3 className="font-medium text-slate-700 mb-1">สินทรัพย์ถาวร (คงเหลือ)</h3>
                  {balanceSheet.fixedAssets.map((f: any, i: number) => (
                    <div key={i} className="flex justify-between text-xs py-0.5">
                      <span>{f.name}</span>
                      <span>{fmt(f.balance)}</span>
                    </div>
                  ))}
                </div>
              )}
              <Section title="หนี้สิน" rows={balanceSheet.liabilities} fmt={fmt} />
              <Section title="ทุน" rows={balanceSheet.equity} fmt={fmt} />
              <div className="border-t pt-3 space-y-1 font-medium">
                <div className="flex justify-between"><span>รวมสินทรัพย์</span><span>{fmt(balanceSheet.totals.assets)}</span></div>
                <div className="flex justify-between"><span>รวมหนี้สิน + ทุน</span><span>{fmt(balanceSheet.totals.liabilitiesAndEquity)}</span></div>
              </div>
              {balanceSheet.isBalanced !== undefined && (
                <div className={`text-xs mt-2 ${balanceSheet.isBalanced ? 'text-emerald-600' : 'text-red-600'}`}>
                  {balanceSheet.isBalanced ? '✓ งบดุลสมดุล' : `⚠ ไม่สมดุล: ต่าง ${fmt(balanceSheet.difference || 0)}`}
                </div>
              )}
            </div>
          ) : null}
        </div>

        <div className="card p-6">
          <div className="flex items-center gap-2 mb-4">
            <FileSpreadsheet size={20} />
            <h2 className="font-semibold">งบกำไรขาดทุน</h2>
          </div>
          <div className="flex flex-wrap gap-3 mb-4">
            <ThaiDatePicker
              value={plRange.startDate}
              onChange={(d) => d && setPlRange((p) => ({ ...p, startDate: d.format('YYYY-MM-DD') }))}
            />
            <ThaiDatePicker
              value={plRange.endDate}
              onChange={(d) => d && setPlRange((p) => ({ ...p, endDate: d.format('YYYY-MM-DD') }))}
            />
          </div>
          {loadingPL ? (
            <div className="h-32 flex items-center justify-center"><div className="w-6 h-6 border-2 border-primary-500 border-t-transparent rounded-full animate-spin" /></div>
          ) : profitLoss ? (
            <div className="space-y-4 text-sm">
              <Section title="รายได้" rows={profitLoss.income.map((r: any) => ({ ...r, balance: r.amount }))} fmt={fmt} />
              <Section title="ค่าใช้จ่าย" rows={profitLoss.expenses.map((r: any) => ({ ...r, balance: r.amount }))} fmt={fmt} />
              <div className="border-t pt-3 font-bold flex justify-between">
                <span>กำไร (ขาดทุน) สุทธิ</span>
                <span className={profitLoss.totals.netProfit >= 0 ? 'text-emerald-600' : 'text-red-600'}>
                  {fmt(profitLoss.totals.netProfit)}
                </span>
              </div>
              {profitLoss.trialBalanceCheck && (
                <div className="text-xs text-gray-500 mt-1">
                  ตรวจสอบสมุดรายวัน: {profitLoss.trialBalanceCheck.isBalanced ? 'สมดุล' : 'ไม่สมดุล'}
                </div>
              )}
            </div>
          ) : null}
        </div>

        <div className="card p-6">
          <h2 className="font-semibold mb-4">ปิดบัญชีประจำปี (Closing Entries)</h2>
          <p className="text-sm text-slate-500 mb-4">สร้างรายการปิดบัญชี (ปิดรายได้/ค่าใช้จ่าย เข้าสรุปทุน) สำหรับปีที่เลือก</p>
          <button onClick={handleCloseYear} className="btn-primary">ปิดบัญชีปี {dayjs(plRange.startDate).year()}</button>
          <p className="text-xs text-amber-600 mt-2">* ควรสำรองข้อมูลก่อนปิดบัญชี</p>
        </div>

        <div className="card p-6">
          <h2 className="font-semibold mb-4">งบกระแสเงินสด (Cash Flow)</h2>
          {loadingCashFlow ? (
            <div className="h-20 flex items-center justify-center">Loading...</div>
          ) : cashFlow ? (
            <div className="space-y-2 text-sm">
              <div>เงินสดรับจากใบเสร็จ: {fmt(cashFlow.cashFlows?.operatingActivities?.cashReceipts || 0)}</div>
              <div>เงินสดจ่ายตามใบสำคัญ: {fmt(cashFlow.cashFlows?.operatingActivities?.cashPayments || 0)}</div>
              <div className="font-bold">สุทธิจากกิจกรรมดำเนินงาน: {fmt(cashFlow.cashFlows?.operatingActivities?.net || 0)}</div>
              <div className="border-t pt-2">เงินสดสุทธิในงวด: {fmt(cashFlow.netCashFlow || 0)}</div>
            </div>
          ) : <div>ไม่มีข้อมูล</div>}
        </div>

        <div className="card p-6">
          <h2 className="font-semibold mb-4">
            งบแสดงการเปลี่ยนแปลงในส่วนของเจ้าของ (Changes in Equity)
            <span className="ml-2 rounded bg-slate-100 px-2 py-0.5 text-[11px] font-medium text-slate-600">
              ทั้งสมาคม
            </span>
          </h2>
          {loadingEquity ? (
            <div>Loading...</div>
          ) : changesInEquity ? (
            <div className="space-y-2 text-sm">
              <div>ทุนต้นงวด: {fmt(changesInEquity.changes?.beginningEquity || 0)}</div>
              <div>กำไร (ขาดทุน) สุทธิ: {fmt(changesInEquity.changes?.netIncome || 0)}</div>
              <div>การปรับปรุงอื่น ๆ: {fmt(changesInEquity.changes?.otherAdjustments || 0)}</div>
              <div className="font-bold border-t pt-2">ทุนปลายงวด: {fmt(changesInEquity.changes?.endingEquity || 0)}</div>
              {changesInEquity.isConsistent !== undefined && (
                <div className={`text-xs ${changesInEquity.isConsistent ? 'text-emerald-600' : 'text-red-600'}`}>
                  {changesInEquity.isConsistent ? '✓ สอดคล้อง' : '⚠ ไม่สอดคล้อง'}
                </div>
              )}
            </div>
          ) : <div>ไม่มีข้อมูล</div>}
        </div>
      </div>

      {/* Journal / สมุดรายวันขั้นสูง */}
      <div className="card p-6">
        <h2 className="font-semibold mb-4">
          สมุดรายวัน (Journal) - ตัวอย่าง
          <span className="ml-2 rounded bg-slate-100 px-2 py-0.5 text-[11px] font-medium text-slate-600">
            ทั้งสมาคม
          </span>
        </h2>
        {loadingJournal ? (
          <div>กำลังโหลด...</div>
        ) : journal && journal.length > 0 ? (
          <div className="space-y-3 text-sm max-h-96 overflow-auto">
            {journal.slice(0, 5).map((j: any, idx: number) => (
              <div key={idx} className="border p-3 rounded">
                <div className="font-medium">{j.date} | {j.reference || j.description} | {j.school}</div>
                <div className="ml-4 text-xs">
                  {j.entries?.map((e: any, i: number) => (
                    <div key={i}>{e.accountCode} {e.accountName}: Dr {fmt(e.debit)} Cr {fmt(e.credit)}</div>
                  ))}
                </div>
                <div className="text-xs text-right">รวม Dr: {fmt(j.totalDebit)} / Cr: {fmt(j.totalCredit)}</div>
              </div>
            ))}
            {journal.length > 5 && <div className="text-xs text-gray-400">... และอีก {journal.length - 5} รายการ (ดู API /accounts/journal)</div>}
          </div>
        ) : <div className="text-gray-400">ไม่มีรายการ</div>}
      </div>
    </motion.div>
  );
}

function Section({ title, rows, fmt }: { title: string; rows: { code: string; name: string; balance: number }[]; fmt: (n: number) => string }) {
  if (!rows?.length) return <p className="text-slate-400">{title}: ไม่มีข้อมูล</p>;
  return (
    <div>
      <h3 className="font-medium text-slate-700 mb-2">{title}</h3>
      <table className="w-full">
        <tbody>
          {rows.map((r) => (
            <tr key={r.code} className="border-b border-slate-100">
              <td className="py-1.5">{r.code} {r.name}</td>
              <td className="py-1.5 text-right">{fmt(r.balance)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}