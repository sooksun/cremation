import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
  Request,
} from '@nestjs/common';
import { Role } from '@prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { SchoolAdminsService } from './school-admins.service';
import { CreateSchoolAdminDto } from './dto/create-school-admin.dto';
import { UpdateSchoolAdminDto } from './dto/update-school-admin.dto';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('school-admins')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN)
export class SchoolAdminsController {
  constructor(private readonly schoolAdminsService: SchoolAdminsService) {}

  @Get()
  findAll() {
    return this.schoolAdminsService.findAll();
  }

  @Get('by-school/:schoolId')
  findBySchool(@Param('schoolId') schoolId: string) {
    return this.schoolAdminsService.findBySchoolId(schoolId);
  }

  @Post()
  create(@Body() dto: CreateSchoolAdminDto, @Request() req: { user: ScopedUser }) {
    return this.schoolAdminsService.create(dto, req.user);
  }

  @Patch('by-school/:schoolId')
  update(
    @Param('schoolId') schoolId: string,
    @Body() dto: UpdateSchoolAdminDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.schoolAdminsService.update(schoolId, dto, req.user);
  }

  @Delete('by-school/:schoolId')
  remove(@Param('schoolId') schoolId: string, @Request() req: { user: ScopedUser }) {
    return this.schoolAdminsService.remove(schoolId, req.user);
  }
}