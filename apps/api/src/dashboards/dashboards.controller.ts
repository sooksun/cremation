import { Controller, Get, Query, Request, UseGuards } from '@nestjs/common';
import { DashboardsService } from './dashboards.service';
import { Role } from '@prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('dashboards')
@UseGuards(JwtAuthGuard, RolesGuard)
export class DashboardsController {
  constructor(private readonly dashboards: DashboardsService) {}

  @Get('members')
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING, Role.GROUP_LEADER, Role.VIEWER)
  getMembers(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.dashboards.getMembersDashboard(schoolId, req.user);
  }

  // แดชบอร์ดการเงินเป็นยอดระดับสมาคม ไม่เปิดให้หัวหน้ากลุ่ม/ผู้ดูอย่างเดียว
  @Get('finance')
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
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
