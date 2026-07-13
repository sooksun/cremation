# Regulation Assistant Chatbot — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** เพิ่ม AI chatbot ที่ตอบคำถามเกี่ยวกับเนื้อหาระเบียบฌาปนกิจสงเคราะห์ พ.ศ. 2568 และข้อบังคับสมาคม พ.ศ. 2566 ให้ผู้ใช้ทุก role ที่ login แล้ว

**Architecture:** Backend NestJS module `assistant` เป็น stateless proxy — โหลดเนื้อหาระเบียบ (markdown ที่ถอดจาก PDF ล่วงหน้า) เข้า memory แล้วยัดลง system prompt ทั้งก้อน (prompt-stuffing, ไม่มี vector RAG) เรียก OpenRouter แบบ streaming แล้ว pipe คำตอบกลับ frontend ผ่าน SSE Frontend เป็น floating chat widget ที่ mount ในทุกหน้า dashboard เก็บ state แบบ ephemeral

**Tech Stack:** NestJS + `@nestjs/throttler`, global `fetch`/`ReadableStream` (Node 22, ไม่มี http lib เพิ่ม), OpenRouter API, Next.js 15 App Router + `react-markdown` (dependency ใหม่ 1 ตัว), jest (API เท่านั้น — web ไม่มี test infra)

## Global Constraints

- **ห้ามแตะฐานข้อมูล** — module `assistant` ต้องไม่ import `PrismaModule`/`PrismaService` และไม่ query DB ใด ๆ (ปลอดภัยโดยการออกแบบ)
- **API key ฝั่ง server เท่านั้น** — `OPENROUTER_API_KEY` อ่านจาก env ใน backend เท่านั้น ห้ามส่งไป client ห้าม hardcode ห้าม commit
- **ขอบเขตคำตอบ** — ตอบเฉพาะจากเนื้อหาระเบียบที่ให้ไว้; ถ้าไม่มีในระเบียบให้ตอบว่า "ไม่พบข้อกำหนดนี้ในระเบียบ"; ห้ามตอบเรื่องข้อมูลสมาชิกจริง/การใช้งานระบบ/เรื่องทั่วไปนอกระเบียบ
- **Endpoint จริง** = `POST /api/assistant/chat` (global prefix `api` จาก `main.ts:84`)
- **Auth** = JWT ใน httpOnly cookie ชื่อ `cremation_token`; frontend ใช้ `credentials: 'include'`; endpoint ต้องมี `@AllowViewerWrite()` เพื่อยกเว้น global `ViewerReadOnlyGuard` (ไม่งั้น role VIEWER ถูกบล็อกเพราะเป็น POST)
- **Default model** = `google/gemini-2.5-flash` (override ผ่าน env `OPENROUTER_MODEL`)
- **Input cap** = แต่ละ message ≤ 1,000 ตัวอักษร; history ที่ส่งเข้า model ≤ 20 messages (10 คู่)
- **Rate limit** = 20 requests/นาที ต่อผู้ใช้ ที่ endpoint นี้ (`@Throttle`)
- **ภาษา** = คำอธิบาย/comment/UI เป็นภาษาไทย, identifier เป็นอังกฤษ ตาม convention โปรเจกต์
- **Money/domain accuracy** — ตอน verify KB ต้องตรวจเลขข้อ/มาตรา, อัตราเงิน (100/50 บาท), เงื่อนไขวัน ให้ตรง PDF ต้นฉบับ

---

## Task 1: ถอดเนื้อหาระเบียบจาก PDF เป็น markdown (Knowledge Base)

งานเตรียมข้อมูล ไม่ใช่ TDD — deliverable คือไฟล์ markdown ที่ถอดถูกต้อง verify ด้วยการเทียบ PDF ต้นฉบับ

**Files:**
- Create: `apps/api/src/assistant/knowledge/01-regulation-cremation-2568.md`
- Create: `apps/api/src/assistant/knowledge/02-association-bylaws-2566.md`
- Create: `apps/api/src/assistant/knowledge/03-application-forms.md`

**Interfaces:**
- Produces: ไฟล์ `.md` 3 ไฟล์ในโฟลเดอร์ `apps/api/src/assistant/knowledge/` ที่ Task 3 (`loadKnowledgeBase`) จะอ่าน

- [ ] **Step 1: ถอด `doc/ref1.pdf` เป็น markdown**

อ่าน `doc/ref1.pdf` ด้วย vision (Read tool รองรับ PDF โดยตรง — render เป็นภาพให้อ่าน ไม่ใช่ text extraction ที่เพี้ยน) แล้วเขียนเป็น `01-regulation-cremation-2568.md` โดยขึ้นต้นด้วยหัวเรื่อง:

```markdown
# ระเบียบว่าด้วยฌาปนกิจสงเคราะห์ข้าราชการครูและบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง พ.ศ. 2568

> แหล่งที่มา: doc/ref1.pdf

(เนื้อหาระเบียบทั้งฉบับ รักษาโครงสร้าง หมวด / ข้อ / วรรค ให้ตรงต้นฉบับ)
```

รักษาเลข "ข้อ N" ทุกข้อ, ตัวเลขเงิน/อัตรา, และเงื่อนไขวันให้ครบและตรง

- [ ] **Step 2: ถอด `doc/ref2.pdf` เป็น markdown**

อ่าน `doc/ref2.pdf` ด้วย vision → เขียน `02-association-bylaws-2566.md`:

```markdown
# ข้อบังคับสมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง พ.ศ. 2566

> แหล่งที่มา: doc/ref2.pdf

(เนื้อหาข้อบังคับทั้งฉบับ รักษาโครงสร้าง หมวด / ข้อ)
```

- [ ] **Step 3: ถอดใบสมัคร `doc/ref1-1.pdf` + `doc/ref1-2.pdf` เป็น markdown**

อ่านทั้งสองไฟล์ด้วย vision → รวมเป็น `03-application-forms.md` (สองหัวข้อย่อยในไฟล์เดียว):

```markdown
# ใบสมัครสมาชิกฌาปนกิจสงเคราะห์ครูแม่ฟ้าหลวง

> แหล่งที่มา: doc/ref1-1.pdf (สมาชิกสามัญ), doc/ref1-2.pdf (สมาชิกสมทบ)

## ใบสมัครสมาชิกสามัญ
(รายการช่อง/ข้อมูลที่ต้องกรอก + เอกสารแนบที่ระบุในฟอร์ม)

## ใบสมัครสมาชิกสมทบ
(รายการช่อง/ข้อมูลที่ต้องกรอก + เอกสารแนบที่ระบุในฟอร์ม)
```

- [ ] **Step 4: Verify — สุ่มตรวจความถูกต้องเทียบ PDF**

เปิด `doc/ref1.pdf` และ `doc/ref2.pdf` ด้วย vision อีกครั้ง ตรวจอย่างน้อย:
- เลข "ข้อ" สุดท้ายของแต่ละฉบับตรงกับ markdown (ไม่ตกข้อ)
- อัตราเงินสงเคราะห์ (เช่น 100 บาท สามัญ / 50 บาท สมทบ) และเปอร์เซ็นต์การกัน (10%) ตรงต้นฉบับ
- เงื่อนไขจำนวนครั้งที่ขาดส่งจนพ้นสภาพ (สมาชิกสมทบ) ตรงต้นฉบับ

แก้ markdown ให้ตรงถ้าพบคลาดเคลื่อน

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/assistant/knowledge/
git commit -m "feat(assistant): regulation knowledge base (markdown from ref1/ref2 PDFs)"
```

---

## Task 2: ตั้งค่า nest-cli ให้ copy ไฟล์ `.md` ไป dist + type ร่วม

**Files:**
- Modify: `apps/api/nest-cli.json`
- Create: `apps/api/src/assistant/assistant.types.ts`

**Interfaces:**
- Produces: `ChatRole` = `'system' | 'user' | 'assistant'`; `ChatMessage` = `{ role: ChatRole; content: string }` — ใช้ทุก task ถัดไป

- [ ] **Step 1: เพิ่ม assets config ใน `nest-cli.json`**

แก้ `apps/api/nest-cli.json` เป็น:

```json
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true,
    "tsConfigPath": "tsconfig.build.json",
    "assets": [{ "include": "assistant/knowledge/*.md", "outDir": "dist" }],
    "watchAssets": true
  }
}
```

- [ ] **Step 2: สร้าง type ร่วม**

สร้าง `apps/api/src/assistant/assistant.types.ts`:

```typescript
export type ChatRole = 'system' | 'user' | 'assistant';

export interface ChatMessage {
  role: ChatRole;
  content: string;
}
```

- [ ] **Step 3: Commit**

```bash
git add apps/api/nest-cli.json apps/api/src/assistant/assistant.types.ts
git commit -m "chore(assistant): copy knowledge md to dist + shared chat types"
```

---

## Task 3: KnowledgeLoader — โหลด markdown เข้า memory

**Files:**
- Create: `apps/api/src/assistant/knowledge-loader.ts`
- Test: `apps/api/src/assistant/knowledge-loader.spec.ts`

**Interfaces:**
- Produces: `loadKnowledgeBase(dir: string): string` — อ่านไฟล์ `*.md` ทุกไฟล์ในโฟลเดอร์ (เรียงตามชื่อ) ต่อกันด้วยตัวคั่น `\n\n---\n\n`; โยน `Error` ถ้าไม่พบไฟล์ `.md` เลย

- [ ] **Step 1: เขียน failing test**

สร้าง `apps/api/src/assistant/knowledge-loader.spec.ts`:

```typescript
import { mkdtempSync, writeFileSync, rmSync } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';
import { loadKnowledgeBase } from './knowledge-loader';

describe('loadKnowledgeBase', () => {
  let dir: string;
  beforeEach(() => {
    dir = mkdtempSync(join(tmpdir(), 'kb-'));
  });
  afterEach(() => {
    rmSync(dir, { recursive: true, force: true });
  });

  it('concatenates all .md files sorted by name with separators', () => {
    writeFileSync(join(dir, '02-b.md'), 'BODY_B');
    writeFileSync(join(dir, '01-a.md'), 'BODY_A');
    const result = loadKnowledgeBase(dir);
    expect(result).toBe('BODY_A\n\n---\n\nBODY_B');
  });

  it('ignores non-md files', () => {
    writeFileSync(join(dir, '01-a.md'), 'BODY_A');
    writeFileSync(join(dir, 'note.txt'), 'IGNORE');
    expect(loadKnowledgeBase(dir)).toBe('BODY_A');
  });

  it('throws when no .md files are found', () => {
    expect(() => loadKnowledgeBase(dir)).toThrow(/no knowledge/i);
  });
});
```

- [ ] **Step 2: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/assistant/knowledge-loader.spec.ts`
Expected: FAIL — "Cannot find module './knowledge-loader'"

- [ ] **Step 3: เขียน implementation**

สร้าง `apps/api/src/assistant/knowledge-loader.ts`:

```typescript
import { readdirSync, readFileSync } from 'fs';
import { join } from 'path';

export function loadKnowledgeBase(dir: string): string {
  const files = readdirSync(dir)
    .filter((f) => f.toLowerCase().endsWith('.md'))
    .sort();

  if (files.length === 0) {
    throw new Error(`No knowledge (.md) files found in ${dir}`);
  }

  return files
    .map((f) => readFileSync(join(dir, f), 'utf-8').trim())
    .join('\n\n---\n\n');
}
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx jest src/assistant/knowledge-loader.spec.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/assistant/knowledge-loader.ts apps/api/src/assistant/knowledge-loader.spec.ts
git commit -m "feat(assistant): knowledge-base loader with fail-fast on empty dir"
```

---

## Task 4: System prompt + ประกอบ message array

**Files:**
- Create: `apps/api/src/assistant/system-prompt.ts`
- Create: `apps/api/src/assistant/build-messages.ts`
- Test: `apps/api/src/assistant/build-messages.spec.ts`

**Interfaces:**
- Consumes: `ChatMessage` จาก `assistant.types.ts`
- Produces:
  - `buildSystemPrompt(knowledgeBase: string): string` — ประกอบ guardrails + KB; มี sentinel string `ไม่พบข้อกำหนดนี้ในระเบียบ` และ `เนื้อหาระเบียบ`
  - `MAX_HISTORY_MESSAGES = 20`
  - `buildChatMessages(knowledgeBase: string, history: ChatMessage[]): ChatMessage[]` — คืน `[system, ...historyTail]` โดย historyTail = history 20 ตัวท้าย

- [ ] **Step 1: เขียน failing test**

สร้าง `apps/api/src/assistant/build-messages.spec.ts`:

```typescript
import { buildSystemPrompt, buildChatMessages, MAX_HISTORY_MESSAGES } from './build-messages';
import type { ChatMessage } from './assistant.types';

describe('buildSystemPrompt', () => {
  it('embeds the knowledge base and the out-of-scope guardrail', () => {
    const sys = buildSystemPrompt('KB_CONTENT_MARKER');
    expect(sys).toContain('KB_CONTENT_MARKER');
    expect(sys).toContain('ไม่พบข้อกำหนดนี้ในระเบียบ');
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
```

- [ ] **Step 2: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/assistant/build-messages.spec.ts`
Expected: FAIL — "Cannot find module './build-messages'"

- [ ] **Step 3: เขียน implementation**

สร้าง `apps/api/src/assistant/system-prompt.ts`:

```typescript
export function buildSystemPrompt(knowledgeBase: string): string {
  return [
    'คุณคือผู้ช่วยตอบคำถามเกี่ยวกับ "ระเบียบ" ของสมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง',
    '',
    'กติกาการตอบ (สำคัญมาก ห้ามฝ่าฝืน):',
    '1. ตอบโดยอ้างอิงจาก "เนื้อหาระเบียบ" ที่ให้ไว้ด้านล่างเท่านั้น',
    '2. ถ้าคำถามไม่มีคำตอบอยู่ในระเบียบ ให้ตอบว่า "ไม่พบข้อกำหนดนี้ในระเบียบ" แล้วแนะนำให้สอบถามคณะกรรมการ ห้ามเดาหรือแต่งข้อมูลขึ้นเอง',
    '3. ทุกครั้งที่อ้างอิง ให้ระบุเลขข้อ/มาตรา/หมวด ที่เกี่ยวข้อง (เช่น "ตามข้อ 12 วรรคสอง")',
    '4. ห้ามตอบเรื่องข้อมูลสมาชิกจริง ยอดเงินจริง หรือวิธีใช้งานระบบซอฟต์แวร์ เพราะคุณเข้าถึงเฉพาะตัวบทระเบียบเท่านั้น',
    '5. ตอบเป็นภาษาไทย กระชับ ชัดเจน',
    '',
    '===== เนื้อหาระเบียบ =====',
    knowledgeBase,
    '===== จบเนื้อหาระเบียบ =====',
  ].join('\n');
}
```

สร้าง `apps/api/src/assistant/build-messages.ts`:

```typescript
import type { ChatMessage } from './assistant.types';
import { buildSystemPrompt } from './system-prompt';

export const MAX_HISTORY_MESSAGES = 20;

export { buildSystemPrompt };

export function buildChatMessages(
  knowledgeBase: string,
  history: ChatMessage[],
): ChatMessage[] {
  const tail = history.slice(-MAX_HISTORY_MESSAGES);
  return [{ role: 'system', content: buildSystemPrompt(knowledgeBase) }, ...tail];
}
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx jest src/assistant/build-messages.spec.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/assistant/system-prompt.ts apps/api/src/assistant/build-messages.ts apps/api/src/assistant/build-messages.spec.ts
git commit -m "feat(assistant): system prompt guardrails + message assembly with history cap"
```

---

## Task 5: OpenRouterClient — เรียก OpenRouter แบบ streaming

**Files:**
- Create: `apps/api/src/assistant/openrouter.client.ts`
- Test: `apps/api/src/assistant/openrouter.client.spec.ts`

**Interfaces:**
- Consumes: `ChatMessage` จาก `assistant.types.ts`
- Produces: `class OpenRouterClient`
  - constructor: `new OpenRouterClient(fetchFn: typeof fetch = fetch)`
  - method: `streamChat(params: { apiKey: string; model: string; messages: ChatMessage[]; signal?: AbortSignal }): AsyncGenerator<string>` — yield เฉพาะ `choices[0].delta.content` ทีละชิ้น; หยุดเมื่อเจอ `data: [DONE]`; โยน `Error` ถ้า response ไม่ ok

- [ ] **Step 1: เขียน failing test**

สร้าง `apps/api/src/assistant/openrouter.client.spec.ts`:

```typescript
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
});
```

- [ ] **Step 2: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/assistant/openrouter.client.spec.ts`
Expected: FAIL — "Cannot find module './openrouter.client'"

- [ ] **Step 3: เขียน implementation**

สร้าง `apps/api/src/assistant/openrouter.client.ts`:

```typescript
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
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx jest src/assistant/openrouter.client.spec.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/assistant/openrouter.client.ts apps/api/src/assistant/openrouter.client.spec.ts
git commit -m "feat(assistant): OpenRouter streaming client (SSE parse, chunk-boundary safe)"
```

---

## Task 6: AssistantService + config accessor

**Files:**
- Create: `apps/api/src/assistant/assistant.config.ts`
- Create: `apps/api/src/assistant/assistant.service.ts`
- Test: `apps/api/src/assistant/assistant.service.spec.ts`

**Interfaces:**
- Consumes: `loadKnowledgeBase`, `buildChatMessages`, `OpenRouterClient`, `ChatMessage`
- Produces:
  - `getAssistantConfig(): { enabled: boolean; apiKey: string; model: string }` — อ่าน env (`ASSISTANT_ENABLED`, `OPENROUTER_API_KEY`, `OPENROUTER_MODEL` default `google/gemini-2.5-flash`)
  - `class AssistantService` (`@Injectable`):
    - `onModuleInit()` — โหลด KB จาก `join(__dirname, 'knowledge')` เก็บใน field
    - `chat(history: ChatMessage[]): AsyncGenerator<string>` — โยน `ServiceUnavailableException` ถ้า `enabled=false` หรือไม่มี `apiKey`; ไม่งั้น delegate ไป `OpenRouterClient.streamChat`
    - รับ `OpenRouterClient` ผ่าน constructor (ค่า default `new OpenRouterClient()`) เพื่อ mock ใน test

- [ ] **Step 1: เขียน failing test**

สร้าง `apps/api/src/assistant/assistant.service.spec.ts`:

```typescript
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
```

- [ ] **Step 2: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/assistant/assistant.service.spec.ts`
Expected: FAIL — "Cannot find module './assistant.service'"

- [ ] **Step 3: เขียน implementation**

สร้าง `apps/api/src/assistant/assistant.config.ts`:

```typescript
export interface AssistantConfig {
  enabled: boolean;
  apiKey: string;
  model: string;
}

export function getAssistantConfig(): AssistantConfig {
  return {
    enabled: process.env.ASSISTANT_ENABLED !== '0',
    apiKey: process.env.OPENROUTER_API_KEY ?? '',
    model: process.env.OPENROUTER_MODEL || 'google/gemini-2.5-flash',
  };
}
```

สร้าง `apps/api/src/assistant/assistant.service.ts`:

```typescript
import { Injectable, OnModuleInit, ServiceUnavailableException } from '@nestjs/common';
import { join } from 'path';
import { loadKnowledgeBase } from './knowledge-loader';
import { buildChatMessages } from './build-messages';
import { OpenRouterClient } from './openrouter.client';
import { getAssistantConfig } from './assistant.config';
import type { ChatMessage } from './assistant.types';

@Injectable()
export class AssistantService implements OnModuleInit {
  private knowledgeBase = '';

  constructor(private readonly client: OpenRouterClient = new OpenRouterClient()) {}

  onModuleInit(): void {
    this.knowledgeBase = loadKnowledgeBase(join(__dirname, 'knowledge'));
  }

  async *chat(history: ChatMessage[], signal?: AbortSignal): AsyncGenerator<string> {
    const cfg = getAssistantConfig();
    if (!cfg.enabled || !cfg.apiKey) {
      throw new ServiceUnavailableException('ระบบผู้ช่วยตอบคำถามยังไม่พร้อมใช้งาน');
    }
    const messages = buildChatMessages(this.knowledgeBase, history);
    yield* this.client.streamChat({
      apiKey: cfg.apiKey,
      model: cfg.model,
      messages,
      signal,
    });
  }
}
```

- [ ] **Step 4: รัน test ให้ผ่าน**

Run: `cd apps/api && npx jest src/assistant/assistant.service.spec.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add apps/api/src/assistant/assistant.config.ts apps/api/src/assistant/assistant.service.ts apps/api/src/assistant/assistant.service.spec.ts
git commit -m "feat(assistant): service wiring KB + prompt + OpenRouter with enable/key guards"
```

---

## Task 7: DTO + Controller (SSE) + Module + wire เข้า app

**Files:**
- Create: `apps/api/src/assistant/dto/chat.dto.ts`
- Create: `apps/api/src/assistant/assistant.controller.ts`
- Create: `apps/api/src/assistant/assistant.module.ts`
- Test: `apps/api/src/assistant/assistant.controller.spec.ts`
- Modify: `apps/api/src/app.module.ts`

**Interfaces:**
- Consumes: `AssistantService.chat`, `ChatMessage`
- Produces: `POST /assistant/chat` → SSE stream; body `{ messages: ChatMessageDto[] }`

- [ ] **Step 1: เขียน DTO**

สร้าง `apps/api/src/assistant/dto/chat.dto.ts`:

```typescript
import { Type } from 'class-transformer';
import { ArrayMaxSize, ArrayNotEmpty, IsArray, IsIn, IsString, MaxLength, ValidateNested } from 'class-validator';

export class ChatMessageDto {
  @IsIn(['user', 'assistant'])
  role!: 'user' | 'assistant';

  @IsString()
  @MaxLength(1000, { message: 'ข้อความต้องไม่เกิน 1000 ตัวอักษร' })
  content!: string;
}

export class ChatRequestDto {
  @IsArray()
  @ArrayNotEmpty()
  @ArrayMaxSize(40)
  @ValidateNested({ each: true })
  @Type(() => ChatMessageDto)
  messages!: ChatMessageDto[];
}
```

- [ ] **Step 2: เขียน failing test สำหรับ controller**

สร้าง `apps/api/src/assistant/assistant.controller.spec.ts`:

```typescript
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
```

- [ ] **Step 3: รัน test ให้ fail**

Run: `cd apps/api && npx jest src/assistant/assistant.controller.spec.ts`
Expected: FAIL — "Cannot find module './assistant.controller'"

- [ ] **Step 4: เขียน controller**

สร้าง `apps/api/src/assistant/assistant.controller.ts`:

```typescript
import { Body, Controller, Post, Res, UseGuards } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import type { Response } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AllowViewerWrite } from '../auth/decorators/allow-viewer-write.decorator';
import { AssistantService } from './assistant.service';
import { ChatRequestDto } from './dto/chat.dto';

@Controller('assistant')
@UseGuards(JwtAuthGuard)
export class AssistantController {
  constructor(private readonly assistantService: AssistantService) {}

  @Post('chat')
  @AllowViewerWrite()
  @Throttle({ default: { limit: 20, ttl: 60000 } })
  async chat(@Body() dto: ChatRequestDto, @Res() res: Response): Promise<void> {
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache, no-transform');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('X-Accel-Buffering', 'no');
    res.flushHeaders?.();

    const abort = new AbortController();
    res.on('close', () => abort.abort());

    try {
      for await (const delta of this.assistantService.chat(dto.messages, abort.signal)) {
        res.write(`data: ${JSON.stringify({ delta })}\n\n`);
      }
      res.write('data: [DONE]\n\n');
    } catch (err) {
      const message = err instanceof Error ? err.message : 'เกิดข้อผิดพลาด';
      res.write(`data: ${JSON.stringify({ error: message })}\n\n`);
    } finally {
      res.end();
    }
  }
}
```

- [ ] **Step 5: เขียน module**

สร้าง `apps/api/src/assistant/assistant.module.ts`:

```typescript
import { Module } from '@nestjs/common';
import { AssistantController } from './assistant.controller';
import { AssistantService } from './assistant.service';

@Module({
  controllers: [AssistantController],
  providers: [AssistantService],
})
export class AssistantModule {}
```

- [ ] **Step 6: wire เข้า `app.module.ts`**

ใน `apps/api/src/app.module.ts` เพิ่ม import (หลังบรรทัด `SchoolAdminsModule` import, บรรทัด ~26):

```typescript
import { AssistantModule } from './assistant/assistant.module';
```

และเพิ่ม `AssistantModule` ท้าย array `imports` (หลัง `SchoolAdminsModule,` บรรทัด ~65):

```typescript
    SchoolAdminsModule,
    AssistantModule,
```

- [ ] **Step 7: รัน controller test + full assistant suite ให้ผ่าน**

Run: `cd apps/api && npx jest src/assistant`
Expected: PASS ทุกไฟล์ใน `src/assistant` (loader, build-messages, client, service, controller)

- [ ] **Step 8: Commit**

```bash
git add apps/api/src/assistant/dto apps/api/src/assistant/assistant.controller.ts apps/api/src/assistant/assistant.controller.spec.ts apps/api/src/assistant/assistant.module.ts apps/api/src/app.module.ts
git commit -m "feat(assistant): SSE chat endpoint (viewer-allowed, throttled) + wire module"
```

---

## Task 8: Config validation + เอกสาร env

**Files:**
- Modify: `apps/api/src/config/env.validation.ts`
- Modify: `apps/api/.env.example` (สร้างถ้ายังไม่มี) — ถ้าโปรเจกต์ไม่มี `.env.example` ให้เพิ่มบล็อกใน `SETUP_UBUNTU.md` แทน

**Interfaces:**
- Consumes: env vars
- Produces: `validateEnv()` เตือน (throw) เมื่อ `ASSISTANT_ENABLED !== '0'` แต่ไม่มี `OPENROUTER_API_KEY` ใน production

- [ ] **Step 1: เพิ่ม validation ใน `env.validation.ts`**

ต่อท้ายภายในฟังก์ชัน `validateEnv()` (หลังบล็อก production CORS check ปัจจุบัน บรรทัด ~17):

```typescript
  const assistantEnabled = process.env.ASSISTANT_ENABLED !== '0';
  if (process.env.NODE_ENV === 'production' && assistantEnabled && !process.env.OPENROUTER_API_KEY) {
    throw new Error(
      'OPENROUTER_API_KEY must be set when ASSISTANT_ENABLED is on (set ASSISTANT_ENABLED=0 to disable the chatbot)',
    );
  }
```

- [ ] **Step 2: เอกสาร env**

เพิ่มบรรทัดต่อไปนี้ในไฟล์ env ตัวอย่าง (`apps/api/.env.example` หรือถ้าไม่มีให้เพิ่มในส่วน env ของ `SETUP_UBUNTU.md`):

```bash
# AI Chatbot (ระเบียบ Q&A) — ปิดได้ด้วย ASSISTANT_ENABLED=0
ASSISTANT_ENABLED=1
OPENROUTER_API_KEY=sk-or-...          # จาก https://openrouter.ai/keys — secret, ห้าม commit
OPENROUTER_MODEL=google/gemini-2.5-flash
# ทางเลือก (แสดงชื่อแอปใน dashboard ของ OpenRouter)
OPENROUTER_APP_TITLE=Cremation Welfare
```

- [ ] **Step 3: รัน API test suite เดิมทั้งหมดให้ยังผ่าน**

Run: `cd apps/api && npx jest`
Expected: PASS ทั้งหมด (รวมชุดเดิม ไม่ regress)

- [ ] **Step 4: Commit**

```bash
git add apps/api/src/config/env.validation.ts
git commit -m "feat(assistant): fail-fast on missing OPENROUTER_API_KEY in prod + env docs"
```

---

## Task 9: Frontend — client stream reader `lib/assistant.ts`

Web ไม่มี test infra — verify ด้วยการใช้งานจริงใน Task 12

**Files:**
- Create: `apps/web/src/lib/assistant.ts`

**Interfaces:**
- Produces:
  - `AssistantMessage` = `{ role: 'user' | 'assistant'; content: string }`
  - `streamAssistant(messages: AssistantMessage[], onDelta: (text: string) => void, signal?: AbortSignal): Promise<void>` — POST ไป `${API_BASE}/assistant/chat` ด้วย `credentials: 'include'`, อ่าน SSE, เรียก `onDelta` ต่อ token; โยน `Error` เมื่อเจอ frame `{"error":...}` หรือ HTTP ไม่ ok

- [ ] **Step 1: เขียน implementation**

สร้าง `apps/web/src/lib/assistant.ts`:

```typescript
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
      try {
        const json = JSON.parse(data);
        if (json.error) throw new Error(json.error);
        if (typeof json.delta === 'string') onDelta(json.delta);
      } catch (e) {
        if (e instanceof Error && e.message && !e.message.startsWith('Unexpected')) throw e;
      }
    }
  }
}
```

- [ ] **Step 2: ตรวจ build ผ่าน (typecheck)**

Run: `cd apps/web && npx tsc --noEmit`
Expected: ไม่มี error ในไฟล์ใหม่

- [ ] **Step 3: Commit**

```bash
git add apps/web/src/lib/assistant.ts
git commit -m "feat(web): assistant SSE stream client"
```

---

## Task 10: Frontend — hook `useAssistantChat` + component `ChatMessage`

**Files:**
- Create: `apps/web/src/components/assistant/useAssistantChat.ts`
- Create: `apps/web/src/components/assistant/ChatMessage.tsx`
- Modify: `apps/web/package.json` (เพิ่ม `react-markdown`)

**Interfaces:**
- Consumes: `streamAssistant`, `AssistantMessage`
- Produces:
  - `useAssistantChat()` → `{ messages, isStreaming, error, send(text: string): void, reset(): void }`
  - `ChatMessage({ message }: { message: AssistantMessage })` — render bubble; ข้อความบอท render ผ่าน `react-markdown`

- [ ] **Step 1: เพิ่ม dependency `react-markdown`**

Run: `cd apps/web && pnpm add react-markdown`
Expected: เพิ่มใน `dependencies` สำเร็จ

- [ ] **Step 2: เขียน hook**

สร้าง `apps/web/src/components/assistant/useAssistantChat.ts`:

```typescript
'use client';

import { useCallback, useRef, useState } from 'react';
import { streamAssistant, type AssistantMessage } from '@/lib/assistant';

export function useAssistantChat() {
  const [messages, setMessages] = useState<AssistantMessage[]>([]);
  const [isStreaming, setIsStreaming] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const abortRef = useRef<AbortController | null>(null);

  const send = useCallback(
    async (text: string) => {
      const trimmed = text.trim();
      if (!trimmed || isStreaming) return;
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
        setIsStreaming(false);
        abortRef.current = null;
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
```

- [ ] **Step 3: เขียน `ChatMessage.tsx`**

สร้าง `apps/web/src/components/assistant/ChatMessage.tsx`:

```tsx
'use client';

import ReactMarkdown from 'react-markdown';
import type { AssistantMessage } from '@/lib/assistant';

export function ChatMessage({ message }: { message: AssistantMessage }) {
  const isUser = message.role === 'user';
  return (
    <div className={`flex ${isUser ? 'justify-end' : 'justify-start'} mb-3`}>
      <div
        className={`max-w-[85%] rounded-2xl px-4 py-2 text-sm leading-relaxed ${
          isUser ? 'bg-primary-600 text-white' : 'bg-slate-100 text-slate-800'
        }`}
      >
        {isUser ? (
          <span className="whitespace-pre-wrap">{message.content}</span>
        ) : (
          <div className="prose prose-sm max-w-none prose-p:my-1 prose-ul:my-1">
            <ReactMarkdown>{message.content || '…'}</ReactMarkdown>
          </div>
        )}
      </div>
    </div>
  );
}
```

- [ ] **Step 4: typecheck**

Run: `cd apps/web && npx tsc --noEmit`
Expected: ไม่มี error

- [ ] **Step 5: Commit**

```bash
git add apps/web/src/components/assistant/useAssistantChat.ts apps/web/src/components/assistant/ChatMessage.tsx apps/web/package.json apps/web/pnpm-lock.yaml
git commit -m "feat(web): assistant chat hook + message bubble (markdown render)"
```

---

## Task 11: Frontend — `AssistantWidget` + mount ใน dashboard layout

**Files:**
- Create: `apps/web/src/components/assistant/AssistantWidget.tsx`
- Modify: `apps/web/src/app/(dashboard)/layout.tsx`

**Interfaces:**
- Consumes: `useAssistantChat`, `ChatMessage`
- Produces: `AssistantWidget()` — ปุ่มลอยมุมขวาล่าง + panel แชท (starter chips, input, ปุ่มล้าง, disclaimer)

- [ ] **Step 1: เขียน `AssistantWidget.tsx`**

สร้าง `apps/web/src/components/assistant/AssistantWidget.tsx`:

```tsx
'use client';

import { useEffect, useRef, useState } from 'react';
import { MessageCircle, X, Send, Trash2 } from 'lucide-react';
import { useAssistantChat } from './useAssistantChat';
import { ChatMessage } from './ChatMessage';

const STARTERS = [
  'เงินสงเคราะห์คำนวณอย่างไร',
  'สมาชิกสมทบต้องใช้เอกสารอะไรบ้าง',
  'ขาดส่งเงินกี่ครั้งถึงพ้นสภาพ',
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
```

- [ ] **Step 2: mount ใน dashboard layout**

ใน `apps/web/src/app/(dashboard)/layout.tsx`:

เพิ่ม import ใกล้ import อื่น ๆ ด้านบน:

```tsx
import { AssistantWidget } from '@/components/assistant/AssistantWidget';
```

แล้ววาง `<AssistantWidget />` ก่อนปิด `</div>` ตัวนอกสุดของ return (หลัง `<div className="lg:pl-72">…</div>` ที่ครอบ main content):

```tsx
        {/* Main content */}
        <div className="lg:pl-72">
          {/* ...header + main ... */}
        </div>

        <AssistantWidget />
      </div>
```

- [ ] **Step 3: typecheck + build**

Run: `cd apps/web && npx tsc --noEmit`
Expected: ไม่มี error

- [ ] **Step 4: Commit**

```bash
git add apps/web/src/components/assistant/AssistantWidget.tsx "apps/web/src/app/(dashboard)/layout.tsx"
git commit -m "feat(web): floating regulation assistant widget on all dashboard pages"
```

---

## Task 12: End-to-end verification (ใช้ OpenRouter key จริง)

ต้องมี `OPENROUTER_API_KEY` จริงใน `.env` (repo root) — ผู้ใช้เป็นผู้ใส่ key เอง (ห้าม commit)

**Files:** ไม่มีการแก้โค้ด (verification เท่านั้น; ถ้าเจอ bug ย้อนไปแก้ task ที่เกี่ยวข้อง)

- [ ] **Step 1: ตั้งค่า env**

ยืนยันว่า `.env` (repo root) มี `OPENROUTER_API_KEY=...` และ `ASSISTANT_ENABLED=1` (ถาม/แจ้งผู้ใช้ให้ใส่ key — ห้าม Claude กรอกเอง)

- [ ] **Step 2: รันทั้งสองแอป + เปิด preview**

Run (แยกกัน): `pnpm dev:api` และ `pnpm dev:web` (หรือ `pnpm dev`)
เปิด preview ที่ `http://localhost:3000` แล้ว login

- [ ] **Step 3: ทดสอบ happy path**

คลิกปุ่มลอยมุมขวาล่าง → คลิก starter chip "เงินสงเคราะห์คำนวณอย่างไร"
Expected: คำตอบ stream ออกมาเป็นภาษาไทย อ้างอิงเลขข้อ/มาตรา และเนื้อหาตรงกับระเบียบ

- [ ] **Step 4: ทดสอบ guardrail (นอกขอบเขต)**

ถาม: "สมาชิกชื่อสมชายค้างจ่ายกี่เดือน"
Expected: ตอบทำนอง "ไม่พบข้อกำหนดนี้ในระเบียบ" / ปฏิเสธการตอบข้อมูลสมาชิกจริง ไม่แต่งข้อมูล

- [ ] **Step 5: ตรวจ console/network + error path**

- ตรวจ `read_console_messages` ไม่มี error
- ตั้ง `ASSISTANT_ENABLED=0` ชั่วคราว รีสตาร์ท API แล้วถามใหม่ → widget แสดงข้อความ error สุภาพ ไม่ crash; แล้วตั้งกลับเป็น `1`

- [ ] **Step 6: สรุปผล**

ถ้าผ่านทุกข้อ → feature เสร็จ รายงานผลผู้ใช้ (แก้อะไร ที่ไฟล์ไหน) ถ้าไม่ผ่าน → systematic-debugging แล้วย้อนแก้ task ที่เกี่ยวข้อง

---

## Self-Review (ผู้เขียน plan ตรวจเองแล้ว)

- **Spec coverage:** Data-prep→Task 1; Backend module/service/loader/prompt/client→Task 3–7; API contract SSE+citation inline+input cap→Task 4,7; env/config→Task 6,8; Frontend widget/ephemeral/streaming/starter/disclaimer→Task 9–11; Security (viewer-allow, throttle, no-DB, key server-side, guardrail)→Task 7,8 + Global Constraints; Testing→ทุก backend task มี TDD, frontend verify→Task 12. ครบทุกหัวข้อใน spec
- **Placeholder scan:** ทุก step มี code/command จริง ไม่มี TBD/TODO
- **Type consistency:** `ChatMessage {role,content}` (Task 2) ใช้ต่อเนื่องทุก task; `loadKnowledgeBase(dir)`, `buildChatMessages(kb,history)`, `OpenRouterClient.streamChat({apiKey,model,messages,signal})`, `AssistantService.chat(history,signal)`, `streamAssistant(messages,onDelta,signal)` — signature ตรงกันระหว่าง task ที่ produce และ consume
- **Prompt caching:** v1 ใช้ system message เป็น string เดียว พึ่ง provider implicit caching (Gemini) ตาม spec risk note — ไม่ทำ `cache_control` breakpoint ใน v1 เพื่อความเรียบง่ายและความเข้ากันได้ทุก model (สอดคล้องหลัก prompt-stuffing ของ spec)
