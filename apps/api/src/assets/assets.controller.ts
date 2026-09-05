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
import { AssetsService } from './assets.service';
import { CreateAssetDto, UpdateAssetDto, RecordDepreciationDto } from './dto/asset.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '@prisma/client';
import { ScopedUser } from '../common/security/school-scope.service';

@Controller('assets')
@UseGuards(JwtAuthGuard, RolesGuard)
// @Roles ระดับคลาสเป็นค่าเริ่มต้นของทุก route ในไฟล์นี้ — RolesGuard อ่านแบบ
// getAllAndOverride([handler, class]) route ที่ประกาศเองจึงยัง override ได้ตามเดิม
// เดิม GET ทุกตัวไม่มี @Roles เลย ทำให้ VIEWER/GROUP_LEADER เห็นข้อมูลการเงินทั้งสมาคม
@Roles(Role.ADMIN, Role.SCHOOL_ADMIN, Role.ACCOUNTING)
export class AssetsController {
  constructor(private readonly assetsService: AssetsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  create(@Body() dto: CreateAssetDto, @Request() req: { user: ScopedUser }) {
    return this.assetsService.create(dto, req.user);
  }

  @Get()
  findAll(
    @Query('schoolId') schoolId?: string,
    @Request() req?: { user: ScopedUser },
  ) {
    return this.assetsService.findAll(schoolId, req?.user);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.assetsService.findById(id, req.user);
  }

  @Patch(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  update(
    @Param('id') id: string,
    @Body() dto: UpdateAssetDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.assetsService.update(id, dto, req.user);
  }

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  remove(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.assetsService.remove(id, req.user);
  }

  @Post(':id/depreciation')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.ACCOUNTING)
  recordDepreciation(
    @Param('id') id: string,
    @Body() dto: RecordDepreciationDto,
    @Request() req: { user: ScopedUser },
  ) {
    return this.assetsService.recordDepreciation(id, dto, req.user);
  }

  @Get(':id/schedule')
  getSchedule(@Param('id') id: string, @Request() req: { user: ScopedUser }) {
    return this.assetsService.findById(id, req.user).then((asset) =>
      this.assetsService.getDepreciationSchedule(asset),
    );
  }
}