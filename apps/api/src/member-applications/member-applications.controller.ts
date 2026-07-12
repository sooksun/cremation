import {
  Controller,
  Post,
  Body,
  Get,
  Query,
  UseGuards,
  Param,
  Request,
} from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { MemberApplicationsService } from './member-applications.service';
import { SubmitApplicationDto } from './dto/submit-application.dto';
import { ApproveApplicationDto } from './dto/approve-application.dto';
import { RejectApplicationDto } from './dto/reject-application.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { ScopedUser } from '../common/security/school-scope.service';
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
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
    @Query('limit') limit = '20',
  ) {
    return this.service.listApplications(schoolId, parseInt(limit), req.user);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  getOne(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.service.getApplication(id, req.user);
  }

  @Post(':id/approve')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  approve(
    @Param('id') id: string,
    @Body() body: ApproveApplicationDto,
    @Request() req: { user: ScopedUser; ip: string },
  ) {
    return this.service.approveApplication(id, req.user, req.ip, body);
  }

  @Post(':id/reject')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  reject(
    @Param('id') id: string,
    @Body() body: RejectApplicationDto,
    @Request() req: { user: ScopedUser; ip: string },
  ) {
    return this.service.rejectApplication(id, req.user, req.ip, body.reason);
  }
}