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
  Header,
  Request,
} from '@nestjs/common';
import { MembersService, MemberQueryParams } from './members.service';
import { BeneficiariesService } from './beneficiaries.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { ChangeStatusDto } from './dto/change-status.dto';
import { ImportMembersDto } from './dto/import-members.dto';
import { CreateBeneficiaryDto, UpdateBeneficiaryDto } from './dto/beneficiary.dto';
import { CreateProtectedPersonDto, UpdateProtectedPersonDto } from './dto/protected-person.dto';
import { ProtectedPersonsService } from './protected-persons.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { AllowMemberAccess } from '../auth/decorators/allow-member-access.decorator';
import { Role, MemberStatus, MembershipClass, MembershipEndReason } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';
import {
  maskMemberListResponse,
  maskMemberWithAssociation,
  maskProtectedPersonList,
} from '../common/utils/pii-response.util';

@Controller('members')
@UseGuards(JwtAuthGuard)
export class MembersController {
  constructor(
    private readonly membersService: MembersService,
    private readonly beneficiariesService: BeneficiariesService,
    private readonly protectedPersonsService: ProtectedPersonsService,
  ) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async create(
    @Body() dto: CreateMemberDto,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.membersService.create(dto, req.user);
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Get()
  async findAll(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
    @Query('status') status?: MemberStatus,
    @Query('membershipClass') membershipClass?: MembershipClass,
    @Query('memberTypeId') memberTypeId?: string,
    @Query('groupId') groupId?: string,
    @Query('search') search?: string,
    @Query('membershipEndReason') membershipEndReason?: MembershipEndReason,
    @Query('membershipEnded') membershipEnded?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    const params: MemberQueryParams = {
      schoolId,
      status,
      membershipClass,
      memberTypeId,
      groupId,
      search,
      membershipEndReason,
      membershipEnded: membershipEnded === 'true',
      page: page ? Number(page) : undefined,
      limit: limit ? Number(limit) : undefined,
    };
    const result = await this.membersService.findAll(params);
    return maskMemberListResponse(result, req.user.role);
  }

  @Get('stats')
  getStats(
    @Query('schoolId') schoolId?: string,
    @Request() req?: { user: ScopedUser },
  ) {
    return this.membersService.getStatsBySchool(schoolId, req?.user);
  }

  @Get('export/csv')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  @Header('Content-Type', 'text/csv; charset=utf-8')
  @Header('Content-Disposition', 'attachment; filename="members.csv"')
  exportCsv(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.membersService.exportCsv(schoolId, req.user.role);
  }

  @Post('import/csv')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  importCsv(
    @Body() dto: ImportMembersDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.membersService.importCsv(dto.rows, req.user);
  }

  @Get(':id')
  @AllowMemberAccess()
  async findOne(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.membersService.findById(id, req.user);
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateMemberDto,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.membersService.update(id, dto, req.user);
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Patch(':id/status')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async changeStatus(
    @Param('id') id: string,
    @Body() dto: ChangeStatusDto,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.membersService.changeStatus(
      id,
      dto.status,
      dto.date,
      req.user,
      dto.membershipEndReason,
    );
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  remove(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.membersService.remove(id, req.user);
  }

  // Beneficiary endpoints
  @Post(':id/beneficiaries')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  addBeneficiary(
    @Param('id') memberId: string,
    @Body() dto: CreateBeneficiaryDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.beneficiariesService.create(memberId, dto, req.user);
  }

  @Patch(':memberId/beneficiaries/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateBeneficiary(
    @Param('id') id: string,
    @Body() dto: UpdateBeneficiaryDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.beneficiariesService.update(id, dto, req.user);
  }

  @Delete(':memberId/beneficiaries/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  removeBeneficiary(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.beneficiariesService.remove(id, req.user);
  }

  @Get(':id/protected-persons')
  @AllowMemberAccess()
  async listProtectedPersons(
    @Param('id') memberId: string,
    @Request() req: { user: ScopedUser },
  ) {
    const persons = await this.protectedPersonsService.findByMember(memberId, req.user);
    return maskProtectedPersonList(persons, req.user.role);
  }

  @Post(':id/protected-persons')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  addProtectedPerson(
    @Param('id') memberId: string,
    @Body() dto: CreateProtectedPersonDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.protectedPersonsService.create(memberId, dto, req.user);
  }

  @Patch(':memberId/protected-persons/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateProtectedPerson(
    @Param('id') id: string,
    @Body() dto: UpdateProtectedPersonDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.protectedPersonsService.update(id, dto, req.user);
  }

  @Delete(':memberId/protected-persons/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  removeProtectedPerson(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.protectedPersonsService.remove(id, req.user);
  }
}
