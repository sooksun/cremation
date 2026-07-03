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
import { Throttle } from '@nestjs/throttler';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @Roles(Role.ADMIN)
  @Throttle({ default: { limit: 10, ttl: 60000 } }) // Limit user creation (admin only)
  create(@Body() createUserDto: CreateUserDto, @Request() req: { user: ScopedUser }) {
    return this.usersService.create(createUserDto, req.user);
  }

  @Get()
  @Roles(Role.ADMIN)
  findAll(@Query('schoolId') schoolId?: string) {
    return this.usersService.findAll(schoolId);
  }

  @Get(':id')
  @Roles(Role.ADMIN)
  findOne(@Param('id') id: string) {
    return this.usersService.findById(id);
  }

  @Patch(':id')
  @Roles(Role.ADMIN)
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto, @Request() req: { user: ScopedUser }) {
    return this.usersService.update(id, updateUserDto, req.user);
  }

  @Delete(':id')
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.usersService.remove(id, req.user);
  }

  @Patch(':id/signature')
  @Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.FINANCE)
  updateSignature(@Param('id') id: string, @Body() body: { signature: string }, @Request() req: { user: ScopedUser }) {
    return this.usersService.update(id, { signature: body.signature }, req.user);
  }
}

