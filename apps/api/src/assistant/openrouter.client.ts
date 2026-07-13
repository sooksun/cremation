import type { ChatMessage } from './assistant.types';

const OPENROUTER_URL = 'https://openrouter.ai/api/v1/chat/completions';

export interface StreamChatParams {
  apiKey: string;
  model: string;
  messages: ChatMessage[];
  signal?: AbortSignal;
}

export class OpenRouterClient {
  constructor(private readonly fetchFn: typeof fetch = fetch) {}

  async *streamChat(params: StreamChatParams): AsyncGenerator<string> {
    const res = await this.fetchFn(OPENROUTER_URL, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${params.apiKey}`,
        'Content-Type': 'application/json',
        ...(process.env.OPENROUTER_APP_URL ? { 'HTTP-Referer': process.env.OPENROUTER_APP_URL } : {}),
        ...(process.env.OPENROUTER_APP_TITLE ? { 'X-Title': process.env.OPENROUTER_APP_TITLE } : {}),
      },
      body: JSON.stringify({ model: params.model, messages: params.messages, stream: true }),
      signal: params.signal,
    });

    if (!res.ok || !res.body) {
      const detail = res.body ? await res.text().catch(() => '') : '';
      throw new Error(`OpenRouter request failed (${res.status}) ${detail}`.trim());
    }

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
        try {
          const json = JSON.parse(data);
          const delta = json?.choices?.[0]?.delta?.content;
          if (typeof delta === 'string' && delta.length > 0) yield delta;
        } catch {
          // ข้าม event ที่ parse ไม่ได้ (เช่น comment/keep-alive)
        }
      }
    }
  }
}
