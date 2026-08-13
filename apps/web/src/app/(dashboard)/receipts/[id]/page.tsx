'use client';

import { useRef, useState, useCallback } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { ArrowLeft, Printer, Download } from 'lucide-react';
import Link from 'next/link';
import { api } from '@/lib/api';
import { showSuccess, showError } from '@/lib/toast';
import ReceiptTemplate from '@/components/ReceiptTemplate';
import { useAuthStore } from '@/store/auth';

interface ReceiptDetail {
  id: string;
  receiptNo: string;
  date: string;
  type: string;
  description?: string;
  amount: number;
  voidedAt?: string | null;
  voidReason?: string | null;
  school?: {
    id: string;
    name: string;
  };
  bankAccount?: {
    bankName: string;
    accountNo: string;
  };
  memberContribution?: {
    member: {
      memberNo: string;
      associationMember?: {
        firstName: string;
        lastName: string;
      };
      school: {
        name: string;
      };
    };
  };
}

export default function ReceiptDetailPage() {
  const params = useParams();
  const router = useRouter();
  const receiptId = params.id as string;
  
  const receiptRef = useRef<HTMLDivElement>(null);
  const [isPrinting, setIsPrinting] = useState(false);
  const authUser = useAuthStore((state) => state.user);
  const isMemberUser = authUser?.role === 'MEMBER';
  const backHref = isMemberUser && authUser?.memberId
    ? `/members/${authUser.memberId}/profile`
    : '/receipts';

  const { data: receipt, isLoading } = useQuery<ReceiptDetail>({
    queryKey: ['receipt', receiptId],
    queryFn: async () => {
      const response = await api.get(`/receipts/${receiptId}`);
      return response.data;
    },
    enabled: !!receiptId,
  });

  // Get current user signature from system
  const { data: currentUser } = useQuery({
    queryKey: ['auth', 'me'],
    queryFn: async () => {
      const response = await api.get('/auth/me');
      return response.data;
    },
  });

  // Print/Export PDF
  const handlePrint = useCallback(async () => {
    if (!receiptRef.current) return;
    
    setIsPrinting(true);
    
    try {
      const html2canvas = (await import('html2canvas')).default;
      const jsPDF = (await import('jspdf')).default;

      const canvas = await html2canvas(receiptRef.current, {
        scale: 2,
        useCORS: true,
        allowTaint: true,
        logging: false,
        backgroundColor: '#ffffff',
        imageTimeout: 15000,
      });

      const imgData = canvas.toDataURL('image/png');
      const pdf = new jsPDF({
        orientation: 'portrait',
        unit: 'mm',
        format: 'a4',
      });

      const imgWidth = 210;
      const imgHeight = (canvas.height * imgWidth) / canvas.width;

      pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
      pdf.save(`ใบเสร็จ-${receipt?.receiptNo || 'receipt'}.pdf`);
      
      showSuccess('ดาวน์โหลดใบเสร็จสำเร็จ');
    } catch {
      showError('เกิดข้อผิดพลาดในการสร้าง PDF');
    } finally {
      setIsPrinting(false);
    }
  }, [receipt?.receiptNo]);

  // Browser print
  const handleBrowserPrint = () => {
    window.print();
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  if (!receipt) {
    return (
      <div className="text-center py-20">
        <p className="text-lg text-slate-500">ไม่พบใบเสร็จ</p>
        <Link href={backHref} className="btn-secondary mt-4">
          {isMemberUser ? 'กลับไปข้อมูลของฉัน' : 'กลับไปรายการใบเสร็จ'}
        </Link>
      </div>
    );
  }

  const receiptData = {
    receiptNo: receipt.receiptNo,
    date: receipt.date,
    memberNo: receipt.memberContribution?.member?.memberNo,
    memberName: receipt.memberContribution?.member 
      ? `${receipt.memberContribution.member.associationMember?.firstName ?? ''} ${receipt.memberContribution.member.associationMember?.lastName ?? ''}`
      : undefined,
    school: receipt.memberContribution?.member?.school?.name || receipt.school?.name || '-',
    description: receipt.description || '',
    amount: Number(receipt.amount),
    type: receipt.type,
    bankAccount: receipt.bankAccount 
      ? `${receipt.bankAccount.bankName} ${receipt.bankAccount.accountNo}`
      : undefined,
    receiverName: 'เจ้าหน้าที่การเงิน',
    // ส่งสถานะยกเลิกเข้าไปในตัวใบเสร็จ เพราะ PDF ที่ออกจากระบบมาจาก ReceiptTemplate เท่านั้น
    voidedAt: receipt.voidedAt ?? null,
    voidReason: receipt.voidReason ?? null,
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header - Hidden when printing */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 print:hidden">
        <div className="flex items-center gap-4">
          <Link href={backHref} className="p-2 hover:bg-slate-100 rounded-lg">
            <ArrowLeft size={20} />
          </Link>
          <div>
            <h1 className="text-2xl font-display font-bold text-slate-900">
              ใบเสร็จรับเงิน
            </h1>
            <p className="text-slate-500 mt-1">
              เลขที่ {receipt.receiptNo}
            </p>
          </div>
        </div>
        <div className="flex gap-3">
          <button
            onClick={handleBrowserPrint}
            className="btn-secondary"
          >
            <Printer size={18} />
            พิมพ์
          </button>
          <button
            onClick={handlePrint}
            disabled={isPrinting}
            className="btn-primary"
          >
            {isPrinting ? (
              <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
              <>
                <Download size={18} />
                ดาวน์โหลด PDF
              </>
            )}
          </button>
        </div>
      </div>

      {/*
        แถบนี้เป็นการเตือนบนหน้าจอเท่านั้น ตอนพิมพ์และตอนทำ PDF ใช้ตราประทับที่อยู่ใน
        ReceiptTemplate แทน — ถ้าปล่อยแถบนี้ไว้ตอนพิมพ์ มันจะถูก .card { position: absolute; top: 0 }
        ดันไปทับตัวใบเสร็จ
      */}
      {receipt.voidedAt && (
        <div className="card border-2 border-rose-300 bg-rose-50 p-4 text-rose-700 print:hidden">
          <p className="font-bold">ใบเสร็จนี้ถูกยกเลิกแล้ว — ไม่ใช่หลักฐานการรับเงิน</p>
          <p className="text-sm mt-1">
            ยกเลิกเมื่อ{' '}
            {new Date(receipt.voidedAt).toLocaleDateString('th-TH', {
              day: 'numeric',
              month: 'short',
              year: 'numeric',
            })}
            {receipt.voidReason ? ` — เหตุผล: ${receipt.voidReason}` : ''}
          </p>
        </div>
      )}

      {/* Receipt Preview */}
      <div className="card p-6 print:p-0 print:shadow-none print:border-0 receipt-print-area">
        <ReceiptTemplate
          ref={receiptRef} 
          data={receiptData} 
          signature={currentUser?.signature || null}
        />
      </div>

      {/* Print Styles */}
      <style jsx global>{`
        .receipt-template {
          font-size: 1.125em !important;
        }
        .receipt-template h1 { font-size: 1.1625rem !important; }
        .receipt-template h2 { font-size: 1.0125rem !important; }
        .receipt-template h3 { font-size: 1.0125rem !important; }
        .receipt-template p,
        .receipt-template span,
        .receipt-template th,
        .receipt-template td {
          font-size: 1.125em !important;
        }
        .receipt-template .text-sm { font-size: 0.73125rem !important; }
        .receipt-template .text-xs { font-size: 0.7125rem !important; }
        .receipt-template .text-lg { font-size: 0.91875rem !important; }
        @media print {
          body * {
            visibility: hidden;
          }
          /* จำกัดการดันขึ้นหัวกระดาษไว้ที่กล่องใบเสร็จกล่องเดียว
             ถ้าเหวี่ยง .card ทุกกล่องเป็น absolute top:0 กล่องอื่นบนหน้านี้จะพิมพ์ทับกัน */
          .receipt-print-area, .receipt-print-area * {
            visibility: visible;
          }
          .receipt-print-area {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
          }
          .print\\:hidden {
            display: none !important;
          }
        }
      `}</style>
    </motion.div>
  );
}

