import { Controller, Post, Body, Get, Query, UseGuards, Param } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { MemberApplicationsService } from './member-applications.service';
import { SubmitApplicationDto } from './dto/submit-application.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('member-applications')
export class MemberApplicationsController {
  constructor(private readonly service: MemberApplicationsService) {}

  @Post('submit')
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  submit(@Body() dto: SubmitApplicationDto) {
    return this.service.submit(dto);
  }

  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  list(
    @Query('schoolId') schoolId?: string,
    @Query('limit') limit = '20',
  ) {
    return this.service.listApplications(schoolId, parseInt(limit));
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  getOne(@Param('id') id: string) {
    return this.service.getApplication(id);
  }

  @Post(':id/approve')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  approve(@Param('id') id: string) {
    return this.service.approveApplication(id);
  }
}