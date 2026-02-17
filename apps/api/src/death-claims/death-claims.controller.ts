import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { DeathClaimsService } from './death-claims.service';
import { CreateDeathClaimDto } from './dto/create-death-claim.dto';
import { RecordBenefitPaymentDto } from './dto/record-payment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';

@Controller('death-claims')
@UseGuards(JwtAuthGuard)
export class DeathClaimsController {
  constructor(private readonly deathClaimsService: DeathClaimsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  create(@Body() dto: CreateDeathClaimDto) {
    return this.deathClaimsService.create(dto);
  }

  @Get()
  findAll(@Query('schoolId') schoolId?: string, @Query('year') year?: number) {
    return this.deathClaimsService.findAll(schoolId, year ? Number(year) : undefined);
  }

  @Get('stats')
  getStats(@Query('year') year?: number) {
    return this.deathClaimsService.getStats(year ? Number(year) : undefined);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.deathClaimsService.findById(id);
  }

  @Post(':id/payment')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  recordPayment(@Param('id') id: string, @Body() dto: RecordBenefitPaymentDto) {
    return this.deathClaimsService.recordPayment(id, dto);
  }
}
