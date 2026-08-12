import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AssociationMembersService, AssociationMemberQueryParams } from './association-members.service';
import { CreateAssociationMemberDto } from './dto/create-association-member.dto';
import { UpdateAssociationMemberDto } from './dto/update-association-member.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, MemberStatus } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';
import {
  maskAssociationMemberListResponse,
  maskAssociationMemberRow,
  maskMemberWithAssociation,
} from '../common/utils/pii-response.util';

@Controller('association-members')
@UseGuards(JwtAuthGuard)
export class AssociationMembersController {
  constructor(private readonly associationMembersService: AssociationMembersService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  async create(
    @Body() dto: CreateAssociationMemberDto,
    @Request() req: { user: ScopedUser },
  ) {
    const row = await this.associationMembersService.create(dto, req.user);
    return maskAssociationMemberRow(row, req.user.role);
  }

  @Get()
  async findAll(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
    @Query('status') status?: MemberStatus,
    @Query('search') search?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    const params: AssociationMemberQueryParams = {
      schoolId,
      status,
      search,
      page: page ? Number(page) : undefined,
      limit: limit ? Number(limit) : undefined,
    };
    const result = await this.associationMembersService.findAll(params, req.user);
    return maskAssociationMemberListResponse(result, req.user.role);
  }

  @Get(':memberId')
  async findOne(
    @Param('memberId') memberId: string,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.associationMembersService.findByMemberId(memberId, req.user);
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Patch('by-id/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async updateById(
    @Param('id') associationMemberId: string,
    @Body() dto: UpdateAssociationMemberDto,
    @Request() req: { user: ScopedUser },
  ) {
    const row = await this.associationMembersService.updateById(
      associationMemberId,
      dto,
      req.user,
    );
    return maskAssociationMemberRow(row, req.user.role);
  }

  @Patch(':memberId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  async update(
    @Param('memberId') memberId: string,
    @Body() dto: UpdateAssociationMemberDto,
    @Request() req: { user: ScopedUser },
  ) {
    const member = await this.associationMembersService.update(memberId, dto, req.user);
    return maskMemberWithAssociation(member, req.user.role);
  }

  @Delete('by-id/:id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  async removeById(
    @Param('id') associationMemberId: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.associationMembersService.removeById(associationMemberId, req.user);
  }
}