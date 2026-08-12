import { Controller, Get, Query, Request, UseGuards } from '@nestjs/common';
import { DashboardsService } from './dashboards.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('dashboards')
@UseGuards(JwtAuthGuard)
export class DashboardsController {
  constructor(private readonly dashboards: DashboardsService) {}

  @Get('members')
  getMembers(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.dashboards.getMembersDashboard(schoolId, req.user);
  }

  @Get('finance')
  getFinance(
    @Request() req: { user: ScopedUser },
    @Query('year') year?: string,
    @Query('schoolId') schoolId?: string,
  ) {
    const parsed = Number(year);
    const targetYear =
      Number.isInteger(parsed) && parsed > 1900 ? parsed : new Date().getFullYear();
    return this.dashboards.getFinanceDashboard(targetYear, schoolId, req.user);
  }
}
