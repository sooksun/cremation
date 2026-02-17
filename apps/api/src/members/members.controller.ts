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
import { MembersService, MemberQueryParams } from './members.service';
import { BeneficiariesService } from './beneficiaries.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { ChangeStatusDto } from './dto/change-status.dto';
import { CreateBeneficiaryDto, UpdateBeneficiaryDto } from './dto/beneficiary.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, MemberStatus } from '@prisma/client';

@Controller('members')
@UseGuards(JwtAuthGuard)
export class MembersController {
  constructor(
    private readonly membersService: MembersService,
    private readonly beneficiariesService: BeneficiariesService,
  ) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  create(@Body() dto: CreateMemberDto) {
    return this.membersService.create(dto);
  }

  @Get()
  findAll(
    @Query('schoolId') schoolId?: string,
    @Query('status') status?: MemberStatus,
    @Query('memberTypeId') memberTypeId?: string,
    @Query('groupId') groupId?: string,
    @Query('search') search?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    const params: MemberQueryParams = {
      schoolId,
      status,
      memberTypeId,
      groupId,
      search,
      page: page ? Number(page) : undefined,
      limit: limit ? Number(limit) : undefined,
    };
    return this.membersService.findAll(params);
  }

  @Get('stats')
  getStats(@Query('schoolId') schoolId?: string) {
    return this.membersService.getStatsBySchool(schoolId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.membersService.findById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  update(@Param('id') id: string, @Body() dto: UpdateMemberDto) {
    return this.membersService.update(id, dto);
  }

  @Patch(':id/status')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  changeStatus(@Param('id') id: string, @Body() dto: ChangeStatusDto) {
    return this.membersService.changeStatus(id, dto.status, dto.date);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string) {
    return this.membersService.remove(id);
  }

  // Beneficiary endpoints
  @Post(':id/beneficiaries')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  addBeneficiary(@Param('id') memberId: string, @Body() dto: CreateBeneficiaryDto) {
    return this.beneficiariesService.create(memberId, dto);
  }

  @Patch(':memberId/beneficiaries/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  updateBeneficiary(@Param('id') id: string, @Body() dto: UpdateBeneficiaryDto) {
    return this.beneficiariesService.update(id, dto);
  }

  @Delete(':memberId/beneficiaries/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  removeBeneficiary(@Param('id') id: string) {
    return this.beneficiariesService.remove(id);
  }
}

