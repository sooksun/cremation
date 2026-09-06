'use client';

import { useCallback, useEffect, useId, useRef } from 'react';
import { X } from 'lucide-react';

/**
 * กล่องโต้ตอบที่ใช้คีย์บอร์ดได้จริง
 *
 * เดิมทุกหน้าเขียน modal เป็น div ซ้อน div แล้วปิดด้วยการคลิกฉากหลังอย่างเดียว
 * คนที่ใช้คีย์บอร์ดหรือโปรแกรมอ่านหน้าจอจึงติดอยู่ข้างในโดยไม่มีทางออก
 * และไม่มีอะไรบอกว่ากำลังอยู่ในกล่องโต้ตอบ
 *
 * ตัวนี้จัดการให้ครบตาม WCAG 2.1 AA
 * - role="dialog" + aria-modal + aria-labelledby บอกบทบาทและชื่อ (4.1.2)
 * - กด Escape ปิดได้ เทียบเท่าการคลิกฉากหลัง (2.1.1)
 * - ขังโฟกัสไว้ในกล่อง Tab วนอยู่ข้างใน ไม่หลุดไปหลังฉาก (2.4.3)
 * - คืนโฟกัสกลับปุ่มที่เปิดกล่องเมื่อปิด (2.4.3)
 * - ฉากหลังเป็นแค่พื้นหลัง ไม่ใช่ปุ่ม จึงไม่ต้องมี tabIndex ให้คนกด Tab หลงเข้าไป
 */
export interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  /** คำอธิบายใต้หัวข้อ อ่านโดยโปรแกรมอ่านหน้าจอด้วย */
  description?: string;
  children: React.ReactNode;
  /** ความกว้างสูงสุดของกล่อง เช่น 'max-w-2xl' */
  size?: string;
  /** ซ่อนปุ่มกากบาทเมื่อกล่องนั้นต้องให้ผู้ใช้ตัดสินใจก่อนเท่านั้น */
  hideCloseButton?: boolean;
}

const FOCUSABLE =
  'a[href], button:not([disabled]), textarea:not([disabled]), input:not([disabled]):not([type="hidden"]), select:not([disabled]), [tabindex]:not([tabindex="-1"])';

export function Modal({
  open,
  onClose,
  title,
  description,
  children,
  size = 'max-w-2xl',
  hideCloseButton = false,
}: ModalProps) {
  const panelRef = useRef<HTMLDivElement>(null);
  const previouslyFocused = useRef<HTMLElement | null>(null);
  const titleId = useId();
  const descriptionId = useId();

  const focusableInPanel = useCallback(() => {
    const panel = panelRef.current;
    if (!panel) return [] as HTMLElement[];
    return Array.from(panel.querySelectorAll<HTMLElement>(FOCUSABLE)).filter(
      (el) => el.offsetParent !== null || el === document.activeElement,
    );
  }, []);

  // จำปุ่มที่เปิดกล่องไว้ แล้วย้ายโฟกัสเข้ามาข้างใน
  useEffect(() => {
    if (!open) return;
    previouslyFocused.current = document.activeElement as HTMLElement | null;

    const first = focusableInPanel()[0];
    (first ?? panelRef.current)?.focus();

    return () => {
      // คืนโฟกัสให้ปุ่มเดิม ไม่งั้นโฟกัสจะตกไปที่ต้นหน้าเมื่อกล่องหายไป
      previouslyFocused.current?.focus?.();
    };
  }, [open, focusableInPanel]);

  // Escape ปิด และ Tab วนอยู่ในกล่อง
  useEffect(() => {
    if (!open) return;

    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.stopPropagation();
        onClose();
        return;
      }
      if (event.key !== 'Tab') return;

      const items = focusableInPanel();
      if (items.length === 0) {
        event.preventDefault();
        return;
      }
      const first = items[0];
      const last = items[items.length - 1];
      const active = document.activeElement;

      if (event.shiftKey && (active === first || !panelRef.current?.contains(active))) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && active === last) {
        event.preventDefault();
        first.focus();
      }
    };

    document.addEventListener('keydown', onKeyDown, true);
    return () => document.removeEventListener('keydown', onKeyDown, true);
  }, [open, onClose, focusableInPanel]);

  // กันหน้าหลังฉากเลื่อนตามขณะกล่องเปิด
  useEffect(() => {
    if (!open) return;
    const previous = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = previous;
    };
  }, [open]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* ฉากหลัง: กดปิดได้ด้วยเมาส์ ส่วนคีย์บอร์ดใช้ Escape ซึ่งจัดการไว้ข้างบน
          ทำเป็น <button> เพื่อไม่ให้เป็น div ที่กดได้แต่ไม่มีบทบาท
          และซ่อนจากโปรแกรมอ่านหน้าจอเพราะเป็นทางลัดของเมาส์ล้วน */}
      <button
        type="button"
        aria-hidden="true"
        tabIndex={-1}
        onClick={onClose}
        className="absolute inset-0 h-full w-full cursor-default bg-black/40"
      />

      <div
        ref={panelRef}
        role="dialog"
        aria-modal="true"
        aria-labelledby={titleId}
        aria-describedby={description ? descriptionId : undefined}
        tabIndex={-1}
        className={`relative z-10 w-full ${size} max-h-[90vh] overflow-y-auto rounded-2xl bg-white p-6 shadow-xl focus:outline-none`}
      >
        <div className="mb-4 flex items-start justify-between gap-4">
          <div>
            <h2 id={titleId} className="text-xl font-semibold text-slate-900">
              {title}
            </h2>
            {description && (
              <p id={descriptionId} className="mt-1 text-sm text-slate-500">
                {description}
              </p>
            )}
          </div>
          {!hideCloseButton && (
            <button
              type="button"
              onClick={onClose}
              aria-label="ปิดหน้าต่าง"
              className="rounded-lg p-2 text-slate-500 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-primary-500"
            >
              <X size={20} aria-hidden="true" />
            </button>
          )}
        </div>

        {children}
      </div>
    </div>
  );
}
