# Design: AI Chatbot ถาม–ตอบระเบียบสมาคมฯ และระเบียบฌาปนกิจสงเคราะห์

**วันที่:** 13 กรกฎาคม 2569 (2026-07-13)
**สถานะ:** อนุมัติ design แล้ว — รอทำ implementation plan
**ผู้ออกแบบ:** Claude Code + sooksun (brainstorming)

---

## 1. วัตถุประสงค์และขอบเขต

สร้าง AI chatbot สำหรับผู้ใช้ในระบบถาม–ตอบ **เนื้อหาของระเบียบ** ได้แก่

1. ระเบียบว่าด้วยฌาปนกิจสงเคราะห์ข้าราชการครูและบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง พ.ศ. 2568 (`doc/ref1.pdf`)
2. ข้อบังคับสมาคมผู้ประกอบวิชาชีพผู้บริหาร ครู และบุคลากรทางการศึกษา อำเภอแม่ฟ้าหลวง พ.ศ. 2566 (`doc/ref2.pdf`)
3. ใบสมัครสมาชิกสามัญ/สมทบ (`doc/ref1-1.pdf`, `doc/ref1-2.pdf`)

**อยู่นอกขอบเขต (v1):** ตอบข้อมูลสมาชิกจริงจากฐานข้อมูล, สรุปวิธีใช้งานระบบจาก `manual.pdf`, การกระทำใด ๆ ต่อข้อมูล (chatbot เป็น read-only Q&A ล้วน)

## 2. Requirements ที่ตกลงกัน (จาก brainstorming)

| หัวข้อ | ข้อสรุป |
|---|---|
| ขอบเขตคำตอบ | เฉพาะเนื้อหาระเบียบเท่านั้น (ไม่แตะข้อมูลจริงใน DB) |
| LLM provider | OpenRouter |
| ผู้ใช้ | ทุก role ที่ login แล้ว |
| แหล่ง knowledge | แปลง PDF → clean Thai markdown ด้วย vision (ทำครั้งเดียว, commit) |
| Retrieval strategy | Prompt-stuffing + prompt caching (ไม่ทำ vector RAG) |

**เหตุผลที่เลือก prompt-stuffing:** เนื้อหาระเบียบทั้งหมดเล็กมาก (~39,000 ตัวอักษร ≈ 30–40k tokens) และคงที่ (ไม่เปลี่ยนบ่อย) จึงยัดเข้า system prompt ทั้งก้อนได้ ให้ความแม่นยำสูงสุด (โมเดลเห็นระเบียบทั้งฉบับ ตอบเชื่อมโยงข้ามข้อได้) และ prompt caching จัดการเรื่องต้นทุน token ต่อ query ให้ วิธีนี้ตัด infra vector store/embedding ที่เป็นภาระเปล่าสำหรับเนื้อหาขนาดนี้ (MySQL ไม่มี native vector search ที่ดีอยู่แล้ว)

## 3. สถาปัตยกรรมภาพรวม

```
┌─ apps/web ─────────────┐         ┌─ apps/api ──────────────┐        ┌────────────┐
│ AssistantWidget        │  POST   │ assistant module        │  HTTPS │ OpenRouter │
│ (floating chat, ทุกหน้า)│ ──SSE──▶│ - โหลด KB markdown       │ ─────▶ │ (LLM +     │
│ ephemeral state        │◀────────│ - ประกอบ system prompt   │ ◀───── │  caching)  │
└────────────────────────┘ stream  │ - proxy + stream กลับ    │ stream └────────────┘
                                    └─────────────────────────┘
                            KB = markdown ระเบียบ (commit ไว้, ไม่แตะ DB)
```

Backend เป็น **stateless proxy**: ยัด KB ลง system prompt → เรียก OpenRouter แบบ streaming → pipe กลับ client ไม่มี DB, ไม่มี vector store, API key อยู่ฝั่ง server เท่านั้น

## 4. Data-prep pipeline (ทำครั้งเดียว, commit ผลลัพธ์)

- แปลง `ref1.pdf`, `ref1-1.pdf`, `ref1-2.pdf`, `ref2.pdf` → clean Thai markdown ด้วย vision (อ่าน PDF เป็นภาพโดยตรงตอน implement แล้วถอดเป็น markdown ที่รักษาโครงสร้าง หมวด/ข้อ/มาตรา)
  - **เหตุผลที่ต้องใช้ vision:** PDF ใช้ font AngsanaUPC (Identity-H) ที่ ToUnicode CMap เพี้ยน — `pypdf`/`pdfplumber`/`pymupdf` ได้ mojibake ล้วน; `pdftotext -enc UTF-8` อ่านออกแต่สระ/วรรณยุกต์สลับที่ ("ฌาปนก**จิ**" แทน "ฌาปนก**ิจ**") จึงไม่พอสำหรับ source ที่ต้องแม่นยำ
- ผลลัพธ์ commit เป็นไฟล์ static:
  - `apps/api/src/assistant/knowledge/01-regulation-cremation-2568.md`
  - `apps/api/src/assistant/knowledge/02-association-bylaws-2566.md`
  - `apps/api/src/assistant/knowledge/03-application-forms.md`
- แต่ละไฟล์มี frontmatter/หัวเรื่อง (ชื่อระเบียบ, พ.ศ., แหล่งที่มา) เพื่อให้โมเดลอ้างอิงถูก
- **การตรวจสอบคุณภาพ:** สุ่มตรวจ markdown เทียบ PDF ต้นฉบับ (โดยเฉพาะเลขข้อ/มาตรา, ตัวเลขเงิน/อัตรา, เงื่อนไขวัน) ก่อน commit — คุณภาพ KB = คุณภาพคำตอบ

## 5. Backend module `assistant` (NestJS)

```
apps/api/src/assistant/
  assistant.module.ts
  assistant.controller.ts      # POST /assistant/chat  (JwtAuthGuard — ทุก role ที่ login)
  assistant.service.ts         # ประกอบ prompt, เรียก OpenRouter, stream
  openrouter.client.ts         # หุ้มการเรียก OpenRouter (แยกเพื่อ mock ใน test ได้)
  knowledge-loader.ts          # อ่าน *.md เข้า memory ตอน boot (cache), มี guard ว่าโหลดครบ
  knowledge/*.md               # KB (จากส่วนที่ 4)
  dto/chat.dto.ts              # validate input (ความยาว, จำนวน turn)
  assistant.service.spec.ts
```

- `KnowledgeLoader` โหลดไฟล์ markdown ทั้งหมดเข้า memory ครั้งเดียวตอน boot (fail-fast ถ้าไม่พบไฟล์)
- `AssistantService.buildMessages()` ประกอบ:
  1. `system` — บทบาท + guardrails + KB ทั้งก้อน (มี `cache_control` breakpoint บนบล็อก KB)
  2. `history` — บทสนทนาก่อนหน้า (truncate ตาม limit)
  3. `user` — คำถามล่าสุด
- `AssistantService.stream()` เรียก OpenRouter chat completions แบบ streaming แล้วคืน stream กลับ controller
- เชื่อมเข้า `app.module.ts`

### Config / env (เพิ่มใน `src/config/env.validation.ts` + `.env.example`)

| ตัวแปร | ค่า | หมายเหตุ |
|---|---|---|
| `OPENROUTER_API_KEY` | (secret) | required เมื่อ `ASSISTANT_ENABLED=1`; ไม่ commit |
| `OPENROUTER_MODEL` | `google/gemini-2.5-flash` (default) | ไทยดี, context ใหญ่, caching ได้, ต้นทุนต่ำ |
| `ASSISTANT_ENABLED` | `1`/`0` | feature flag — ปิดได้โดยไม่ลบโค้ด |

## 6. API contract

- **Endpoint:** `POST /assistant/chat`
- **Guard:** `JwtAuthGuard` (ทุก role ที่ login) + rate limit เฉพาะ endpoint
- **Body:** `{ messages: [{ role: 'user' | 'assistant', content: string }] }`
- **Response:** SSE stream ของ token (frontend อ่านผ่าน `fetch` + `ReadableStream`)
- **Citations:** inline ในคำตอบ (สั่งโมเดลให้อ้างอิงข้อ/มาตราเสมอ เช่น "ตามข้อ 12 วรรคสอง…") — v1 ไม่ทำ structured citation object แยก
- **Input guard (DTO):** ความยาวคำถาม ≤ 1,000 ตัวอักษร, จำนวน history ≤ 10 คู่ (เกินให้ truncate ฝั่ง server)

## 7. Frontend UI widget

```
apps/web/src/
  components/assistant/
    AssistantWidget.tsx        # ปุ่มลอยมุมขวาล่าง + panel แชท
    ChatMessage.tsx            # แสดง 1 ข้อความ (markdown, ผู้ใช้/บอท)
    useAssistantChat.ts        # hook: จัดการ state + อ่าน SSE stream
  lib/assistant.ts             # เรียก POST /assistant/chat (fetch + stream reader)
```

- ปุ่มลอย (มุมขวาล่าง) mount ใน `app/(dashboard)/layout.tsx` → เห็นทุกหน้าหลัง login
- **State ephemeral** — เก็บใน React state เท่านั้น รีเฟรชแล้วเริ่มใหม่ (v1 ไม่ persist)
- แสดงคำตอบแบบ streaming, render markdown, typing indicator, ปุ่มล้างแชท
- **Starter chips** เช่น "เงินสงเคราะห์คำนวณอย่างไร", "สมาชิกสมทบต้องใช้เอกสารอะไรบ้าง", "ขาดส่งเงินกี่ครั้งถึงพ้นสภาพ"
- **Disclaimer:** "อ้างอิงตามระเบียบ พ.ศ. 2568/2566 — กรณีมีข้อสงสัยโปรดยืนยันกับคณะกรรมการ"

## 8. Security & Guardrails

- **API key ฝั่ง server เท่านั้น** — frontend เรียกผ่าน backend ของเราเสมอ ไม่ส่ง key ไป client
- **System prompt คุมขอบเขตเข้ม:** ตอบเฉพาะจากระเบียบที่ให้ไว้; ถ้าไม่มีในระเบียบให้ตอบ "ไม่พบข้อกำหนดนี้ในระเบียบ"; ห้ามตอบเรื่องข้อมูลสมาชิกจริง / การใช้งานระบบ / เรื่องทั่วไปนอกระเบียบ
- **ไม่มี DB access เลย** — module ไม่ผูกกับฐานข้อมูล จึงไม่มีอะไรให้รั่ว (ปลอดภัยโดยการออกแบบ)
- **Rate limit ต่อผู้ใช้:** ใช้ `ThrottlerGuard` ที่มีอยู่ + ตั้ง limit เฉพาะ endpoint (เช่น 20 คำถาม/นาที)
- **Input cap:** ความยาวคำถาม + จำนวน history turn (ตามข้อ 6) เพื่อคุม token
- **ไม่ log เนื้อหาคำถามเป็น PII** — log แค่ metadata (จำนวน token, สถานะ, latency); v1 ไม่เก็บ transcript

## 9. Testing

- **Unit test `AssistantService`** (jest, mock `OpenRouterClient`):
  - KB ถูกโหลดครบ (knowledge-loader fail-fast เมื่อไฟล์หาย)
  - `buildMessages()` ประกอบถูก: system prompt มี KB + ข้อความ guardrail, ลำดับ message ถูก
  - history ถูก truncate ตาม limit
  - จัดการ error เมื่อ OpenRouter ล้ม (คืน error เหมาะสม ไม่ crash)
- **Guardrail test:** ยืนยัน system prompt มีข้อความห้ามตอบนอกระเบียบ
- ไม่ทำ e2e จริงกับ OpenRouter (เสียเงิน/flaky) — mock provider เท่านั้น

## 10. Scope v1 vs อนาคต (YAGNI)

| ทำใน v1 | เว้นไว้ (อนาคต) |
|---|---|
| Q&A ระเบียบ 2 ฉบับ + ใบสมัคร | ตอบข้อมูลสมาชิกจริงจาก DB |
| Streaming + inline citation | Structured citation object / ลิงก์ไปหน้า PDF |
| Ephemeral chat | เก็บประวัติแชทถาวร |
| Prompt caching | Vector RAG |
| Rate limit + input cap | Analytics / feedback thumbs up-down |
| Feature flag เปิด-ปิด | หลายภาษา |

## 11. ความเสี่ยง / ข้อควรระวัง

- **คุณภาพการถอด PDF** เป็นความเสี่ยงหลัก — ต้องตรวจเลขข้อ/มาตรา/ตัวเลขเงินอย่างละเอียดก่อน commit KB
- **prompt caching ของ OpenRouter** รองรับต่าง provider ต่างกัน (Anthropic/Gemini ทำได้) — ต้องยืนยันว่า model ที่เลือกรองรับ และตั้ง `cache_control` ถูกจุด ถ้า model ใดไม่รองรับ caching ระบบยังทำงานได้แต่ต้นทุน token สูงขึ้น
- **hallucination** — แม้ยัดระเบียบทั้งฉบับ โมเดลอาจตอบเกินเนื้อหา; guardrail prompt + inline citation ช่วยลด และ disclaimer เตือนผู้ใช้ให้ยืนยันกับกรรมการ

## 12. ขั้นตอนถัดไป

1. เขียน implementation plan (writing-plans skill)
2. ทำ data-prep (ถอด PDF → markdown KB + ตรวจสอบ)
3. Backend module + unit test
4. Frontend widget
5. ทดสอบ end-to-end กับ OpenRouter จริง (ผู้ใช้ใส่ API key)
