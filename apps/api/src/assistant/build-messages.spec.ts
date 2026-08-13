import { buildSystemPrompt, buildChatMessages, MAX_HISTORY_MESSAGES } from './build-messages';
import type { ChatMessage } from './assistant.types';

describe('buildSystemPrompt', () => {
  it('embeds the knowledge base and the out-of-scope guardrail', () => {
    const sys = buildSystemPrompt('KB_CONTENT_MARKER', null);
    expect(sys).toContain('KB_CONTENT_MARKER');
    expect(sys).toContain('ไม่พบข้อกำหนดนี้ในเอกสารที่มี');
  });
});

describe('buildChatMessages', () => {
  it('prepends a system message built from the KB', () => {
    const out = buildChatMessages('KB_MARKER', [{ role: 'user', content: 'สวัสดี' }]);
    expect(out[0].role).toBe('system');
    expect(out[0].content).toContain('KB_MARKER');
    expect(out[1]).toEqual({ role: 'user', content: 'สวัสดี' });
  });

  it('truncates history to the last MAX_HISTORY_MESSAGES', () => {
    const history: ChatMessage[] = Array.from({ length: 30 }, (_, i) => ({
      role: i % 2 === 0 ? 'user' : 'assistant',
      content: `m${i}`,
    }));
    const out = buildChatMessages('KB', history);
    // 1 system + 20 history
    expect(out).toHaveLength(1 + MAX_HISTORY_MESSAGES);
    expect(out[1].content).toBe('m10');
    expect(out[out.length - 1].content).toBe('m29');
  });
});
