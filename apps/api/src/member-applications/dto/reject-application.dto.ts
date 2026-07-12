import { IsNotEmpty, IsString } from 'class-validator';

export class RejectApplicationDto {
  @IsString()
  @IsNotEmpty({ message: 'กรุณาระบุเหตุผลการปฏิเสธใบสมัคร' })
  reason: string;
}
