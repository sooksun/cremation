import {
  Controller,
  Get,
  Patch,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { AssociationMembersService, AssociationMemberQueryParams } from './association-members.service';
import { UpdateAssociationMemberDto } from './dto/update-association-member.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role, MemberStatus } from '@prisma/client';

@Controller('association-members')
@UseGuards(JwtAuthGuard)
export class AssociationMembersController {
  constructor(private readonly associationMembersService: AssociationMembersService) {}

  @Get()
  findAll(
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
    return this.associationMembersService.findAll(params);
  }

  @Get(':memberId')
  findOne(@Param('memberId') memberId: string) {
    return this.associationMembersService.findByMemberId(memberId);
  }

  @Patch(':memberId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.FINANCE)
  update(
    @Param('memberId') memberId: string,
    @Body() dto: UpdateAssociationMemberDto,
  ) {
    return this.associationMembersService.update(memberId, dto);
  }
}
