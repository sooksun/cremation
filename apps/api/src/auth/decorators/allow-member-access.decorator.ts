import { SetMetadata } from '@nestjs/common';

export const ALLOW_MEMBER_ACCESS_KEY = 'allowMemberAccess';
export const AllowMemberAccess = () => SetMetadata(ALLOW_MEMBER_ACCESS_KEY, true);
