import { Controller, Post, Body } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { MemberApplicationsService } from './member-applications.service';
import { SubmitApplicationDto } from './dto/submit-application.dto';

@Controller('member-applications')
export class MemberApplicationsController {
  constructor(private readonly service: MemberApplicationsService) {}

  @Post('submit')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  submit(@Body() dto: SubmitApplicationDto) {
    return this.service.submit(dto);
  }
}