import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AccountsService } from './accounts.service';
import { CreateAccountDto, UpdateAccountDto } from './dto/account.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, AccountType } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('accounts')
@UseGuards(JwtAuthGuard)
export class AccountsController {
  constructor(private readonly accountsService: AccountsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  create(@Body() dto: CreateAccountDto, @Request() req: { user: ScopedUser }) {
    return this.accountsService.create(dto, req.user);
  }

  @Get()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  findAll(@Query('type') type?: AccountType) {
    return this.accountsService.findAll(type);
  }

  @Get('trial-balance')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getTrialBalance(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.accountsService.getTrialBalance(
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  // สมุดรายวันเป็นยอดทั้งสมาคมเช่นเดียวกับงบดุล — ไม่รับ schoolId
  @Get('journal')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getJournal(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.accountsService.getJournal(
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  /**
   * งบดุลเป็นยอดทั้งสมาคม ไม่รับ schoolId
   * SchoolScopeInterceptor จะยัด req.query.schoolId ให้ทุก request อยู่แล้ว แต่ route นี้ไม่อ่านค่านั้น
   * จงใจไม่รับ เพื่อไม่ให้ผู้เรียกเข้าใจผิดว่ากรองตามโรงเรียนได้ (LedgerEntry ไม่มี schoolId)
   */
  @Get('reports/balance-sheet')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getBalanceSheet(@Query('asOfDate') asOfDate?: string) {
    return this.accountsService.getBalanceSheet(
      asOfDate ? new Date(asOfDate) : undefined,
    );
  }

  @Get('reports/profit-loss')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE, Role.ACCOUNTING)
  getProfitAndLoss(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    return this.accountsService.getProfitAndLoss(
      new Date(startDate),
      new Date(endDate),
    );
  }

  // Group 7: Accounting Period Closing
  @Post('close-year')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  closeAccountingYear(@Query('year') year: string) {
    return this.accountsService.closeAccountingYear(Number(year));
  }

  @Get(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  findOne(@Param('id') id: string) {
    return this.accountsService.findById(id);
  }

  @Get(':id/ledger')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  getLedger(
    @Param('id') id: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.accountsService.getLedger(
      id,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  update(@Param('id') id: string, @Body() dto: UpdateAccountDto, @Request() req: { user: ScopedUser }) {
    return this.accountsService.update(id, dto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.accountsService.remove(id, req.user);
  }
}

