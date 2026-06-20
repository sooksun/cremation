import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { Role } from '@prisma/client';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { SchoolAdminsService } from './school-admins.service';
import { CreateSchoolAdminDto } from './dto/create-school-admin.dto';
import { UpdateSchoolAdminDto } from './dto/update-school-admin.dto';

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
  create(@Body() dto: CreateSchoolAdminDto) {
    return this.schoolAdminsService.create(dto);
  }

  @Patch('by-school/:schoolId')
  update(
    @Param('schoolId') schoolId: string,
    @Body() dto: UpdateSchoolAdminDto,
  ) {
    return this.schoolAdminsService.update(schoolId, dto);
  }

  @Delete('by-school/:schoolId')
  remove(@Param('schoolId') schoolId: string) {
    return this.schoolAdminsService.remove(schoolId);
  }
}