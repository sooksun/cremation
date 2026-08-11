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
import { SchoolClustersService } from './school-clusters.service';
import { CreateSchoolClusterDto } from './dto/create-school-cluster.dto';
import { UpdateSchoolClusterDto } from './dto/update-school-cluster.dto';

@Controller('school-clusters')
@UseGuards(JwtAuthGuard)
export class SchoolClustersController {
  constructor(private readonly schoolClustersService: SchoolClustersService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  create(@Body() dto: CreateSchoolClusterDto) {
    return this.schoolClustersService.create(dto);
  }

  @Get()
  findAll() {
    return this.schoolClustersService.findAll();
  }

  @Get('hierarchy')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  findHierarchy() {
    return this.schoolClustersService.findHierarchy();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.schoolClustersService.findById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  update(@Param('id') id: string, @Body() dto: UpdateSchoolClusterDto) {
    return this.schoolClustersService.update(id, dto);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string) {
    return this.schoolClustersService.remove(id);
  }
}