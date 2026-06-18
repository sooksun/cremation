import { SetMetadata } from '@nestjs/common';

export const ALLOW_VIEWER_WRITE_KEY = 'allowViewerWrite';
export const AllowViewerWrite = () => SetMetadata(ALLOW_VIEWER_WRITE_KEY, true);