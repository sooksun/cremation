import { AuditAction } from '@prisma/client';
import { AuthController } from './auth.controller';

/**
 * USER_LOGOUT ถูกประกาศไว้ใน AuditAction ตั้งแต่แรกคู่กับ USER_LOGIN
 * (คอมเมนต์ในสคีมาแยกหมวด "Authentication" ไว้ทั้งคู่) แต่ handler เดิม
 * ไม่เคยเรียก auditLog เลย log การออกจากระบบจึงไม่มีอยู่ในระบบมาตลอด
 */
describe('AuthController.logout', () => {
  function build() {
    const auditLog = { log: jest.fn() };
    const controller = new AuthController(
      {} as never,
      {} as never,
      auditLog as never,
    );
    const res = { clearCookie: jest.fn() };
    return { controller, auditLog, res };
  }

  it('บันทึกการออกจากระบบพร้อมผู้ใช้ที่ทำรายการ', async () => {
    const { controller, auditLog, res } = build();
    const req: any = {
      user: { id: 'user-1', username: 'admin', schoolId: 'school-a' },
      ip: '10.0.0.1',
    };

    const result = await controller.logout(res as never, req);

    expect(auditLog.log).toHaveBeenCalledWith(
      expect.objectContaining({
        userId: 'user-1',
        action: AuditAction.USER_LOGOUT,
        entityType: 'User',
        entityId: 'user-1',
        schoolId: 'school-a',
      }),
    );
    expect(result.message).toContain('ออกจากระบบ');
  });

  it('ล้าง cookie เสมอแม้ไม่มีข้อมูลผู้ใช้', async () => {
    const { controller, auditLog, res } = build();

    await controller.logout(res as never, { user: undefined } as never);

    expect(res.clearCookie).toHaveBeenCalled();
    expect(auditLog.log).not.toHaveBeenCalled();
  });
});
