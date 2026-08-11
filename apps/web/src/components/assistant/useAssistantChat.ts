'use client';

import { useCallback, useRef, useState } from 'react';
import { streamAssistant, type AssistantMessage } from '@/lib/assistant';

export function useAssistantChat() {
  const [messages, setMessages] = useState<AssistantMessage[]>([]);
  const [isStreaming, setIsStreaming] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const abortRef = useRef<AbortController | null>(null);
  const sendingRef = useRef(false);

  const send = useCallback(
    async (text: string) => {
      const trimmed = text.trim();
      if (!trimmed || isStreaming || sendingRef.current) return;
      sendingRef.current = true;
      setError(null);

      const history: AssistantMessage[] = [...messages, { role: 'user', content: trimmed }];
      setMessages([...history, { role: 'assistant', content: '' }]);
      setIsStreaming(true);

      const abort = new AbortController();
      abortRef.current = abort;

      try {
        await streamAssistant(
          history,
          (delta) => {
            setMessages((prev) => {
              const next = [...prev];
              const last = next[next.length - 1];
              next[next.length - 1] = { ...last, content: last.content + delta };
              return next;
            });
          },
          abort.signal,
        );
      } catch (e) {
        if ((e instanceof DOMException && e.name === 'AbortError') || abort.signal.aborted) {
          return; // ผู้ใช้ยกเลิกเอง (reset) — ไม่ใช่ error
        }
        const msg = e instanceof Error ? e.message : 'เกิดข้อผิดพลาด';
        setError(msg);
        setMessages((prev) => {
          const next = [...prev];
          const last = next[next.length - 1];
          if (last?.role === 'assistant' && last.content === '') {
            next[next.length - 1] = { ...last, content: `⚠️ ${msg}` };
          }
          return next;
        });
      } finally {
        sendingRef.current = false;
        setIsStreaming(false);
        if (abortRef.current === abort) abortRef.current = null;
      }
    },
    [messages, isStreaming],
  );

  const reset = useCallback(() => {
    abortRef.current?.abort();
    setMessages([]);
    setError(null);
    setIsStreaming(false);
  }, []);

  return { messages, isStreaming, error, send, reset };
}
