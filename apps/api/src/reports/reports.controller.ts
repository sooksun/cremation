import { Controller, Get, Query, Param, UseGuards, Request } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { AllowMemberAccess } from '../auth/decorators/allow-member-access.decorator';
import { SchoolScopeService, ScopedUser } from '../common/security/school-scope.service';

@Controller('reports')
@UseGuards(JwtAuthGuard)
export class ReportsController {
  constructor(
    private readonly reportsService: ReportsService,
    private readonly schoolScope: SchoolScopeService,
  ) {}

  private scopedSchoolId(user: ScopedUser, schoolId?: string): string | undefined {
    return this.schoolScope.resolveSchoolId(user, schoolId);
  }

  @Get('dashboard')
  getDashboard(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
    @Query('year') year?: number,
  ) {
    const targetYear = year ? Number(year) : new Date().getFullYear();
    return this.reportsService.getDashboard(
      this.scopedSchoolId(req.user, schoolId),
      targetYear,
    );
  }

  @Get('members')
  getMemberStats(
    @Request() req: { user: ScopedUser },
    @Query('year') year?: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getMemberStats(
      year ? Number(year) : undefined,
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('contributions')
  getContributionReport(
    @Request() req: { user: ScopedUser },
    @Query('periodId') periodId: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getContributionReport(
      periodId,
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('daily-movement')
  getDailyMovement(
    @Request() req: { user: ScopedUser },
    @Query('date') date: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getDailyMovement(
      new Date(date),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('financial')
  getFinancialSummary(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getFinancialSummary(
      new Date(startDate),
      new Date(endDate),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('death-benefits')
  getDeathBenefitReport(
    @Request() req: { user: ScopedUser },
    @Query('year') year: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getDeathBenefitReport(
      Number(year),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('death-fund-reserve')
  getDeathFundReserveReport(
    @Request() req: { user: ScopedUser },
    @Query('year') year: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getDeathFundReserveReport(
      Number(year),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('board-monthly')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getBoardMonthlyReport(
    @Request() req: { user: ScopedUser },
    @Query('year') year: number,
    @Query('month') month: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getBoardMonthlyReport(
      Number(year),
      Number(month),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('executive')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  getExecutiveDashboard(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getExecutiveDashboard(
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('finance-dashboard')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getFinanceDashboard(
    @Request() req: { user: ScopedUser },
    @Query('year') year?: number,
    @Query('schoolId') schoolId?: string,
  ) {
    const targetYear = year ? Number(year) : new Date().getFullYear();
    return this.reportsService.getFinanceDashboard(
      targetYear,
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  @Get('member-profile/:memberId')
  @AllowMemberAccess()
  getMemberProfile(
    @Param('memberId') memberId: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.reportsService.getMemberProfile(memberId, req.user);
  }
}