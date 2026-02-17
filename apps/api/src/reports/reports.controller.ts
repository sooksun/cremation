import { Controller, Get, Query, Param, UseGuards } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('reports')
@UseGuards(JwtAuthGuard)
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('dashboard')
  getDashboard(
    @Query('schoolId') schoolId?: string,
    @Query('year') year?: number,
  ) {
    const targetYear = year ? Number(year) : new Date().getFullYear();
    return this.reportsService.getDashboard(schoolId, targetYear);
  }

  @Get('members')
  getMemberStats(@Query('year') year?: number) {
    return this.reportsService.getMemberStats(year ? Number(year) : undefined);
  }

  @Get('contributions')
  getContributionReport(
    @Query('periodId') periodId: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getContributionReport(periodId, schoolId);
  }

  @Get('financial')
  getFinancialSummary(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getFinancialSummary(
      new Date(startDate),
      new Date(endDate),
      schoolId,
    );
  }

  @Get('death-benefits')
  getDeathBenefitReport(
    @Query('year') year: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getDeathBenefitReport(Number(year), schoolId);
  }

  // =============================================
  // EXECUTIVE DASHBOARD - สำหรับผู้บริหาร/บอร์ด
  // =============================================
  @Get('executive')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  getExecutiveDashboard() {
    return this.reportsService.getExecutiveDashboard();
  }

  // =============================================
  // FINANCE DASHBOARD - สำหรับเจ้าหน้าที่บัญชี
  // =============================================
  @Get('finance-dashboard')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getFinanceDashboard(
    @Query('year') year?: number,
    @Query('schoolId') schoolId?: string,
  ) {
    const targetYear = year ? Number(year) : new Date().getFullYear();
    return this.reportsService.getFinanceDashboard(targetYear, schoolId);
  }

  // =============================================
  // MEMBER PROFILE - สำหรับสมาชิกรายบุคคล
  // =============================================
  @Get('member-profile/:memberId')
  getMemberProfile(@Param('memberId') memberId: string) {
    return this.reportsService.getMemberProfile(memberId);
  }
}

