import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { CommonModule } from './common/common.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { SchoolsModule } from './schools/schools.module';
import { MemberTypesModule } from './member-types/member-types.module';
import { GroupsModule } from './groups/groups.module';
import { MembersModule } from './members/members.module';
import { ContributionsModule } from './contributions/contributions.module';
import { DeathClaimsModule } from './death-claims/death-claims.module';
import { AccountsModule } from './accounts/accounts.module';
import { BankAccountsModule } from './bank-accounts/bank-accounts.module';
import { ReceiptsModule } from './receipts/receipts.module';
import { PaymentsModule } from './payments/payments.module';
import { ReportsModule } from './reports/reports.module';
import { AssociationMembersModule } from './association-members/association-members.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '../../.env',
    }),
    PrismaModule,
    CommonModule,
    AuthModule,
    UsersModule,
    SchoolsModule,
    MemberTypesModule,
    GroupsModule,
    MembersModule,
    ContributionsModule,
    DeathClaimsModule,
    AccountsModule,
    BankAccountsModule,
    ReceiptsModule,
    PaymentsModule,
    ReportsModule,
    AssociationMembersModule,
  ],
})
export class AppModule {}

