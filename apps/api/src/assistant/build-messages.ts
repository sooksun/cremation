import type { ChatMessage } from './assistant.types';
import { buildSystemPrompt } from './system-prompt';
import type { FundFacts } from './fund-facts.service';

export const MAX_HISTORY_MESSAGES = 20;

export { buildSystemPrompt };

export function buildChatMessages(
  knowledgeBase: string,
  history: ChatMessage[],
  facts: FundFacts | null = null,
): ChatMessage[] {
  const tail = history.slice(-MAX_HISTORY_MESSAGES);
  return [{ role: 'system', content: buildSystemPrompt(knowledgeBase, facts) }, ...tail];
}
