import { Type } from 'class-transformer';
import {
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';

class DocumentChecklistItemDto {
  @IsString()
  key: string;

  @IsBoolean()
  checked: boolean;
}

export class UpdateDeathClaimDocumentsDto {
  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => DocumentChecklistItemDto)
  items: DocumentChecklistItemDto[];

  @IsOptional()
  @IsBoolean()
  documentsComplete?: boolean;
}