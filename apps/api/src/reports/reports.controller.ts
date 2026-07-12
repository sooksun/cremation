import {
  BadRequestException,
  Controller,
  Get,
  Param,
  ParseEnumPipe,
  Query,
  Request,
  UseGuards,
} from '@nestjs/common';
import { ReportsService } from './reports.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, ReceiptType, PaymentType } from '@prisma/client';
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

  // endOfDay=true is for endDate bounds: a plain 'YYYY-MM-DD' parses as UTC midnight, which as an
  // inclusive `lte` bound against full DateTime columns excludes nearly all of that day's records.
  private parseRequiredDate(value: string | undefined, name: string, endOfDay = false): Date {
    const parsed = value ? new Date(endOfDay ? `${value}T23:59:59.999Z` : value) : undefined;
    if (!parsed || Number.isNaN(parsed.getTime())) {
      throw new BadRequestException(`ต้องระบุ ${name} เป็นวันที่ที่ถูกต้อง (YYYY-MM-DD)`);
    }
    return parsed;
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
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getDeathBenefitReport(
    @Request() req: { user: ScopedUser },
    @Query('year') year?: number,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getDeathBenefitReport(
      startDate || endDate
        ? {
            startDate: this.parseRequiredDate(startDate, 'startDate'),
            endDate: this.parseRequiredDate(endDate, 'endDate', true),
          }
        : { year: year ? Number(year) : undefined },
      this.scopedSchoolId(req.user, schoolId),
      req.user,
    );
  }

  @Get('resignations')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  getResignationReport(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getResignationReport(
      this.parseRequiredDate(startDate, 'startDate'),
      this.parseRequiredDate(endDate, 'endDate', true),
      this.scopedSchoolId(req.user, schoolId),
      req.user,
    );
  }

  @Get('receipts-ledger')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getReceiptsLedger(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
    @Query('type', new ParseEnumPipe(ReceiptType, { optional: true })) type?: ReceiptType,
  ) {
    return this.reportsService.getReceiptsLedger(
      this.parseRequiredDate(startDate, 'startDate'),
      this.parseRequiredDate(endDate, 'endDate', true),
      this.scopedSchoolId(req.user, schoolId),
      type,
      req.user,
    );
  }

  @Get('disbursement-ledger')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getDisbursementLedger(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
    @Query('type', new ParseEnumPipe(PaymentType, { optional: true })) type?: PaymentType,
  ) {
    return this.reportsService.getDisbursementLedger(
      this.parseRequiredDate(startDate, 'startDate'),
      this.parseRequiredDate(endDate, 'endDate', true),
      this.scopedSchoolId(req.user, schoolId),
      type,
      req.user,
    );
  }

  @Get('member-registry')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  getMemberRegistryReport(
    @Request() req: { user: ScopedUser },
    @Query('dateField') dateField: 'coverage' | 'applied' | 'recorded',
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    const field = dateField || 'coverage';
    if (!['coverage', 'applied', 'recorded'].includes(field)) {
      throw new BadRequestException('dateField ต้องเป็น coverage, applied หรือ recorded');
    }
    return this.reportsService.getMemberRegistryReport(
      field,
      this.parseRequiredDate(startDate, 'startDate'),
      this.parseRequiredDate(endDate, 'endDate', true),
      this.scopedSchoolId(req.user, schoolId),
      req.user,
    );
  }

  @Get('member-statement/:memberId')
  @AllowMemberAccess()
  getMemberStatement(
    @Param('memberId') memberId: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.reportsService.getMemberStatement(memberId, req.user);
  }

  @Get('period-close-summary/:periodId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getPeriodCloseSummary(
    @Param('periodId') periodId: string,
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getPeriodCloseSummary(
      periodId,
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

  // Group 8: Cash Flow Report
  @Get('cash-flow')
  getCashFlow(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getCashFlow(
      new Date(startDate),
      new Date(endDate),
      this.scopedSchoolId(req.user, schoolId),
    );
  }

  // Group 13: Statement of Changes in Equity
  @Get('changes-in-equity')
  getChangesInEquity(
    @Request() req: { user: ScopedUser },
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.reportsService.getChangesInEquity(
      new Date(startDate),
      new Date(endDate),
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