'use client';

import { forwardRef } from 'react';

interface ReceiptData {
  receiptNo: string;
  date: string;
  memberNo?: string;
  memberName?: string;
  school?: string;
  description: string;
  amount: number;
  type: string;
  paymentMethod?: string;
  bankAccount?: string;
  receiverName?: string;
  receiverSignature?: string;
}

interface ReceiptTemplateProps {
  data: ReceiptData;
  signature?: string | null;
}

// Convert number to Thai Baht text
function numberToThaiText(num: number): string {
  const ones = ['', 'หนึ่ง', 'สอง', 'สาม', 'สี่', 'ห้า', 'หก', 'เจ็ด', 'แปด', 'เก้า'];
  const teens = ['สิบ', 'สิบเอ็ด', 'สิบสอง', 'สิบสาม', 'สิบสี่', 'สิบห้า', 'สิบหก', 'สิบเจ็ด', 'สิบแปด', 'สิบเก้า'];
  const tens = ['', 'สิบ', 'ยี่สิบ', 'สามสิบ', 'สี่สิบ', 'ห้าสิบ', 'หกสิบ', 'เจ็ดสิบ', 'แปดสิบ', 'เก้าสิบ'];
  
  if (num === 0) return 'ศูนย์บาทถ้วน';
  
  let result = '';
  const intPart = Math.floor(num);
  const decPart = Math.round((num - intPart) * 100);
  
  if (intPart >= 1000000) {
    result += ones[Math.floor(intPart / 1000000)] + 'ล้าน';
  }
  if (intPart >= 100000) {
    const h = Math.floor((intPart % 1000000) / 100000);
    if (h > 0) result += ones[h] + 'แสน';
  }
  if (intPart >= 10000) {
    const t = Math.floor((intPart % 100000) / 10000);
    if (t > 0) result += ones[t] + 'หมื่น';
  }
  if (intPart >= 1000) {
    const th = Math.floor((intPart % 10000) / 1000);
    if (th > 0) result += ones[th] + 'พัน';
  }
  if (intPart >= 100) {
    const h = Math.floor((intPart % 1000) / 100);
    if (h > 0) result += ones[h] + 'ร้อย';
  }
  if (intPart >= 10) {
    const t = Math.floor((intPart % 100) / 10);
    const o = intPart % 10;
    if (t === 1) {
      result += teens[o];
    } else if (t > 1) {
      result += tens[t];
      if (o === 1) result += 'เอ็ด';
      else if (o > 0) result += ones[o];
    }
  } else if (intPart > 0) {
    result += ones[intPart];
  }
  
  result += 'บาท';
  
  if (decPart > 0) {
    if (decPart >= 10) {
      const t = Math.floor(decPart / 10);
      const o = decPart % 10;
      if (t === 1) {
        result += teens[o];
      } else {
        result += tens[t];
        if (o === 1) result += 'เอ็ด';
        else if (o > 0) result += ones[o];
      }
    } else {
      result += ones[decPart];
    }
    result += 'สตางค์';
  } else {
    result += 'ถ้วน';
  }
  
  return result;
}

// Format date to Thai
function formatThaiDate(dateString: string): string {
  const date = new Date(dateString);
  const day = date.getDate();
  const month = date.getMonth();
  const year = date.getFullYear() + 543;
  
  const thaiMonths = [
    'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
    'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
  ];
  
  return `${day} ${thaiMonths[month]} ${year}`;
}

const ReceiptTemplate = forwardRef<HTMLDivElement, ReceiptTemplateProps>(
  ({ data, signature }, ref) => {
    const typeLabels: Record<string, string> = {
      MEMBER_CONTRIBUTION: 'เงินสงเคราะห์รายเดือน',
      MEMBERSHIP_FEE: 'ค่าสมัครสมาชิก',
      BOOK_FEE: 'ค่าสมุด',
      ANNUAL_FEE: 'ค่าบำรุงประจำปี',
      ADVANCE_WELFARE: 'เงินสงเคราะห์ล่วงหน้า',
      REGISTRATION_FEE: 'ค่าสมัครสมาชิก',
      SERVICE_FEE: 'ค่าบริการ',
      DONATION: 'เงินบริจาค',
      OTHER: 'อื่นๆ',
    };

    return (
      <div
        ref={ref}
        className="bg-white p-8 max-w-[210mm] mx-auto receipt-template"
        style={{ 
          fontFamily: 'TH Sarabun New, Sarabun, sans-serif',
          fontSize: '1.5em',
        }}
      >
        {/* Header */}
        <div className="text-center mb-6">
          <div className="flex justify-center mb-3">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={typeof window !== 'undefined' ? `${window.location.origin}/logo.png` : '/logo.png'}
              alt="Logo"
              width={80}
              height={80}
              style={{ objectFit: 'contain', width: '80px', height: '80px' }}
            />
          </div>
          <h1 className="text-2xl font-bold">สมาคมฌาปนกิจสงเคราะห์</h1>
          <h2 className="text-xl">ครูและบุคลากรทางการศึกษาอำเภอแม่ฟ้าหลวง</h2>
          <p className="text-sm text-gray-600 mt-1">
            สำนักงานเขตพื้นที่การศึกษาประถมศึกษาเชียงราย เขต 3
          </p>
        </div>

        {/* Receipt Title - Removed border */}
        <div className="text-center mb-6">
          <h3 className="text-xl font-bold px-8 py-1">
            ใบเสร็จรับเงิน
          </h3>
        </div>

        {/* Receipt Info */}
        <div className="flex justify-between mb-6">
          <div>
            <p><span className="font-semibold">เลขที่:</span> {data.receiptNo}</p>
          </div>
          <div>
            <p><span className="font-semibold">วันที่:</span> {formatThaiDate(data.date)}</p>
          </div>
        </div>

        {/* Member Info */}
        {data.memberName && (
          <div className="mb-4 p-4 bg-gray-50 rounded-lg">
            <div className="grid grid-cols-2 gap-4">
              <p><span className="font-semibold">เลขทะเบียนสมาชิก:</span> {data.memberNo || '-'}</p>
              <p><span className="font-semibold">ชื่อ-นามสกุล:</span> {data.memberName}</p>
              {data.school && (
                <p className="col-span-2"><span className="font-semibold">โรงเรียน:</span> {data.school}</p>
              )}
            </div>
          </div>
        )}

        {/* Receipt Details */}
        <div className="mb-6">
          <table className="w-full border-collapse">
            <thead>
              <tr className="bg-gray-100">
                <th className="border border-gray-300 px-4 py-2 text-left">รายการ</th>
                <th className="border border-gray-300 px-4 py-2 text-right w-32">จำนวนเงิน</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td className="border border-gray-300 px-4 py-3">
                  <p className="font-medium">{typeLabels[data.type] || data.type}</p>
                  {data.description && (
                    <p className="text-sm text-gray-600">{data.description}</p>
                  )}
                </td>
                <td className="border border-gray-300 px-4 py-3 text-right font-semibold">
                  {data.amount.toLocaleString('th-TH', { minimumFractionDigits: 2 })}
                </td>
              </tr>
              <tr className="bg-gray-50">
                <td className="border border-gray-300 px-4 py-3 font-bold text-right">
                  รวมทั้งสิ้น
                </td>
                <td className="border border-gray-300 px-4 py-3 text-right font-bold text-lg">
                  {data.amount.toLocaleString('th-TH', { minimumFractionDigits: 2 })} บาท
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        {/* Amount in words */}
        <div className="mb-6 p-3 bg-blue-50 rounded-lg">
          <p>
            <span className="font-semibold">จำนวนเงิน (ตัวอักษร):</span>{' '}
            <span className="text-blue-800 font-medium">({numberToThaiText(data.amount)})</span>
          </p>
        </div>

        {/* Payment Method */}
        <div className="mb-8">
          <p>
            <span className="font-semibold">ชำระโดย:</span>{' '}
            {data.bankAccount ? `โอนเข้าบัญชี ${data.bankAccount}` : 'เงินสด'}
          </p>
        </div>

        {/* Signature Section */}
        <div className="flex justify-end mt-12">
          <div className="text-center">
            <div className="h-20 flex items-end justify-center mb-2">
              {signature && (
                <img 
                  src={signature} 
                  alt="ลายเซ็น" 
                  className="max-h-16 object-contain"
                />
              )}
            </div>
            <div className="pt-2">
              <p className="font-semibold">{data.receiverName || 'ผู้รับเงิน'}</p>
              <p className="text-sm text-gray-500">(เจ้าหน้าที่การเงิน)</p>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-8 pt-4 border-t border-gray-200 text-center text-xs text-gray-500">
          <p>ใบเสร็จรับเงินฉบับนี้จะสมบูรณ์ต่อเมื่อได้รับเงินเรียบร้อยแล้ว</p>
          <p className="mt-1">สมาคมฌาปนกิจสงเคราะห์ครูและบุคลากรทางการศึกษาอำเภอแม่ฟ้าหลวง</p>
        </div>
      </div>
    );
  }
);

ReceiptTemplate.displayName = 'ReceiptTemplate';

export default ReceiptTemplate;
