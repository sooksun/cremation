import { Injectable, OnModuleInit, ServiceUnavailableException } from '@nestjs/common';
import { join } from 'path';
import { loadKnowledgeBase } from './knowledge-loader';
import { buildChatMessages } from './build-messages';
import { OpenRouterClient } from './openrouter.client';
import { getAssistantConfig } from './assistant.config';
import type { ChatMessage } from './assistant.types';
import { FundFactsService } from './fund-facts.service';

@Injectable()
export class AssistantService implements OnModuleInit {
  private knowledgeBase = '';

  constructor(
    private readonly client: OpenRouterClient = new OpenRouterClient(),
    private readonly fundFacts?: FundFactsService,
  ) {}

  onModuleInit(): void {
    this.knowledgeBase = loadKnowledgeBase(join(__dirname, 'knowledge'));
  }

  async *chat(history: ChatMessage[], signal?: AbortSignal): AsyncGenerator<string> {
    const cfg = getAssistantConfig();
    if (!cfg.enabled || !cfg.apiKey) {
      throw new ServiceUnavailableException('ระบบผู้ช่วยตอบคำถามยังไม่พร้อมใช้งาน');
    }
    const facts = this.fundFacts ? await this.fundFacts.snapshot() : null;
    const messages = buildChatMessages(this.knowledgeBase, history, facts);
    yield* this.client.streamChat({
      apiKey: cfg.apiKey,
      model: cfg.model,
      messages,
      signal,
    });
  }
}
