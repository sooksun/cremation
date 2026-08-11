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
