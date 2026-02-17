import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { UpdateSignatureDto } from './dto/update-signature.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { UsersService } from '../users/users.service';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly usersService: UsersService,
  ) {}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get('me')
  async getProfile(@Request() req: any) {
    const { passwordHash, ...user } = req.user;
    return user;
  }

  @UseGuards(JwtAuthGuard)
  @Post('me/signature')
  async updateMySignature(@Request() req: any, @Body() updateSignatureDto: UpdateSignatureDto) {
    return await this.usersService.update(req.user.id, { signature: updateSignatureDto.signature });
  }
}

