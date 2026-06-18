'use client';

import Link from 'next/link';
import { ShieldOff, ArrowLeft } from 'lucide-react';
import { motion } from 'framer-motion';

export default function AccessDeniedPage() {
  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="min-h-screen bg-slate-50 flex items-center justify-center p-6"
    >
      <div className="card p-8 max-w-md w-full text-center">
        <div className="w-14 h-14 bg-amber-50 rounded-full flex items-center justify-center mx-auto mb-4">
          <ShieldOff className="text-amber-600" size={28} />
        </div>
        <h1 className="text-xl font-display font-bold text-slate-900 mb-2">ไม่มีสิทธิ์เข้าถึง</h1>
        <p className="text-slate-500 mb-6">
          บัญชีของคุณไม่มีสิทธิ์เปิดหน้านี้ หากคิดว่าเป็นข้อผิดพลาด กรุณาติดต่อผู้ดูแลระบบ
        </p>
        <Link href="/dashboard" className="btn-primary inline-flex items-center gap-2">
          <ArrowLeft size={18} />
          กลับหน้าหลัก
        </Link>
      </div>
    </motion.div>
  );
}