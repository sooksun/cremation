import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ContributionsService } from './contributions.service';
import { CreatePeriodDto, UpdatePeriodDto } from './dto/period.dto';
import { UpdateContributionSettingsDto } from './dto/contribution-settings.dto';
import { RecordPaymentDto } from './dto/payment.dto';
import { BatchPaymentDto } from './dto/batch-payment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('contributions')
@UseGuards(JwtAuthGuard)
export class ContributionsController {
  constructor(private readonly contributionsService: ContributionsService) {}

  @Get('settings')
  getSettings() {
    return this.contributionsService.getSettings();
  }

  @Patch('settings')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  updateSettings(@Body() dto: UpdateContributionSettingsDto) {
    return this.contributionsService.updateSettings(dto.serviceFeeEnabled);
  }

  // Period endpoints
  @Post('periods')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  createPeriod(@Body() dto: CreatePeriodDto) {
    return this.contributionsService.createPeriod(dto);
  }

  @Get('periods')
  findAllPeriods(@Query('year') year?: number) {
    return this.contributionsService.findAllPeriods(year ? Number(year) : undefined);
  }

  @Get('periods/:id')
  findPeriod(@Param('id') id: string) {
    return this.contributionsService.findPeriodById(id);
  }

  @Patch('periods/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  updatePeriod(@Param('id') id: string, @Body() dto: UpdatePeriodDto) {
    return this.contributionsService.updatePeriod(id, dto);
  }

  @Post('periods/:id/close')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  closePeriod(@Param('id') id: string) {
    return this.contributionsService.closePeriod(id);
  }

  @Get('periods/:id/summary')
  getPeriodSummary(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getPeriodSummary(id, schoolId);
  }

  // Contribution endpoints
  @Post('periods/:id/generate')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  generateContributions(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.generateContributions(id, schoolId);
  }

  @Get('periods/:id/contributions')
  getContributionsByPeriod(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getContributionsByPeriod(id, schoolId);
  }

  @Patch(':id/payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE, Role.GROUP_LEADER)
  recordPayment(
    @Param('id') id: string,
    @Body() dto: RecordPaymentDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string; groupId?: string }; ip?: string },
  ) {
    return this.contributionsService.recordPayment(id, dto, req.user, req.ip);
  }

  @Post('batch-payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE, Role.GROUP_LEADER)
  batchRecordPayments(
    @Body() dto: BatchPaymentDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string; groupId?: string }; ip?: string },
  ) {
    return this.contributionsService.batchRecordPayments(dto.payments, req.user, req.ip);
  }

  // Arrears endpoints
  @Get('arrears')
  getArrears(@Query('schoolId') schoolId?: string, @Query('periodId') periodId?: string) {
    return this.contributionsService.getArrears(schoolId, periodId);
  }

  @Post('periods/:id/mark-arrears')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  markArrears(@Param('id') id: string) {
    return this.contributionsService.markArrearsForPeriod(id);
  }

  @Post('periods/:id/send-arrears-notice')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  sendArrearsNotice(@Param('id') id: string) {
    return this.contributionsService.sendArrearsNoticeForPeriod(id);
  }

  @Get('periods/:id/summary-by-school')
  getPeriodSummaryBySchool(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getPeriodSummaryBySchool(id, schoolId);
  }

  @Post('periods/:id/pay-all')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE, Role.GROUP_LEADER)
  payAllInPeriod(
    @Param('id') id: string,
    @Request() req: { user: { id: string; role: Role; schoolId?: string; groupId?: string }; ip?: string },
  ) {
    return this.contributionsService.payAllContributionsInPeriod(id, req.user, req.ip);
  }

  // =============================================
  // MATRIX - ตารางการชำระเงินรายเดือน 12 เดือน
  // =============================================
  @Get('matrix')
  getContributionMatrix(
    @Query('year') year: number,
    @Query('schoolId') schoolId?: string,
  ) {
    return this.contributionsService.getContributionMatrix(
      Number(year) || new Date().getFullYear(),
      schoolId,
    );
  }

  @Get('matrix/schools')
  getSchoolsForMatrix(@Query('year') year?: number) {
    return this.contributionsService.getSchoolsWithContributions(
      Number(year) || new Date().getFullYear(),
    );
  }

  // =============================================
  // EXCEL TEMPLATE & UPLOAD
  // =============================================
  @Get('template')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  async getPaymentTemplate(
    @Query('year') year: number,
    @Query('month') month: number,
  ) {
    return this.contributionsService.generatePaymentTemplate(
      Number(year) || new Date().getFullYear(),
      Number(month) || new Date().getMonth() + 1,
    );
  }

  @Post('upload')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  async uploadPaymentFile(
    @Body() body: { year: number; month: number; data: any[] },
  ) {
    return this.contributionsService.processPaymentUpload(
      body.year,
      body.month,
      body.data,
    );
  }

  @Post('backfill-receipts')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  async backfillReceipts() {
    return this.contributionsService.backfillReceiptsForPaidContributions();
  }
}

