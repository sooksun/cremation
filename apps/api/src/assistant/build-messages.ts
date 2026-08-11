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
