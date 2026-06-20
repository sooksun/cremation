'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { motion } from 'framer-motion';
import { KeyRound, ArrowLeft } from 'lucide-react';
import { showSuccess, showError } from '@/lib/toast';
import { useAuthStore } from '@/store/auth';
import { api } from '@/lib/api';

export default function ChangePasswordPage() {
  const router = useRouter();
  const { user, setUser } = useAuthStore();
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const mustChange = user?.mustChangePassword === true;

  useEffect(() => {
    const checkSession = async () => {
      try {
        const response = await api.get('/auth/me');
        setUser(response.data);
      } catch {
        router.push('/login');
      }
    };
    if (!user) {
      checkSession();
    }
  }, [user, setUser, router]);

  useEffect(() => {
    if (!mustChange) return;
    const onPopState = () => {
      window.history.pushState(null, '', '/change-password');
    };
    window.history.pushState(null, '', '/change-password');
    window.addEventListener('popstate', onPopState);
    return () => window.removeEventListener('popstate', onPopState);
  }, [mustChange]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (newPassword.length < 8) {
      showError('รหัสผ่านใหม่ต้องมีอย่างน้อย 8 ตัวอักษร');
      return;
    }
    if (newPassword !== confirmPassword) {
      showError('รหัสผ่านใหม่ไม่ตรงกัน');
      return;
    }

    setLoading(true);
    try {
      const response = await api.post('/auth/change-password', {
        currentPassword,
        newPassword,
      });
      setUser(response.data.user);
      showSuccess('เปลี่ยนรหัสผ่านสำเร็จ');
      router.push('/dashboard');
    } catch (error: any) {
      showError(error.response?.data?.message || 'เปลี่ยนรหัสผ่านไม่สำเร็จ');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-6">
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        className="card w-full max-w-md p-8"
      >
        {!mustChange && (
          <Link
            href="/dashboard"
            className="inline-flex items-center gap-2 text-sm text-slate-500 hover:text-slate-700 mb-4"
          >
            <ArrowLeft size={16} />
            กลับไปแดชบอร์ด
          </Link>
        )}

        <div className="text-center mb-6">
          <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary-100 text-primary-700 mb-4">
            <KeyRound size={24} />
          </div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            เปลี่ยนรหัสผ่าน
          </h1>
          <p className="text-slate-500 mt-2">
            {mustChange
              ? 'กรุณาตั้งรหัสผ่านใหม่ก่อนเข้าใช้งานระบบ'
              : 'อัปเดตรหัสผ่านของคุณ'}
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="currentPassword" className="label">
              รหัสผ่านปัจจุบัน
            </label>
            <input
              id="currentPassword"
              type="password"
              className="input"
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              required
            />
          </div>
          <div>
            <label htmlFor="newPassword" className="label">
              รหัสผ่านใหม่
            </label>
            <input
              id="newPassword"
              type="password"
              className="input"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              minLength={8}
              required
            />
          </div>
          <div>
            <label htmlFor="confirmPassword" className="label">
              ยืนยันรหัสผ่านใหม่
            </label>
            <input
              id="confirmPassword"
              type="password"
              className="input"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              minLength={8}
              required
            />
          </div>
          <button type="submit" disabled={loading} className="btn-primary w-full py-3">
            {loading ? 'กำลังบันทึก...' : 'บันทึกรหัสผ่านใหม่'}
          </button>
        </form>
      </motion.div>
    </div>
  );
}