import { Module } from '@nestjs/common';
import { AssistantController } from './assistant.controller';
import { AssistantService } from './assistant.service';
import { OpenRouterClient } from './openrouter.client';
import { FundFactsService } from './fund-facts.service';
import { DeathClaimsModule } from '../death-claims/death-claims.module';

@Module({
  imports: [DeathClaimsModule],
  controllers: [AssistantController],
  providers: [AssistantService, OpenRouterClient, FundFactsService],
})
export class AssistantModule {}
