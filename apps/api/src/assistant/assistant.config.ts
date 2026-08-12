export interface AssistantConfig {
  enabled: boolean;
  apiKey: string;
  model: string;
}

// ค่าตัวอย่างจาก .env.example ที่ยังไม่ถูกแทนที่ — ไม่ใช่ key จริง ถือว่ายังไม่ได้ตั้งค่า
// (ถ้าปล่อยผ่าน OpenRouter จะตอบ 401 ซึ่งผู้ใช้อ่านแล้วไม่รู้ว่าต้องไปตั้ง key)
const PLACEHOLDER_KEY = /^(change[_-]?me$|paste[_ -]?your|your[_ -]|<.*>$)|[_-]here$/i;

function readApiKey(): string {
  const raw = (process.env.OPENROUTER_API_KEY ?? '').trim();
  return PLACEHOLDER_KEY.test(raw) ? '' : raw;
}

export function getAssistantConfig(): AssistantConfig {
  return {
    enabled: process.env.ASSISTANT_ENABLED !== '0',
    apiKey: readApiKey(),
    model: process.env.OPENROUTER_MODEL || 'google/gemini-2.5-flash',
  };
}
