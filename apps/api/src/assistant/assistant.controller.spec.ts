import { AssistantController } from './assistant.controller';
import { AssistantService } from './assistant.service';
import type { Response } from 'express';

function fakeService(deltas: string[]): AssistantService {
  return {
    async *chat() {
      for (const d of deltas) yield d;
    },
  } as unknown as AssistantService;
}

function fakeRes() {
  const writes: string[] = [];
  const res = {
    setHeader: jest.fn(),
    flushHeaders: jest.fn(),
    write: jest.fn((chunk: string) => {
      writes.push(chunk);
      return true;
    }),
    end: jest.fn(),
    on: jest.fn(),
  } as unknown as Response;
  return { res, writes };
}

describe('AssistantController.chat', () => {
  it('writes each delta as an SSE data frame then closes with [DONE]', async () => {
    const ctrl = new AssistantController(fakeService(['ก', 'ข']));
    const { res, writes } = fakeRes();
    await ctrl.chat({ messages: [{ role: 'user', content: 'ถาม' }] }, res);

    expect(res.setHeader).toHaveBeenCalledWith('Content-Type', 'text/event-stream');
    expect(writes.join('')).toContain('data: {"delta":"ก"}');
    expect(writes.join('')).toContain('data: {"delta":"ข"}');
    expect(writes.join('')).toContain('data: [DONE]');
    expect(res.end).toHaveBeenCalled();
  });

  it('emits an SSE error frame when the service throws', async () => {
    const throwing = {
      async *chat() {
        throw new Error('boom');
      },
    } as unknown as AssistantService;
    const ctrl = new AssistantController(throwing);
    const { res, writes } = fakeRes();
    await ctrl.chat({ messages: [{ role: 'user', content: 'x' }] }, res);
    expect(writes.join('')).toContain('data: {"error"');
    expect(res.end).toHaveBeenCalled();
  });
});
