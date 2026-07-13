-- ============================================================
-- MariaDB setup สำหรับ Cremation Welfare System
-- รันบน host MariaDB ด้วยสิทธิ admin (root) ครั้งเดียวก่อน deploy:
--   mysql -u root -p < deploy/mariadb-setup.sql
-- หรือ import ผ่าน phpMyAdmin
--
-- ต้องแน่ใจว่า MariaDB bind 0.0.0.0:3306 (ไม่ใช่ 127.0.0.1) เพื่อให้
-- container ต่อผ่าน host.docker.internal ได้
-- ============================================================

CREATE DATABASE IF NOT EXISTS cremation_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- user เฉพาะของ app — container ต่อผ่าน host-gateway จึงเห็น host เป็น docker subnet (172.%)
-- ใช้ '%' เพื่อความง่าย (เครื่อง LAN-only); จะรัดกุมขึ้นให้เปลี่ยนเป็น '172.%' ก็ได้
-- เปลี่ยน 'CHANGE_ME' ให้ตรงกับรหัสใน DATABASE_URL ของ .env.production
CREATE USER IF NOT EXISTS 'cremation_app'@'%' IDENTIFIED BY 'CHANGE_ME';
GRANT ALL PRIVILEGES ON cremation_db.* TO 'cremation_app'@'%';

FLUSH PRIVILEGES;
