import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { PrismaModule } from './prisma/prisma.module';
import { CommonModule } from './common/common.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { SchoolsModule } from './schools/schools.module';
import { SchoolClustersModule } from './school-clusters/school-clusters.module';
import { MemberTypesModule } from './member-types/member-types.module';
import { GroupsModule } from './groups/groups.module';
import { MembersModule } from './members/members.module';
import { ContributionsModule } from './contributions/contributions.module';
import { DeathClaimsModule } from './death-claims/death-claims.module';
import { AccountsModule } from './accounts/accounts.module';
import { BankAccountsModule } from './bank-accounts/bank-accounts.module';
import { AssetsModule } from './assets/assets.module';
import { CashBookModule } from './cash-book/cash-book.module';
import { ReceiptsModule } from './receipts/receipts.module';
import { PaymentsModule } from './payments/payments.module';
import { ReportsModule } from './reports/reports.module';
import { AssociationMembersModule } from './association-members/association-members.module';
import { MemberApplicationsModule } from './member-applications/member-applications.module';
import { AuditLogsModule } from './audit-logs/audit-logs.module';
import { SchoolAdminsModule } from './school-admins/school-admins.module';
import { AssistantModule } from './assistant/assistant.module';
import { SchoolScopeInterceptor } from './common/interceptors/school-scope.interceptor';
import { ViewerReadOnlyGuard } from './auth/guards/viewer-readonly.guard';
import { HealthController } from './health.controller';

@Module({
  controllers: [HealthController],
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '../../.env',
    }),
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 100,
      },
    ]),
    PrismaModule,
    CommonModule,
    AuthModule,
    UsersModule,
    SchoolsModule,
    SchoolClustersModule,
    MemberTypesModule,
    GroupsModule,
    MembersModule,
    ContributionsModule,
    DeathClaimsModule,
    AccountsModule,
    BankAccountsModule,
    AssetsModule,
    CashBookModule,
    ReceiptsModule,
    PaymentsModule,
    ReportsModule,
    AssociationMembersModule,
    MemberApplicationsModule,
    AuditLogsModule,
    SchoolAdminsModule,
    AssistantModule,
  ],
  providers: [
    SchoolScopeInterceptor,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: ViewerReadOnlyGuard,
    },
    {
      provide: APP_INTERCEPTOR,
      useClass: SchoolScopeInterceptor,
    },
  ],
})
export class AppModule {}