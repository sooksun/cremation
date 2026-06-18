import { Global, Module } from '@nestjs/common';
import { DocumentNumberService } from './document-number.service';
import { PrismaModule } from '../prisma/prisma.module';
import { SchoolScopeService } from './security/school-scope.service';
import { AuditLogService } from './services/audit-log.service';
import { AppSettingsService } from './services/app-settings.service';

@Global()
@Module({
  imports: [PrismaModule],
  providers: [DocumentNumberService, SchoolScopeService, AuditLogService, AppSettingsService],
  exports: [DocumentNumberService, SchoolScopeService, AuditLogService, AppSettingsService],
})
export class CommonModule {}