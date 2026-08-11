export interface AssistantMessage {
  role: 'user' | 'assistant';
  content: string;
}

const API_BASE = process.env.NEXT_PUBLIC_API_URL || '/api';

export async function streamAssistant(
  messages: AssistantMessage[],
  onDelta: (text: string) => void,
  signal?: AbortSignal,
): Promise<void> {
  const res = await fetch(`${API_BASE}/assistant/chat`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ messages }),
    signal,
  });

  if (res.status === 401) throw new Error('กรุณาเข้าสู่ระบบใหม่');
  if (!res.ok || !res.body) throw new Error('ไม่สามารถเชื่อมต่อผู้ช่วยได้');

  const reader = res.body.getReader();
  const decoder = new TextDecoder();
  let buffer = '';

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });

    const events = buffer.split('\n\n');
    buffer = events.pop() ?? '';

    for (const event of events) {
      const line = event.split('\n').find((l) => l.startsWith('data:'));
      if (!line) continue;
      const data = line.slice('data:'.length).trim();
      if (data === '[DONE]') return;

      let json: unknown;
      try {
        json = JSON.parse(data);
      } catch {
        continue; // frame เพี้ยน/ไม่ครบ — ข้าม ไม่ใช่ error ความหมาย
      }
      if (json && typeof json === 'object') {
        const j = json as { error?: string; delta?: string };
        if (j.error) throw new Error(j.error);
        if (typeof j.delta === 'string') onDelta(j.delta);
      }
    }
  }
}
