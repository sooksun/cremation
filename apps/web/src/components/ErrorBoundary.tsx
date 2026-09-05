'use client';

import { Component, type ReactNode } from 'react';
import { usePathname } from 'next/navigation';
import { AlertTriangle, RefreshCw } from 'lucide-react';

interface Props {
  children: ReactNode;
  /** เปลี่ยนค่าเมื่อไหร่ boundary จะรีเซ็ตตัวเอง — ใช้ pathname เพื่อให้ย้ายหน้าแล้วหายพัง */
  resetKey?: string;
}

interface State {
  hasError: boolean;
}

class ErrorBoundaryInner extends Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  // เดิม boundary นี้ครอบทั้งแอปและล้างสถานะได้ทางเดียวคือ window.location.reload()
  // ทำให้ error ครั้งเดียวค้างทั้ง SPA จนกว่าจะรีโหลด แม้ผู้ใช้จะกดไปหน้าอื่นแล้ว
  componentDidUpdate(prevProps: Props) {
    if (this.state.hasError && prevProps.resetKey !== this.props.resetKey) {
      this.setState({ hasError: false });
    }
  }

  handleRetry = () => {
    this.setState({ hasError: false });
    window.location.reload();
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-[60vh] flex items-center justify-center p-6">
          <div className="card p-8 max-w-md w-full text-center">
            <div className="w-14 h-14 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-4">
              <AlertTriangle className="text-red-600" size={28} />
            </div>
            <h2 className="text-xl font-semibold text-slate-900 mb-2">เกิดข้อผิดพลาด</h2>
            <p className="text-slate-500 mb-6">
              ระบบไม่สามารถแสดงหน้านี้ได้ กรุณาลองใหม่อีกครั้ง
            </p>
            <button type="button" onClick={this.handleRetry} className="btn-primary inline-flex items-center gap-2">
              <RefreshCw size={18} />
              โหลดหน้าใหม่
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}

export default function ErrorBoundary({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  return <ErrorBoundaryInner resetKey={pathname}>{children}</ErrorBoundaryInner>;
}