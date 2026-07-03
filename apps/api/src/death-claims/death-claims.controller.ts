import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { DeathClaimsService } from './death-claims.service';
import { WelfareSettingsService } from './welfare-settings.service';
import { CreateDeathClaimDto } from './dto/create-death-claim.dto';
import { RecordBenefitPaymentDto } from './dto/record-payment.dto';
import { UpdateDeathClaimWorkflowDto } from './dto/update-workflow.dto';
import { UpdateDeathClaimDocumentsDto } from './dto/update-documents.dto';
import { UpdateDeathBenefitFixedDto } from './dto/update-death-benefit-fixed.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { DeathClaimType, Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('death-claims')
@UseGuards(JwtAuthGuard)
export class DeathClaimsController {
  constructor(
    private readonly deathClaimsService: DeathClaimsService,
    private readonly welfareSettingsService: WelfareSettingsService,
  ) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  create(
    @Body() dto: CreateDeathClaimDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.deathClaimsService.create(dto, req.user, req.ip);
  }

  @Get()
  findAll(
    @Query('schoolId') schoolId?: string,
    @Query('year') year?: number,
    @Request() req?: { user: { id: string; role: Role; schoolId?: string } },
  ) {
    return this.deathClaimsService.findAll(
      schoolId,
      year ? Number(year) : undefined,
      req?.user,
    );
  }

  @Get('stats')
  getStats(
    @Query('year') year?: number,
    @Request() req?: { user: { id: string; role: Role; schoolId?: string } },
  ) {
    return this.deathClaimsService.getStats(year ? Number(year) : undefined, req?.user);
  }

  @Get('preview-calculation')
  previewCalculation(
    @Query('claimType') claimType?: DeathClaimType,
    @Query('excludeMemberId') excludeMemberId?: string,
    @Query('otherDeductions') otherDeductions?: number,
  ) {
    return this.deathClaimsService.previewCalculation({
      claimType,
      excludeMemberId,
      otherDeductions: otherDeductions ? Number(otherDeductions) : undefined,
    });
  }

  @Get(':id/print')
  getPrintData(
    @Param('id') id: string,
    @Request() req: { user: { id: string; role: Role; schoolId?: string } },
  ) {
    return this.deathClaimsService.getPrintData(id, req.user);
  }

  @Get(':id')
  findOne(
    @Param('id') id: string,
    @Request() req: { user: { id: string; role: Role; schoolId?: string } },
  ) {
    return this.deathClaimsService.findById(id, req.user);
  }

  @Patch(':id/workflow')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateWorkflow(
    @Param('id') id: string,
    @Body() dto: UpdateDeathClaimWorkflowDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.deathClaimsService.updateWorkflow(id, dto, req.user, req.ip);
  }

  @Patch(':id/documents')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateDocuments(
    @Param('id') id: string,
    @Body() dto: UpdateDeathClaimDocumentsDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.deathClaimsService.updateDocuments(id, dto, req.user, req.ip);
  }

  @Post(':id/approve')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  approveDisbursement(
    @Param('id') id: string,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.deathClaimsService.approveDisbursement(id, req.user, req.ip);
  }

  @Post(':id/payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  recordPayment(
    @Param('id') id: string,
    @Body() dto: RecordBenefitPaymentDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.deathClaimsService.recordPayment(id, dto, req.user, req.ip);
  }

  // === Death Benefit Fixed Amount Settings (ตามมติคณะกรรมการ) ===
  @Get('settings/death-benefit-fixed')
  getDeathBenefitFixed() {
    return this.welfareSettingsService.getCurrentDeathBenefitFixed();
  }

  @Patch('settings/death-benefit-fixed')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  updateDeathBenefitFixed(@Body() dto: UpdateDeathBenefitFixedDto, @Request() req: { user: ScopedUser }) {
    return this.welfareSettingsService.updateDeathBenefitFixed(dto, req.user);
  }
}
