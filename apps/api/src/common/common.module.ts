import { Global, Module } from '@nestjs/common';
import { DocumentNumberService } from './document-number.service';
import { PrismaModule } from '../prisma/prisma.module';

@Global()
@Module({
  imports: [PrismaModule],
  providers: [DocumentNumberService],
  exports: [DocumentNumberService],
})
export class CommonModule {}

