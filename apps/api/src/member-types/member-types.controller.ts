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
import { MemberTypesService } from './member-types.service';
import { CreateMemberTypeDto } from './dto/create-member-type.dto';
import { UpdateMemberTypeDto } from './dto/update-member-type.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('member-types')
@UseGuards(JwtAuthGuard)
export class MemberTypesController {
  constructor(private readonly memberTypesService: MemberTypesService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  create(@Body() dto: CreateMemberTypeDto, @Request() req: { user: ScopedUser }) {
    return this.memberTypesService.create(dto, req.user);
  }

  @Get()
  findAll(@Query('includeInactive') includeInactive?: string) {
    return this.memberTypesService.findAll(includeInactive === 'true');
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.memberTypesService.findById(id);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  update(@Param('id') id: string, @Body() dto: UpdateMemberTypeDto, @Request() req: { user: ScopedUser }) {
    return this.memberTypesService.update(id, dto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.memberTypesService.remove(id, req.user);
  }
}

