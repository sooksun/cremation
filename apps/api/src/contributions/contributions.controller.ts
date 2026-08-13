import {
  BadRequestException,
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Query,
  UseGuards,
  Request,
  UploadedFile,
  UseInterceptors,
  Res,
  StreamableFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { Response } from 'express';
import { ContributionsService } from './contributions.service';
import { CreatePeriodDto, UpdatePeriodDto } from './dto/period.dto';
import { UpdateContributionSettingsDto } from './dto/contribution-settings.dto';
import { RecordPaymentDto } from './dto/payment.dto';
import { ScopedUser } from '../common/security/school-scope.service';
import { BatchPaymentDto } from './dto/batch-payment.dto';
import { UploadPaymentDto } from './dto/upload-payment.dto';
import { parsePaymentFile, isPaidStatus } from './payment-file.parser';
import { buildWorkbookBuffer } from './payment-workbook';
import { PaymentReconciliationService, MissingRow } from './payment-reconciliation.service';
import { MAX_UPLOAD_BYTES, UploadFileSizeInterceptor } from './upload-file-size.interceptor';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('contributions')
@UseGuards(JwtAuthGuard)
export class ContributionsController {
  constructor(
    private readonly contributionsService: ContributionsService,
    private readonly reconciliationService: PaymentReconciliationService,
  ) {}

  @Get('settings')
  getSettings() {
    return this.contributionsService.getSettings();
  }

  @Patch('settings')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateSettings(@Body() dto: UpdateContributionSettingsDto) {
    return this.contributionsService.updateSettings(dto.serviceFeeEnabled);
  }

  // Period endpoints
  @Post('periods')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
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
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updatePeriod(@Param('id') id: string, @Body() dto: UpdatePeriodDto) {
    return this.contributionsService.updatePeriod(id, dto);
  }

  @Post('periods/:id/close')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  closePeriod(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.contributionsService.closePeriod(id, req.user);
  }

  @Get('periods/:id/summary')
  getPeriodSummary(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getPeriodSummary(id, schoolId);
  }

  // Contribution endpoints
  @Post('periods/:id/generate')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  generateContributions(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.generateContributions(id, schoolId);
  }

  @Get('periods/:id/contributions')
  getContributionsByPeriod(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getContributionsByPeriod(id, schoolId);
  }

  @Patch(':id/payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.GROUP_LEADER)
  recordPayment(
    @Param('id') id: string,
    @Body() dto: RecordPaymentDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string; groupId?: string }; ip?: string },
  ) {
    return this.contributionsService.recordPayment(id, dto, req.user, req.ip);
  }

  @Post('batch-payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.GROUP_LEADER)
  batchRecordPayments(
    @Body() dto: BatchPaymentDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string; groupId?: string }; ip?: string },
  ) {
    return this.contributionsService.batchRecordPayments(dto.payments, req.user, req.ip);
  }

  // Arrears endpoints
  @Get('arrears')
  getArrears(
    @Query('schoolId') schoolId?: string,
    @Query('periodId') periodId?: string,
    @Request() req?: { user: ScopedUser },
  ) {
    return this.contributionsService.getArrears(schoolId, periodId, req?.user);
  }

  @Post('periods/:id/mark-arrears')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  markArrears(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.contributionsService.markArrearsForPeriod(id, req.user);
  }

  @Post('periods/:id/send-arrears-notice')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  sendArrearsNotice(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.contributionsService.sendArrearsNoticeForPeriod(id, req.user);
  }

  @Get('periods/:id/summary-by-school')
  getPeriodSummaryBySchool(@Param('id') id: string, @Query('schoolId') schoolId?: string) {
    return this.contributionsService.getPeriodSummaryBySchool(id, schoolId);
  }

  @Post('periods/:id/pay-all')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.GROUP_LEADER)
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
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async getPaymentTemplate(
    @Query('year') year: number,
    @Query('month') month: number,
    @Query('format') format: string | undefined,
    @Request() req: { user: ScopedUser },
    @Res({ passthrough: true }) res: Response,
  ) {
    const resolvedYear = Number(year) || new Date().getFullYear();
    const resolvedMonth = Number(month) || new Date().getMonth() + 1;
    const template = await this.contributionsService.generatePaymentTemplate(
      resolvedYear,
      resolvedMonth,
      req.user,
    );

    if (format === 'json') {
      return template;
    }

    const buffer = buildWorkbookBuffer('รายชื่อเก็บเงิน', template.members);
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    res.setHeader(
      'Content-Disposition',
      `attachment; filename="payment-template-${resolvedYear}-${String(resolvedMonth).padStart(2, '0')}.xlsx"`,
    );
    return new StreamableFile(buffer);
  }

  @Post('upload')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  @UseInterceptors(
    UploadFileSizeInterceptor,
    FileInterceptor('file', { limits: { fileSize: MAX_UPLOAD_BYTES } }),
  )
  async uploadPaymentFile(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Body() body: UploadPaymentDto,
    @Request() req: { user: ScopedUser },
  ) {
    const year = Number(body.year);
    const month = Number(body.month);
    const fullDistrict = body.fullDistrict === 'true' || body.fullDistrict === true;
    const autoMarkArrears = !(body.autoMarkArrears === 'false' || body.autoMarkArrears === false);

    const parsed = file
      ? parsePaymentFile(file.buffer)
      : {
          rows: (body.data ?? []).map((row, index) => ({
            rowNo: index + 2,
            memberNo: String(row['เลขสมาชิก'] ?? '').trim(),
            isPaid: isPaidStatus(row['สถานะ']),
            amount: row['ยอดที่ต้องชำระ'] ? Number(row['ยอดที่ต้องชำระ']) : undefined,
          })).filter((row) => row.memberNo !== ''),
          duplicates: [],
        };

    // ไฟล์ที่ไม่มีแถวข้อมูลเลย ต้องตกที่นี่ ก่อนเขียนฐานข้อมูลใด ๆ — ถ้าปล่อยผ่าน
    // schoolIdsInFile จะว่าง แต่ผู้ใช้ที่ถูกบังคับโรงเรียนจะยังถูกเทียบกับสมาชิกทั้งโรงเรียน
    // ทำให้ทุกคนกลายเป็น "ขาด" แล้วถูกบันทึกค้างชำระยกโรงเรียนจากไฟล์เปล่าใบเดียว
    if (parsed.rows.length === 0) {
      throw new BadRequestException(
        'ไฟล์นี้ไม่มีแถวข้อมูลสมาชิก — ตรวจสอบว่าเลือกไฟล์ถูกต้องและมีข้อมูลอย่างน้อย 1 แถว',
      );
    }

    const period = await this.contributionsService.findPeriodByYearMonth(year, month);

    const uploadResult = await this.contributionsService.processPaymentUpload(
      year,
      month,
      parsed.rows.map((row) => ({
        เลขสมาชิก: row.memberNo,
        ยอดที่ต้องชำระ: row.amount,
        สถานะ: row.isPaid ? 'ชำระแล้ว' : 'ยังไม่ชำระ',
      })),
      req.user,
    );

    const reconcileResult = await this.reconciliationService.reconcile({
      periodId: period.id,
      parsed,
      paidNowMemberNos: new Set(parsed.rows.filter((r) => r.isPaid).map((r) => r.memberNo)),
      actor: req.user,
      fullDistrict,
      autoMarkArrears,
    });

    return {
      ...reconcileResult,
      success: uploadResult.success,
      failed: uploadResult.failed,
      notFound: uploadResult.notFound,
      errors: [
        ...uploadResult.errors,
        ...parsed.duplicates.map((dup) => ({
          memberNo: dup.memberNo,
          error: `เลขสมาชิกซ้ำในไฟล์ (บรรทัด ${dup.rowNo}) — ระบบใช้แถวเดียวเท่านั้น`,
        })),
      ],
    };
  }

  @Post('periods/:id/missing/export')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async exportMissing(
    @Param('id') id: string,
    @Body() body: { missing: MissingRow[] },
    @Request() req: { user: ScopedUser },
    @Res({ passthrough: true }) res: Response,
  ) {
    const buffer = await this.reconciliationService.buildMissingWorkbook(
      id,
      body.missing ?? [],
      req.user,
    );
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    res.setHeader('Content-Disposition', `attachment; filename="missing-${id}.xlsx"`);
    return new StreamableFile(buffer);
  }

  @Post('backfill-receipts')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async backfillReceipts() {
    return this.contributionsService.backfillReceiptsForPaidContributions();
  }
}

