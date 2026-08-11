import { OpenRouterClient } from './openrouter.client';

function streamResponse(chunks: string[], status = 200): Response {
  const body = new ReadableStream<Uint8Array>({
    start(controller) {
      const enc = new TextEncoder();
      for (const c of chunks) controller.enqueue(enc.encode(c));
      controller.close();
    },
  });
  return new Response(body, { status });
}

async function collect(gen: AsyncGenerator<string>): Promise<string[]> {
  const out: string[] = [];
  for await (const d of gen) out.push(d);
  return out;
}

describe('OpenRouterClient.streamChat', () => {
  it('yields delta content pieces and stops at [DONE]', async () => {
    const fakeFetch = jest.fn().mockResolvedValue(
      streamResponse([
        'data: {"choices":[{"delta":{"content":"สวัสดี"}}]}\n\n',
        'data: {"choices":[{"delta":{"content":"ครับ"}}]}\n\n',
        'data: [DONE]\n\n',
      ]),
    );
    const client = new OpenRouterClient(fakeFetch as unknown as typeof fetch);
    const deltas = await collect(
      client.streamChat({ apiKey: 'k', model: 'm', messages: [{ role: 'user', content: 'hi' }] }),
    );
    expect(deltas).toEqual(['สวัสดี', 'ครับ']);
  });

  it('handles a single SSE event split across chunks', async () => {
    const fakeFetch = jest.fn().mockResolvedValue(
      streamResponse(['data: {"choices":[{"delta":{"con', 'tent":"A"}}]}\n\n', 'data: [DONE]\n\n']),
    );
    const client = new OpenRouterClient(fakeFetch as unknown as typeof fetch);
    const deltas = await collect(
      client.streamChat({ apiKey: 'k', model: 'm', messages: [] }),
    );
    expect(deltas).toEqual(['A']);
  });

  it('throws when the response is not ok', async () => {
    const fakeFetch = jest.fn().mockResolvedValue(streamResponse(['bad'], 401));
    const client = new OpenRouterClient(fakeFetch as unknown as typeof fetch);
    await expect(collect(client.streamChat({ apiKey: 'k', model: 'm', messages: [] }))).rejects.toThrow(
      /openrouter/i,
    );
  });

  it('cancels the underlying stream when the consumer stops early', async () => {
    let cancelled = false;
    const enc = new TextEncoder();
    const body = new ReadableStream<Uint8Array>({
      start(controller) {
        controller.enqueue(enc.encode('data: {"choices":[{"delta":{"content":"A"}}]}\n\n'));
      },
      cancel() {
        cancelled = true;
      },
    });
    const fakeFetch = jest.fn().mockResolvedValue(new Response(body, { status: 200 }));
    const client = new OpenRouterClient(fakeFetch as unknown as typeof fetch);
    const gen = client.streamChat({ apiKey: 'k', model: 'm', messages: [] });
    const first = await gen.next();
    expect(first.value).toBe('A');
    await gen.return(undefined as never);
    expect(cancelled).toBe(true);
  });
});
