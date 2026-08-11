import { ServiceUnavailableException } from '@nestjs/common';
import { AssistantService } from './assistant.service';
import { OpenRouterClient } from './openrouter.client';
import type { ChatMessage } from './assistant.types';

function fakeClient(deltas: string[]): OpenRouterClient {
  return {
    async *streamChat() {
      for (const d of deltas) yield d;
    },
  } as unknown as OpenRouterClient;
}

async function collect(gen: AsyncGenerator<string>): Promise<string[]> {
  const out: string[] = [];
  for await (const d of gen) out.push(d);
  return out;
}

describe('AssistantService', () => {
  const OLD = process.env;
  beforeEach(() => {
    process.env = { ...OLD, ASSISTANT_ENABLED: '1', OPENROUTER_API_KEY: 'k' };
  });
  afterEach(() => {
    process.env = OLD;
  });

  it('streams deltas from the client when enabled', async () => {
    const svc = new AssistantService(fakeClient(['A', 'B']));
    (svc as unknown as { knowledgeBase: string }).knowledgeBase = 'KB';
    const history: ChatMessage[] = [{ role: 'user', content: 'ถาม' }];
    expect(await collect(svc.chat(history))).toEqual(['A', 'B']);
  });

  it('throws ServiceUnavailable when disabled', async () => {
    process.env.ASSISTANT_ENABLED = '0';
    const svc = new AssistantService(fakeClient([]));
    (svc as unknown as { knowledgeBase: string }).knowledgeBase = 'KB';
    await expect(collect(svc.chat([{ role: 'user', content: 'x' }]))).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
  });

  it('throws ServiceUnavailable when API key is missing', async () => {
    delete process.env.OPENROUTER_API_KEY;
    const svc = new AssistantService(fakeClient([]));
    (svc as unknown as { knowledgeBase: string }).knowledgeBase = 'KB';
    await expect(collect(svc.chat([{ role: 'user', content: 'x' }]))).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
  });
});
