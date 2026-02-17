'use client';

import { useState, useRef } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { Settings, PenTool, X, Check, Save } from 'lucide-react';
import dynamic from 'next/dynamic';
import { api } from '@/lib/api';
import { showSuccess, showError } from '@/lib/toast';
import { useAuthStore } from '@/store/auth';

// Dynamically import SignatureCanvas to avoid SSR issues
const SignatureCanvas = dynamic(
  () => import('react-signature-canvas'),
  { ssr: false }
) as any;

export default function SignatureSettingsPage() {
  const { user } = useAuthStore();
  const queryClient = useQueryClient();
  const sigCanvas = useRef<any>(null);
  const [showSignModal, setShowSignModal] = useState(false);

  // Get current user signature
  const { data: currentUser, isLoading } = useQuery({
    queryKey: ['auth', 'me'],
    queryFn: async () => {
      const response = await api.get('/auth/me');
      return response.data;
    },
  });

  // Update signature mutation
  const updateSignatureMutation = useMutation({
    mutationFn: async (signature: string) => {
      const response = await api.post('/auth/me/signature', { signature });
      return response.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['auth', 'me'] });
      showSuccess('บันทึกลายเซ็นสำเร็จ');
      setShowSignModal(false);
    },
    onError: () => {
      showError('เกิดข้อผิดพลาดในการบันทึกลายเซ็น');
    },
  });

  // Clear signature
  const clearSignature = () => {
    if (sigCanvas.current) {
      sigCanvas.current.clear();
    }
  };

  // Save signature
  const saveSignature = () => {
    if (sigCanvas.current && !sigCanvas.current.isEmpty()) {
      // Get the canvas element
      const canvas = sigCanvas.current.getCanvas();
      
      // Create a new canvas with transparent background
      const newCanvas = document.createElement('canvas');
      newCanvas.width = canvas.width;
      newCanvas.height = canvas.height;
      const ctx = newCanvas.getContext('2d');
      
      if (ctx) {
        // Clear with transparent background
        ctx.clearRect(0, 0, newCanvas.width, newCanvas.height);
        
        // Draw the signature on transparent background
        ctx.drawImage(canvas, 0, 0);
        
        // Export as PNG with transparent background
        const dataUrl = newCanvas.toDataURL('image/png');
        updateSignatureMutation.mutate(dataUrl);
      } else {
        // Fallback to original method
        const dataUrl = sigCanvas.current.toDataURL('image/png');
        updateSignatureMutation.mutate(dataUrl);
      }
    } else {
      showError('กรุณาลงลายเซ็นก่อน');
    }
  };

  // Clear existing signature
  const clearExistingSignature = () => {
    if (confirm('คุณต้องการลบลายเซ็นปัจจุบันหรือไม่?')) {
      updateSignatureMutation.mutate('');
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 10 }}
      animate={{ opacity: 1, y: 0 }}
      className="space-y-6"
    >
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-display font-bold text-slate-900">
            การจัดการลายเซ็น
          </h1>
          <p className="text-slate-500 mt-1">
            ลงลายเซ็นอิเล็กทรอนิกส์สำหรับเจ้าหน้าที่การเงิน / ผู้รับเงิน
          </p>
        </div>
      </div>

      {/* Info Card */}
      <div className="card p-6 bg-blue-50 border-blue-200">
        <h3 className="font-semibold text-blue-900 mb-3 flex items-center gap-2">
          <Settings className="w-5 h-5" />
          ข้อมูลลายเซ็น
        </h3>
        <div className="space-y-2 text-sm text-blue-800">
          <p>
            <strong>ชื่อผู้ใช้:</strong> {currentUser?.fullName || user?.fullName}
          </p>
          <p>
            <strong>บทบาท:</strong> {currentUser?.role === 'FINANCE' ? 'เจ้าหน้าที่การเงิน' : currentUser?.role === 'ADMIN' ? 'ผู้ดูแลระบบ' : currentUser?.role}
          </p>
          <p className="mt-2">
            ลายเซ็นนี้จะถูกใช้ในใบเสร็จรับเงินทั้งหมดโดยอัตโนมัติ
          </p>
        </div>
      </div>

      {/* Current Signature */}
      <div className="card p-6">
        <h3 className="font-semibold text-slate-900 mb-4">ลายเซ็นปัจจุบัน</h3>
        {currentUser?.signature ? (
          <div className="space-y-4">
            <div className="border-2 border-slate-200 rounded-lg p-4 bg-slate-50 flex items-center justify-center min-h-[150px]">
              <img
                src={currentUser.signature}
                alt="ลายเซ็นปัจจุบัน"
                className="max-h-32 object-contain"
              />
            </div>
            <div className="flex gap-3">
              <button
                onClick={() => setShowSignModal(true)}
                className="btn-primary flex-1"
              >
                <PenTool size={18} />
                แก้ไขลายเซ็น
              </button>
              <button
                onClick={clearExistingSignature}
                className="btn-secondary"
              >
                <X size={18} />
                ลบลายเซ็น
              </button>
            </div>
          </div>
        ) : (
          <div className="space-y-4">
            <div className="border-2 border-dashed border-slate-300 rounded-lg p-8 bg-slate-50 flex items-center justify-center min-h-[150px]">
              <p className="text-slate-400 text-center">
                ยังไม่มีลายเซ็น<br />
                กรุณาลงลายเซ็นเพื่อใช้งาน
              </p>
            </div>
            <button
              onClick={() => setShowSignModal(true)}
              className="btn-primary w-full"
            >
              <PenTool size={18} />
              ลงลายเซ็น
            </button>
          </div>
        )}
      </div>

      {/* Signature Modal */}
      {showSignModal && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <motion.div
            initial={{ scale: 0.95, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            className="bg-white rounded-2xl w-full max-w-lg p-6 shadow-xl"
          >
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold">ลงลายเซ็นอิเล็กทรอนิกส์</h2>
              <button
                onClick={() => setShowSignModal(false)}
                className="p-2 hover:bg-slate-100 rounded-lg"
              >
                <X size={20} />
              </button>
            </div>

            <div className="border-2 border-dashed border-slate-300 rounded-xl mb-4 bg-slate-50">
              <SignatureCanvas
                ref={sigCanvas}
                canvasProps={{
                  width: 460,
                  height: 200,
                  className: 'signature-canvas rounded-xl',
                  style: { width: '100%', height: '200px', backgroundColor: 'transparent' },
                }}
                backgroundColor="transparent"
                penColor="black"
              />
            </div>

            <p className="text-sm text-slate-500 mb-4 text-center">
              ใช้เมาส์หรือนิ้วในการลงลายเซ็น
            </p>

            <div className="flex gap-3">
              <button
                onClick={clearSignature}
                className="btn-secondary flex-1"
              >
                ล้าง
              </button>
              <button
                onClick={saveSignature}
                disabled={updateSignatureMutation.isPending}
                className="btn-primary flex-1"
              >
                {updateSignatureMutation.isPending ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    <Check size={18} />
                    บันทึกลายเซ็น
                  </>
                )}
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </motion.div>
  );
}

