import { Body, Controller, Logger, Post, Res, ServiceUnavailableException, UseGuards } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import type { Response } from 'express';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AllowViewerWrite } from '../auth/decorators/allow-viewer-write.decorator';
import { AllowMemberAccess } from '../auth/decorators/allow-member-access.decorator';
import { AssistantService } from './assistant.service';
import { ChatRequestDto } from './dto/chat.dto';

@Controller('assistant')
@UseGuards(JwtAuthGuard)
export class AssistantController {
  private readonly logger = new Logger(AssistantController.name);

  constructor(private readonly assistantService: AssistantService) {}

  @Post('chat')
  @AllowViewerWrite()
  @AllowMemberAccess()
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
      this.logger.error(`assistant chat stream failed: ${message}`);
      const userMessage =
        err instanceof ServiceUnavailableException ? message : 'เกิดข้อผิดพลาดในการเชื่อมต่อผู้ช่วย กรุณาลองใหม่อีกครั้ง';
      res.write(`data: ${JSON.stringify({ error: userMessage })}\n\n`);
    } finally {
      res.end();
    }
  }
}
