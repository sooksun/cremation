import { ArrayNotEmpty, IsArray, IsOptional, IsString } from 'class-validator';

export class AssignMembersDto {
  @IsArray()
  @ArrayNotEmpty({ message: 'กรุณาเลือกสมาชิกอย่างน้อย 1 คน' })
  @IsString({ each: true })
  memberIds: string[];
}

export class AutoAssignGroupsDto {
  // ไม่ระบุ = ทำทุกโรงเรียนที่ผู้ใช้เข้าถึงได้
  @IsOptional()
  @IsString()
  schoolId?: string;
}
