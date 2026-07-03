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
import { SchoolsService } from './schools.service';
import { CreateSchoolDto } from './dto/create-school.dto';
import { UpdateSchoolDto } from './dto/update-school.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('schools')
@UseGuards(JwtAuthGuard)
export class SchoolsController {
  constructor(private readonly schoolsService: SchoolsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  create(@Body() createSchoolDto: CreateSchoolDto, @Request() req: { user: ScopedUser }) {
    return this.schoolsService.create(createSchoolDto, req.user);
  }

  @Get()
  findAll(
    @Query('includeInactive') includeInactive?: string,
    @Query('clusterId') clusterId?: string,
  ) {
    return this.schoolsService.findAll(includeInactive === 'true', clusterId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.schoolsService.findById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  update(@Param('id') id: string, @Body() updateSchoolDto: UpdateSchoolDto, @Request() req: { user: ScopedUser }) {
    return this.schoolsService.update(id, updateSchoolDto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.schoolsService.remove(id, req.user);
  }
}

