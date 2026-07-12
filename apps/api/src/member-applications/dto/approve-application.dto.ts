import { IsOptional, IsString } from 'class-validator';

export class ApproveApplicationDto {
  // คำรับรอง ผอ. (ระเบียบ ข้อ 15)
  @IsOptional()
  @IsString()
  directorName?: string;

  // กรรมการรับสมัคร
  @IsOptional()
  @IsString()
  committeeName?: string;
}
