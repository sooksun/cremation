import { Module } from '@nestjs/common';
import { SchoolClustersController } from './school-clusters.controller';
import { SchoolClustersService } from './school-clusters.service';

@Module({
  controllers: [SchoolClustersController],
  providers: [SchoolClustersService],
  exports: [SchoolClustersService],
})
export class SchoolClustersModule {}