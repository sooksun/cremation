'use client';

import { useEffect, useRef, useState } from 'react';
import { MessageCircle, X, Send, Trash2 } from 'lucide-react';
import { useAssistantChat } from './useAssistantChat';
import { ChatMessage } from './ChatMessage';

// คละทั้งฝั่งฌาปนกิจและฝั่งสมาคมฯ ให้ผู้ใช้เห็นตั้งแต่แรกว่าถามได้ทั้งสองเรื่อง
const STARTERS = [
  'ตอนนี้สมาชิกเสียชีวิต ญาติได้เงินเท่าไหร่',
  'ค่าบำรุงสมาคมปีละเท่าไหร่ จ่ายเมื่อไหร่',
  'ขาดส่งเงินกี่ครั้งถึงพ้นสภาพ',
  'นายกสมาคมอยู่ในตำแหน่งได้กี่ปี',
  'ลาออกจากสมาคมแล้ว สิทธิ์ฌาปนกิจหายไหม',
];

export function AssistantWidget() {
  const [open, setOpen] = useState(false);
  const [input, setInput] = useState('');
  const { messages, isStreaming, send, reset } = useAssistantChat();
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight });
  }, [messages]);

  const submit = () => {
    if (!input.trim() || isStreaming) return;
    send(input);
    setInput('');
  };

  return (
    <>
      <button
        onClick={() => setOpen((v) => !v)}
        aria-label="ผู้ช่วยตอบคำถามระเบียบ"
        className="fixed bottom-5 right-5 z-50 w-14 h-14 rounded-full bg-primary-600 text-white shadow-lg flex items-center justify-center hover:bg-primary-700 transition"
      >
        {open ? <X size={24} /> : <MessageCircle size={24} />}
      </button>

      {open && (
        <div className="fixed bottom-24 right-5 z-50 w-[min(92vw,380px)] h-[min(70vh,560px)] bg-white rounded-2xl shadow-2xl border border-slate-200 flex flex-col overflow-hidden">
          <div className="flex items-center justify-between px-4 py-3 border-b border-slate-100 bg-primary-50">
            <div>
              <p className="font-semibold text-slate-800 text-sm">ผู้ช่วยตอบคำถามระเบียบ</p>
              <p className="text-[11px] text-slate-500">ฌาปนกิจ 2568 · สมาคม 2566</p>
            </div>
            <button onClick={reset} title="ล้างการสนทนา" className="p-1.5 rounded-lg hover:bg-white/70 text-slate-500">
              <Trash2 size={16} />
            </button>
          </div>

          <div ref={scrollRef} className="flex-1 overflow-y-auto p-4">
            {messages.length === 0 ? (
              <div className="text-sm text-slate-500">
                <p className="mb-3">ถามเกี่ยวกับระเบียบได้เลย เช่น</p>
                <div className="flex flex-col gap-2">
                  {STARTERS.map((s) => (
                    <button
                      key={s}
                      onClick={() => send(s)}
                      className="text-left text-primary-700 bg-primary-50 hover:bg-primary-100 rounded-xl px-3 py-2 text-sm"
                    >
                      {s}
                    </button>
                  ))}
                </div>
              </div>
            ) : (
              messages.map((m, i) => <ChatMessage key={i} message={m} />)
            )}
          </div>

          <div className="border-t border-slate-100 p-3">
            <div className="flex items-end gap-2">
              <textarea
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    submit();
                  }
                }}
                rows={1}
                maxLength={1000}
                placeholder="พิมพ์คำถาม…"
                className="flex-1 resize-none rounded-xl border border-slate-200 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-primary-200 max-h-24"
              />
              <button
                onClick={submit}
                disabled={isStreaming || !input.trim()}
                className="w-10 h-10 rounded-xl bg-primary-600 text-white flex items-center justify-center disabled:opacity-40"
              >
                <Send size={18} />
              </button>
            </div>
            <p className="text-[10px] text-slate-400 mt-2 text-center">
              อ้างอิงตามระเบียบ พ.ศ. 2568/2566 — กรณีมีข้อสงสัยโปรดยืนยันกับคณะกรรมการ
            </p>
          </div>
        </div>
      )}
    </>
  );
}
