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
import { CashBookService } from './cash-book.service';
import { CreateCashBookDto, UpdateCashBookDto } from './dto/cash-book.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('cash-book')
@UseGuards(JwtAuthGuard)
export class CashBookController {
  constructor(private readonly cashBookService: CashBookService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  create(@Body() dto: CreateCashBookDto, @Request() req: { user: ScopedUser }) {
    return this.cashBookService.create(dto, req.user);
  }

  @Get()
  findAll(
    @Query('schoolId') schoolId?: string,
    @Request() req?: { user: ScopedUser },
  ) {
    return this.cashBookService.findAll(schoolId, req?.user);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.cashBookService.findById(id, req.user);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  update(
    @Param('id') id: string,
    @Body() dto: UpdateCashBookDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.cashBookService.update(id, dto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.cashBookService.remove(id, req.user);
  }
}