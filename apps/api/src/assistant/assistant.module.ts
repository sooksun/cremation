import { Module } from '@nestjs/common';
import { AssistantController } from './assistant.controller';
import { AssistantService } from './assistant.service';
import { OpenRouterClient } from './openrouter.client';

@Module({
  controllers: [AssistantController],
  providers: [AssistantService, OpenRouterClient],
})
export class AssistantModule {}
