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
import { GroupsService } from './groups.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { UpdateGroupDto } from './dto/update-group.dto';
import { AssignMembersDto, AutoAssignGroupsDto } from './dto/assign-members.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('groups')
@UseGuards(JwtAuthGuard)
export class GroupsController {
  constructor(private readonly groupsService: GroupsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  create(
    @Body() dto: CreateGroupDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.create(dto, req.user);
  }

  @Get()
  findAll(@Query('schoolId') schoolId?: string) {
    return this.groupsService.findAll(schoolId);
  }

  @Get('auto-assign/preview')
  previewAutoAssign(
    @Request() req: { user: ScopedUser },
    @Query('schoolId') schoolId?: string,
  ) {
    return this.groupsService.previewAutoAssign(schoolId, req.user);
  }

  @Post('auto-assign')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  autoAssign(
    @Body() dto: AutoAssignGroupsDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.autoAssignBySchool(dto.schoolId, req.user);
  }

  @Get(':id')
  findOne(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.findById(id, req.user);
  }

  @Patch(':id/members')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  assignMembers(
    @Param('id') id: string,
    @Body() dto: AssignMembersDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.assignMembers(id, dto.memberIds, req.user);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  update(
    @Param('id') id: string,
    @Body() dto: UpdateGroupDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.update(id, dto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN)
  remove(
    @Param('id') id: string,
    @Request() req: { user: ScopedUser },
  ) {
    return this.groupsService.remove(id, req.user);
  }
}