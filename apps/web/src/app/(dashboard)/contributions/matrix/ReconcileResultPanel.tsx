'use client';

import { useMemo } from 'react';
import { AlertTriangle, Download, X } from 'lucide-react';
import { api } from '@/lib/api';
import { showError } from '@/lib/toast';
import type { ReconcileResponse } from './UploadPaymentModal';

const REASON_LABEL = {
  NOT_IN_FILE: 'ไม่มีในไฟล์',
  IN_FILE_NOT_PAID: 'อยู่ในไฟล์ แต่ยังไม่ชำระ',
} as const;

const REASON_CLASS = {
  NOT_IN_FILE: 'bg-red-50 text-red-700',
  IN_FILE_NOT_PAID: 'bg-amber-50 text-amber-700',
} as const;

export function ReconcileResultPanel({
  result, periodId, onClose, onSendNotice,
}: {
  result: ReconcileResponse; periodId: string; onClose: () => void; onSendNotice: () => void;
}) {
  const bySchool = useMemo(() => {
    const map = new Map<string, ReconcileResponse['missing']>();
    for (const row of result.missing) {
      const list = map.get(row.schoolName) ?? [];
      list.push(row);
      map.set(row.schoolName, list);
    }
    return [...map.entries()];
  }, [result.missing]);

  const missingCount = result.missing.length;

  const download = async () => {
    try {
      const response = await api.post(
        `/contributions/periods/${periodId}/missing/export`,
        { missing: result.missing },
        { responseType: 'blob' },
      );
      const url = URL.createObjectURL(response.data as Blob);
      const link = document.createElement('a');
      link.href = url;
      link.download = 'รายชื่อที่ขาด.xlsx';
      link.click();
      URL.revokeObjectURL(url);
    } catch {
      showError('ดาวน์โหลดรายชื่อไม่สำเร็จ');
    }
  };

  return (
    <div className="bg-white rounded-2xl border border-slate-200 p-5 mt-4">
      <div className="flex items-center justify-between mb-4">
        <h2 className="font-semibold text-slate-800">ผลการกระทบยอด</h2>
        <button onClick={onClose} className="p-1 text-slate-400 hover:text-slate-600">
          <X size={18} />
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
        {[
          { label: 'ต้องเก็บ', value: result.summary.expected, tone: 'text-slate-800' },
          { label: 'เก็บได้', value: result.summary.paid + result.summary.alreadyPaid, tone: 'text-emerald-600' },
          { label: 'ขาด', value: missingCount, tone: 'text-red-600' },
          { label: 'ไม่รู้จัก', value: result.summary.unknownInFile, tone: 'text-amber-600' },
        ].map((card) => (
          <div key={card.label} className="rounded-xl bg-slate-50 p-3">
            <p className="text-xs text-slate-500">{card.label}</p>
            <p className={`text-2xl font-semibold ${card.tone}`}>{card.value}</p>
          </div>
        ))}
      </div>

      {missingCount > 0 && (
        <div className="flex items-center gap-2 rounded-xl bg-amber-50 text-amber-800 px-4 py-3 text-sm mb-4">
          <AlertTriangle size={18} />
          ขาด {missingCount} คน — ตรวจรายชื่อด้านล่างก่อนปิดงวด
          {result.summary.markedArrears > 0 && ` (บันทึกค้างชำระแล้ว ${result.summary.markedArrears} ราย)`}
        </div>
      )}

      {bySchool.map(([schoolName, rows]) => (
        <details key={schoolName} open className="mb-3">
          <summary className="cursor-pointer text-sm font-medium text-slate-700">
            {schoolName} — ขาด {rows.length} คน
          </summary>
          <table className="w-full text-sm mt-2">
            <thead>
              <tr className="text-left text-slate-500">
                <th className="py-1">เลขสมาชิก</th>
                <th>ชื่อ-สกุล</th>
                <th>กลุ่ม</th>
                <th className="text-right">ยอด</th>
                <th>เหตุผล</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.memberId} className="border-t border-slate-100">
                  <td className="py-1">{row.memberNo}</td>
                  <td>{row.fullName}</td>
                  <td>{row.groupName}</td>
                  <td className="text-right">{row.amountDue.toLocaleString('th-TH')}</td>
                  <td>
                    <span className={`px-2 py-0.5 rounded-lg text-xs ${REASON_CLASS[row.reason]}`}>
                      {REASON_LABEL[row.reason]}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </details>
      ))}

      {result.unknown.length > 0 && (
        <div className="mt-4">
          <p className="text-sm font-medium text-slate-700 mb-1">ไม่รู้จักในระบบ</p>
          <ul className="text-sm text-slate-600 list-disc pl-5">
            {result.unknown.map((row) => (
              <li key={`${row.rowNo}-${row.memberNo}`}>
                บรรทัด {row.rowNo}: {row.memberNo}
              </li>
            ))}
          </ul>
        </div>
      )}

      {result.errors.length > 0 && (
        <div className="mt-4">
          <p className="text-sm font-medium text-red-700 mb-1">รายการที่มีปัญหา</p>
          <ul className="text-sm text-red-600 list-disc pl-5">
            {result.errors.map((row, index) => (
              <li key={`${row.memberNo}-${index}`}>
                {row.memberNo}: {row.error}
              </li>
            ))}
          </ul>
        </div>
      )}

      <div className="flex flex-wrap gap-2 mt-5">
        <button
          onClick={download}
          disabled={missingCount === 0}
          className="flex items-center gap-2 border border-slate-200 rounded-xl px-4 py-2 text-sm disabled:opacity-40"
        >
          <Download size={16} />
          ดาวน์โหลดรายชื่อที่ขาด
        </button>
        <button
          onClick={onSendNotice}
          disabled={missingCount === 0}
          className="border border-amber-300 text-amber-800 rounded-xl px-4 py-2 text-sm disabled:opacity-40"
        >
          แจ้งเตือนค้างชำระ
        </button>
      </div>
    </div>
  );
}
