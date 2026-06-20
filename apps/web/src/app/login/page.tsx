'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import { motion } from 'framer-motion';
import Link from 'next/link';
import { LogIn, Eye, EyeOff, ArrowLeft, AlertTriangle } from 'lucide-react';
import { showSuccess, showError } from '@/lib/toast';
import { useAuthStore } from '@/store/auth';
import { api } from '@/lib/api';
import { getApiErrorMessage } from '@/lib/api-error';

export default function LoginPage() {
  const router = useRouter();
  const { setUser } = useAuthStore();
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [apiOnline, setApiOnline] = useState<boolean | null>(null);

  useEffect(() => {
    api.get('/health')
      .then(() => setApiOnline(true))
      .catch(() => setApiOnline(false));
  }, []);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await api.post('/auth/login', { username, password });
      const { user } = response.data;

      setUser(user);
      showSuccess(`ยินดีต้อนรับ, ${user.fullName}`);

      if (user.mustChangePassword) {
        router.push('/change-password');
      } else if (user.role === 'MEMBER' && user.memberId) {
        router.push(`/members/${user.memberId}/profile`);
      } else {
        router.push('/dashboard');
      }
    } catch (error: unknown) {
      showError(getApiErrorMessage(error, 'เข้าสู่ระบบไม่สำเร็จ — ตรวจสอบชื่อผู้ใช้/รหัสผ่าน (admin / 1234)'));
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex">
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-primary-600 via-primary-700 to-emerald-800 relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-0 left-0 w-96 h-96 bg-white rounded-full blur-3xl transform -translate-x-1/2 -translate-y-1/2" />
          <div className="absolute bottom-0 right-0 w-96 h-96 bg-accent-400 rounded-full blur-3xl transform translate-x-1/2 translate-y-1/2" />
        </div>

        <div className="relative z-10 flex flex-col justify-center items-center w-full px-12 text-white">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="text-center"
          >
            <div className="flex items-center justify-center mb-8">
              <Image
                src="/logo.png"
                alt="Logo"
                width={200}
                height={200}
                className="object-contain"
                style={{ background: 'transparent' }}
              />
            </div>
            <h1 className="text-4xl font-display font-bold mb-4">
              สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา
            </h1>
            <p className="text-xl text-primary-100 mb-8">
              อำเภอแม่ฟ้าหลวง จ.เชียงราย
            </p>
            <div className="flex gap-3 justify-center flex-wrap">
              <span className="badge bg-white/20 text-white px-4 py-2">
                จัดการสมาชิก
              </span>
              <span className="badge bg-white/20 text-white px-4 py-2">
                เงินสงเคราะห์
              </span>
              <span className="badge bg-white/20 text-white px-4 py-2">
                รายงานการเงิน
              </span>
            </div>
          </motion.div>
        </div>
      </div>

      <div className="flex-1 flex items-center justify-center p-8 bg-slate-50">
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5 }}
          className="w-full max-w-md"
        >
          <div className="lg:hidden flex items-center justify-center mb-8">
            <Image
              src="/logo.png"
              alt="Logo"
              width={160}
              height={160}
              className="object-contain"
              style={{ background: 'transparent' }}
            />
          </div>

          <Link
            href="/"
            className="inline-flex items-center gap-1.5 text-sm text-slate-500 hover:text-primary-600 mb-6 transition-colors"
          >
            <ArrowLeft size={16} />
            กลับหน้าหลัก
          </Link>

          <div className="card p-8">
            <div className="text-center mb-8">
              <h2 className="text-2xl font-display font-bold text-slate-900">
                เข้าสู่ระบบ
              </h2>
              <p className="text-slate-500 mt-2">
                กรุณากรอกข้อมูลเพื่อเข้าใช้งาน
              </p>
            </div>

            {apiOnline === false && (
              <div className="mb-5 flex gap-3 rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-900">
                <AlertTriangle size={20} className="shrink-0 mt-0.5" />
                <div>
                  <p className="font-medium">API ยังไม่ทำงาน</p>
                  <p className="mt-1 text-amber-800">
                    เปิด terminal แล้วรัน <code className="font-mono text-xs bg-amber-100 px-1 rounded">pnpm dev</code> จากโฟลเดอร์โปรเจกต์
                    หรือ <code className="font-mono text-xs bg-amber-100 px-1 rounded">pnpm dev:api</code> (พอร์ต 3001)
                  </p>
                </div>
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-5">
              <div>
                <label htmlFor="username" className="label">
                  ชื่อผู้ใช้
                </label>
                <input
                  id="username"
                  type="text"
                  className="input"
                  placeholder="กรอกชื่อผู้ใช้"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  autoComplete="username"
                  required
                />
              </div>

              <div>
                <label htmlFor="password" className="label">
                  รหัสผ่าน
                </label>
                <div className="relative">
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    className="input pr-12"
                    placeholder="กรอกรหัสผ่าน"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    autoComplete="current-password"
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                  >
                    {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                  </button>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="btn-primary w-full py-3"
              >
                {loading ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    <LogIn size={20} />
                    เข้าสู่ระบบ
                  </>
                )}
              </button>
            </form>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
