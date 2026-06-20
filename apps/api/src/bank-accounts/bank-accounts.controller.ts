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
} from '@nestjs/common';
import { BankAccountsService } from './bank-accounts.service';
import { CreateBankAccountDto, UpdateBankAccountDto } from './dto/bank-account.dto';
import { CreateBankTransactionDto, UpdateBankTransactionDto } from './dto/bank-transaction.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('bank-accounts')
@UseGuards(JwtAuthGuard)
export class BankAccountsController {
  constructor(private readonly bankAccountsService: BankAccountsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  create(@Body() dto: CreateBankAccountDto) {
    return this.bankAccountsService.create(dto);
  }

  @Get()
  findAll(@Query('includeInactive') includeInactive?: string) {
    if (includeInactive === 'true') {
      return this.bankAccountsService.findAllIncludeInactive();
    }
    return this.bankAccountsService.findAll();
  }

  @Get('default')
  findDefault() {
    return this.bankAccountsService.findDefault();
  }

  @Get('transactions')
  listManualTransactions(@Query('bankAccountId') bankAccountId?: string) {
    return this.bankAccountsService.listManualTransactions(bankAccountId);
  }

  @Post('transactions')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  createManualTransaction(@Body() dto: CreateBankTransactionDto) {
    return this.bankAccountsService.createManualTransaction(dto);
  }

  @Patch('transactions/:txnId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateManualTransaction(
    @Param('txnId') txnId: string,
    @Body() dto: UpdateBankTransactionDto,
  ) {
    return this.bankAccountsService.updateManualTransaction(txnId, dto);
  }

  @Delete('transactions/:txnId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  removeManualTransaction(@Param('txnId') txnId: string) {
    return this.bankAccountsService.removeManualTransaction(txnId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.bankAccountsService.findById(id);
  }

  @Get(':id/balance')
  getBalance(@Param('id') id: string) {
    return this.bankAccountsService.getBalance(id);
  }

  @Get(':id/transactions')
  getTransactions(
    @Param('id') id: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.bankAccountsService.getTransactions(
      id,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  update(@Param('id') id: string, @Body() dto: UpdateBankAccountDto) {
    return this.bankAccountsService.update(id, dto);
  }

  @Patch(':id/set-default')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  setDefault(@Param('id') id: string) {
    return this.bankAccountsService.setDefault(id);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  remove(@Param('id') id: string) {
    return this.bankAccountsService.remove(id);
  }
}
