import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ReceiptsService } from './receipts.service';
import { CreateReceiptDto } from './dto/create-receipt.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { AllowMemberAccess } from '../auth/decorators/allow-member-access.decorator';
import { Role, ReceiptType } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('receipts')
@UseGuards(JwtAuthGuard)
export class ReceiptsController {
  constructor(private readonly receiptsService: ReceiptsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  create(
    @Body() dto: CreateReceiptDto,
    @Request() req: { user: { id: string; role: Role; schoolId?: string }; ip?: string },
  ) {
    return this.receiptsService.create(dto, req.user, req.ip);
  }

  @Get()
  findAll(
    @Query('schoolId') schoolId?: string,
    @Query('type') type?: ReceiptType,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.receiptsService.findAll(
      schoolId,
      type,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  @Get('summary')
  getSummary(
    @Query('schoolId') schoolId?: string,
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ) {
    return this.receiptsService.getSummary(
      schoolId,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
    );
  }

  @Get(':id')
  @AllowMemberAccess()
  findOne(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.receiptsService.findById(id, req.user);
  }
}

