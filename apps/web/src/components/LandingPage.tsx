'use client';

import Image from 'next/image';
import Link from 'next/link';
import { motion } from 'framer-motion';
import {
  LogIn,
  Award,
  PiggyBank,
  Users,
  FileSpreadsheet,
  Shield,
  Building2,
  ChevronRight,
  Landmark,
  HeartHandshake,
  UserPlus,
  FileText,
  Download,
  ScrollText,
} from 'lucide-react';
import { MEMBERSHIP_TYPE_CONFIG, REFERENCE_DOCUMENTS } from '@/lib/membership-register';

const fadeUp = {
  initial: { opacity: 0, y: 24 },
  animate: { opacity: 1, y: 0 },
};

const systems = [
  {
    id: 'association',
    icon: Award,
    badge: 'งานสมาคม',
    title: 'ระบบสมาชิกสมาคมครู',
    subtitle: 'สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา',
    description:
      'ทะเบียนสมาชิกสมาคม ข้อมูลรายบุคคล รายงานการเงิน และงบการเงินของสมาคม อำเภอแม่ฟ้าหลวง',
    features: ['ทะเบียนสมาชิกสมาคม', 'รายงานการเงิน', 'งบดุลและงบกำไรขาดทุน', 'รายงานรายวัน'],
    accent: 'from-primary-600 to-emerald-700',
    ring: 'ring-primary-200',
  },
  {
    id: 'cremation',
    icon: PiggyBank,
    badge: 'งานฌาปนกิจ',
    title: 'ระบบฌาปนกิจสงเคราะห์',
    subtitle: 'กองทุนฌาปนกิจสงเคราะห์สำหรับครูและบุคลากรทางการศึกษา',
    description:
      'บริหารสมาชิกฌาปนกิจ เงินสงเคราะห์รายเดือน แจ้งเสียชีวิต ใบเสร็จและรายงานผู้บริหาร',
    features: ['สมาชิกและเงินสงเคราะห์', 'แจ้งเสียชีวิตและคำนวณศพ', 'ใบเสร็จ / ใบสำคัญจ่าย', 'ภาพรวมผู้บริหาร'],
    accent: 'from-emerald-700 to-primary-800',
    ring: 'ring-emerald-200',
  },
];

const highlights = [
  { icon: Shield, label: 'ข้อมูลปลอดภัย', desc: 'สิทธิ์ผู้ใช้ตามบทบาท' },
  { icon: Landmark, label: 'บัญชีและการเงิน', desc: 'ติดตามรายรับ-รายจ่าย' },
  { icon: Users, label: 'หลายโรงเรียน', desc: 'ครอบคลุมทุกสังกัดในอำเภอ' },
  { icon: FileSpreadsheet, label: 'รายงานครบ', desc: 'สรุปรายวัน รายเดือน รายปี' },
];

export default function LandingPage() {
  return (
    <div className="min-h-screen flex flex-col bg-slate-50">
      {/* Official top bar */}
      <div className="h-1 bg-gradient-to-r from-accent-500 via-accent-400 to-accent-500" />

      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-200 shadow-sm">
        <div className="max-w-6xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">
          <div className="flex items-center gap-3 min-w-0">
            <Image
              src="/logo.png"
              alt="ตราสมาคม"
              width={44}
              height={44}
              className="object-contain shrink-0"
            />
            <div className="min-w-0 hidden sm:block">
              <p className="font-display font-semibold text-slate-900 text-sm leading-tight truncate">
                สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา
              </p>
              <p className="text-xs text-slate-500">อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย</p>
            </div>
          </div>
          <div className="flex items-center gap-2 shrink-0">
            <Link href="/register" className="btn-secondary text-sm py-2.5 px-4 hidden sm:inline-flex">
              <UserPlus size={18} />
              สมัครสมาชิก
            </Link>
            <Link href="/login" className="btn-primary text-sm py-2.5 px-5">
              <LogIn size={18} />
              เข้าสู่ระบบ
            </Link>
          </div>
        </div>
      </header>

      {/* Hero */}
      <section className="relative overflow-hidden min-h-[32rem] sm:min-h-[36rem]">
        <video
          autoPlay
          muted
          loop
          playsInline
          className="absolute inset-0 h-full w-full object-cover"
          aria-hidden
        >
          <source src="/generated_video.mp4" type="video/mp4" />
        </video>
        <div className="absolute inset-0 bg-gradient-to-br from-primary-900/45 via-primary-800/35 to-emerald-900/40" />
        <div
          className="absolute inset-0 opacity-[0.04]"
          style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`,
          }}
        />
        <div className="absolute top-0 right-0 w-96 h-96 bg-accent-400/5 rounded-full blur-3xl" />
        <div className="absolute bottom-0 left-0 w-80 h-80 bg-primary-400/5 rounded-full blur-3xl" />

        <div className="relative max-w-6xl mx-auto px-4 sm:px-6 py-16 sm:py-24 text-center text-white">
          <motion.div {...fadeUp} transition={{ duration: 0.6 }}>
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/10 border border-white/20 text-sm mb-8">
              <Building2 size={16} className="text-accent-300" />
              <span>ระบบบริหารจัดการข้อมูลสมาคมและกองทุนฌาปนกิจ</span>
            </div>

            <div className="flex justify-center mb-8">
              <div className="p-3 rounded-2xl bg-white/10 border border-white/20 backdrop-blur-sm">
                <Image
                  src="/logo.png"
                  alt="Logo"
                  width={120}
                  height={120}
                  className="object-contain"
                  priority
                />
              </div>
            </div>

            <h1 className="font-display text-3xl sm:text-4xl lg:text-5xl font-bold leading-tight max-w-4xl mx-auto mb-4">
              สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา
            </h1>
            <p className="text-lg sm:text-xl text-primary-100 mb-2">อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย</p>
            <p className="text-primary-200/90 max-w-2xl mx-auto mb-10 text-sm sm:text-base">
              ศูนย์กลางข้อมูลดิจิทัลสำหรับงานสมาชิกสมาคมและงานฌาปนกิจสงเคราะห์
              ภายใต้การดูแลของคณะกรรมการสมาคม
            </p>

            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                href="/register"
                className="inline-flex items-center justify-center gap-2 px-8 py-3.5 rounded-xl font-semibold
                  bg-accent-500 text-white hover:bg-accent-400 shadow-lg transition-all active:scale-[0.98]"
              >
                <UserPlus size={20} />
                สมัครสมาชิกฌาปนกิจ
              </Link>
              <Link
                href="/login"
                className="inline-flex items-center justify-center gap-2 px-8 py-3.5 rounded-xl font-semibold
                  bg-white text-primary-800 hover:bg-primary-50 shadow-lg transition-all active:scale-[0.98]"
              >
                <LogIn size={20} />
                เข้าสู่ระบบ
              </Link>
              <a
                href="#documents"
                className="inline-flex items-center justify-center gap-2 px-8 py-3.5 rounded-xl font-medium
                  border border-white/30 text-white hover:bg-white/10 transition-all"
              >
                เอกสารอ้างอิง
                <ChevronRight size={18} />
              </a>
            </div>
          </motion.div>
        </div>

        <div className="absolute bottom-0 left-0 right-0 h-16 bg-gradient-to-t from-slate-50 to-transparent" />
      </section>

      {/* Two systems */}
      <section id="systems" className="max-w-6xl mx-auto px-4 sm:px-6 py-16 sm:py-20">
        <motion.div
          {...fadeUp}
          transition={{ delay: 0.1 }}
          className="text-center mb-12"
        >
          <h2 className="font-display text-2xl sm:text-3xl font-bold text-slate-900 mb-3">
            ระบบงานภายใต้สมาคม
          </h2>
          <p className="text-slate-600 max-w-xl mx-auto">
            เลือกเข้าใช้งานผ่านระบบเดียว หลังยืนยันตัวตน จะแสดงเมนูตามสิทธิ์ของผู้ใช้งาน
          </p>
        </motion.div>

        <div className="grid md:grid-cols-2 gap-6 lg:gap-8">
          {systems.map((sys, i) => {
            const Icon = sys.icon;
            return (
              <motion.article
                key={sys.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                className={`card overflow-hidden ring-2 ${sys.ring} hover:shadow-lg transition-shadow`}
              >
                <div className={`h-2 bg-gradient-to-r ${sys.accent}`} />
                <div className="p-6 sm:p-8">
                  <div className="flex items-start gap-4 mb-5">
                    <div className={`p-3 rounded-xl bg-gradient-to-br ${sys.accent} text-white shadow-md`}>
                      <Icon size={28} />
                    </div>
                    <div>
                      <span className="badge bg-primary-50 text-primary-700 mb-2">{sys.badge}</span>
                      <h3 className="font-display text-xl font-bold text-slate-900">{sys.title}</h3>
                      <p className="text-sm text-primary-700 font-medium mt-1">{sys.subtitle}</p>
                    </div>
                  </div>
                  <p className="text-slate-600 text-sm leading-relaxed mb-6">{sys.description}</p>
                  <ul className="grid grid-cols-2 gap-2">
                    {sys.features.map((f) => (
                      <li
                        key={f}
                        className="flex items-center gap-2 text-sm text-slate-700 bg-slate-50 rounded-lg px-3 py-2"
                      >
                        <span className="w-1.5 h-1.5 rounded-full bg-primary-500 shrink-0" />
                        {f}
                      </li>
                    ))}
                  </ul>
                </div>
              </motion.article>
            );
          })}
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          whileInView={{ opacity: 1 }}
          viewport={{ once: true }}
          className="mt-10 text-center"
        >
          <Link href="/login" className="btn-primary inline-flex px-8 py-3">
            <HeartHandshake size={20} />
            เข้าสู่ระบบเพื่อเริ่มใช้งาน
          </Link>
        </motion.div>
      </section>

      {/* Membership registration */}
      <section id="register" className="bg-gradient-to-b from-primary-50 to-white py-16 sm:py-20 border-y border-primary-100">
        <div className="max-w-6xl mx-auto px-4 sm:px-6">
          <motion.div {...fadeUp} className="text-center mb-12">
            <span className="badge bg-primary-100 text-primary-800 mb-3">สมัครสมาชิกฌาปนกิจ</span>
            <h2 className="font-display text-2xl sm:text-3xl font-bold text-slate-900 mb-3">
              ใบสมัครเข้าเป็นสมาชิกฌาปนกิจสงเคราะห์
            </h2>
            <p className="text-slate-600 max-w-2xl mx-auto">
              เลือกประเภทสมาชิกที่ตรงกับสถานภาพ กรอกใบสมัครออนไลน์ แล้วดาวน์โหลด PDF
              นำไปลงนามและส่งให้กรรมการรับสมัครที่โรงเรียน
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 gap-6">
            {(['ordinary', 'contributory'] as const).map((type, i) => {
              const cfg = MEMBERSHIP_TYPE_CONFIG[type];
              return (
                <motion.article
                  key={type}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.1 }}
                  className="card p-6 sm:p-8 ring-2 ring-primary-100"
                >
                  <div className="flex items-start gap-4 mb-4">
                    <div className="p-3 rounded-xl bg-primary-600 text-white">
                      <UserPlus size={24} />
                    </div>
                    <div>
                      <h3 className="font-display text-lg font-bold text-slate-900">{cfg.memberClass}</h3>
                      <p className="text-sm text-slate-600 mt-1">{cfg.subtitle}</p>
                    </div>
                  </div>
                  <div className="flex flex-col sm:flex-row gap-3 mt-6">
                    <Link href={`/register?type=${type}`} className="btn-primary flex-1 justify-center">
                      <FileText size={18} />
                      กรอกใบสมัครออนไลน์
                    </Link>
                    <a
                      href={cfg.blankPdf}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="btn-secondary flex-1 justify-center"
                    >
                      <Download size={18} />
                      ดาวน์โหลดแบบฟอร์มว่าง
                    </a>
                  </div>
                </motion.article>
              );
            })}
          </div>
        </div>
      </section>

      {/* Reference documents */}
      <section id="documents" className="max-w-6xl mx-auto px-4 sm:px-6 py-16 sm:py-20">
        <motion.div {...fadeUp} className="text-center mb-12">
          <h2 className="font-display text-2xl sm:text-3xl font-bold text-slate-900 mb-3">
            เอกสารอ้างอิง
          </h2>
          <p className="text-slate-600 max-w-xl mx-auto">
            ระเบียบ ข้อบังคับ และแบบฟอร์มต้นฉบับจากคณะกรรมการฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 gap-4">
          {REFERENCE_DOCUMENTS.map((doc, i) => (
            <motion.a
              key={doc.id}
              href={doc.href}
              target="_blank"
              rel="noopener noreferrer"
              initial={{ opacity: 0, y: 12 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.05 }}
              className="card p-5 flex items-start gap-4 hover:shadow-md hover:ring-2 hover:ring-primary-100 transition-all group"
            >
              <div className="p-2.5 rounded-lg bg-slate-100 text-slate-600 group-hover:bg-primary-50 group-hover:text-primary-700 transition-colors">
                {doc.id.startsWith('form') ? <FileText size={22} /> : <ScrollText size={22} />}
              </div>
              <div className="min-w-0 flex-1">
                <h3 className="font-semibold text-slate-900 group-hover:text-primary-800 transition-colors">
                  {doc.title}
                </h3>
                <p className="text-sm text-slate-500 mt-0.5">{doc.subtitle}</p>
                <p className="text-xs text-primary-600 mt-2 flex items-center gap-1">
                  <Download size={14} />
                  เปิด / ดาวน์โหลด PDF ({doc.pages} หน้า)
                </p>
              </div>
            </motion.a>
          ))}
        </div>
      </section>

      {/* Highlights */}
      <section className="bg-white border-y border-slate-200 py-14">
        <div className="max-w-6xl mx-auto px-4 sm:px-6">
          <h2 className="font-display text-xl font-bold text-slate-900 text-center mb-10">
            คุณสมบัติหลักของระบบ
          </h2>
          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {highlights.map((item, i) => {
              const Icon = item.icon;
              return (
                <motion.div
                  key={item.label}
                  initial={{ opacity: 0, y: 12 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: i * 0.05 }}
                  className="text-center p-5"
                >
                  <div className="w-12 h-12 mx-auto mb-3 rounded-xl bg-primary-50 flex items-center justify-center text-primary-600">
                    <Icon size={24} />
                  </div>
                  <h3 className="font-semibold text-slate-900 mb-1">{item.label}</h3>
                  <p className="text-sm text-slate-500">{item.desc}</p>
                </motion.div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="mt-auto bg-slate-800 text-slate-300">
        <div className="h-1 bg-gradient-to-r from-transparent via-accent-500 to-transparent" />
        <div className="max-w-6xl mx-auto px-4 sm:px-6 py-10">
          <div className="flex flex-col sm:flex-row items-center justify-between gap-6">
            <div className="flex items-center gap-4 text-center sm:text-left">
              <Image src="/logo.png" alt="" width={48} height={48} className="opacity-90" />
              <div>
                <p className="font-display font-semibold text-white text-sm">
                  สมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา
                </p>
                <p className="text-xs text-slate-400 mt-1">อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย</p>
              </div>
            </div>
            <Link
              href="/login"
              className="inline-flex items-center gap-2 text-sm text-accent-300 hover:text-accent-200 transition-colors"
            >
              <LogIn size={16} />
              เข้าสู่ระบบสำหรับเจ้าหน้าที่
            </Link>
          </div>
          <p className="text-center text-xs text-slate-500 mt-8 pt-6 border-t border-slate-700">
            ระบบจัดการข้อมูลสมาชิกสมาคมและฌาปนกิจสงเคราะห์ — สำหรับการใช้งานภายในสมาคมเท่านั้น
          </p>
        </div>
      </footer>
    </div>
  );
}