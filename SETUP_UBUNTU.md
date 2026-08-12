# คู่มือการ Setup & Run บน Ubuntu

## ระบบจัดการฌาปนกิจสงเคราะห์ครู
### Cremation Welfare Management System for Teachers

---

## 📋 สารบัญ

0. [🐳 Docker Deploy (Production — แนะนำ)](#0-docker-deploy-production--แนะนำ)
1. [Prerequisites](#1-prerequisites)
2. [ติดตั้ง Node.js และ pnpm](#2-ติดตั้ง-nodejs-และ-pnpm)
3. [ติดตั้ง MySQL](#3-ติดตั้ง-mysql)
4. [Clone และ Setup โปรเจกต์](#4-clone-และ-setup-โปรเจกต์)
5. [ตั้งค่า Environment Variables](#5-ตั้งค่า-environment-variables)
6. [Setup Database](#6-setup-database)
7. [Run Development Servers](#7-run-development-servers)
8. [การเข้าถึงระบบ](#8-การเข้าถึงระบบ)
9. [Troubleshooting](#9-troubleshooting)

---

## 0. 🐳 Docker Deploy (Production — แนะนำ)

Deploy ด้วย Docker บน Ubuntu server ที่ path **`/DATA/AppData/www/cremation`**
เข้าถึงระบบที่ **`http://192.168.1.4:9950`** (หัวข้อ 1–9 ด้านล่างเป็นแบบ manual dev-install ไม่ใช้ Docker)

### สถาปัตยกรรม

| Service  | Host port | เข้าถึง                        | หมายเหตุ                                   |
|----------|-----------|-------------------------------|-------------------------------------------|
| `web`    | 9950:3000 | `http://192.168.1.4:9950`     | Next.js standalone (จุดเข้าหลัก)          |
| `api`    | 9951:4000 | `http://192.168.1.4:9951/api` | NestJS + Prisma (prefix `/api`)           |
| `backup` | —         | —                             | mariadb-dump รายวัน → `./backup` เก็บ 14 วัน |

- **Database**: ใช้ MariaDB ที่รันบน host อยู่แล้ว ผ่าน `host.docker.internal:3306` (ไม่ bundle DB ใน compose)
- **Deploy**: **git clone/pull จาก `main`** ผ่าน SSH deploy key → build image บน server จาก source โดยตรง

### ข้อกำหนดเบื้องต้น (บน server)

- Docker + Docker Compose plugin, Git
- MariaDB รันบน host และ **bind `0.0.0.0:3306`** (ให้ container ต่อผ่าน host-gateway ได้)
- **SSH deploy key** สำหรับ clone/pull repo (private)

### 0.1 เตรียม SSH deploy key (ครั้งเดียว)

```bash
# สร้าง key บน server (ไม่ตั้ง passphrase เพื่อให้ pull อัตโนมัติได้)
ssh-keygen -t ed25519 -C "cremation-deploy@192.168.1.4" -f ~/.ssh/cremation_deploy -N ""

# แสดง public key แล้วคัดลอกไปเพิ่มที่ GitHub
cat ~/.ssh/cremation_deploy.pub
```

เอา public key ไปเพิ่มที่ **GitHub → repo `sooksun/cremation` → Settings → Deploy keys → Add deploy key**
(อ่านอย่างเดียวพอ ไม่ต้องติ๊ก "Allow write access") — ขั้นนี้ทำผ่านหน้าเว็บ GitHub เอง

ผูก key กับ host github.com:

```bash
cat >> ~/.ssh/config <<'EOF'
Host github.com
  IdentityFile ~/.ssh/cremation_deploy
  IdentitiesOnly yes
EOF
ssh -T git@github.com        # ควรขึ้น "Hi sooksun/cremation! You've successfully authenticated"
```

### 0.2 ขั้นตอนติดตั้ง (ครั้งแรก)

```bash
# 1) เตรียม database + user บน host MariaDB (แก้ CHANGE_ME ในไฟล์ก่อน หรือแก้ user ทีหลัง)
#    (ถ้ายังไม่มี repo บนเครื่อง ให้ clone ก่อนตามข้อ 2 แล้วค่อยรันไฟล์นี้)

# 2) clone จาก main ไปที่ path มาตรฐาน
sudo mkdir -p /DATA/AppData/www && sudo chown "$USER" /DATA/AppData/www
git clone -b main git@github.com:sooksun/cremation.git /DATA/AppData/www/cremation
cd /DATA/AppData/www/cremation

mysql -u root -p < deploy/mariadb-setup.sql   # เตรียม DB (ข้อ 1)

# 3) สร้างไฟล์ env จริง (gitignored) แล้วเติมค่า
cp .env.production.example .env.production
nano .env.production
#   - DATABASE_URL: ใส่รหัส cremation_app ให้ตรงกับที่ตั้งใน mariadb-setup.sql
#   - JWT_SECRET:   openssl rand -base64 48
#   - WEB_ORIGIN / NEXT_PUBLIC_API_URL: แก้ IP ถ้าไม่ใช่ 192.168.1.4

# 4) ติดตั้ง (build → up → migrate auto → seed)
bash deploy/install.sh
```

เปิด `http://192.168.1.4:9950` แล้ว login admin จาก seed → **เปลี่ยนรหัสทันที**

### อัปเดตเวอร์ชัน

```bash
cd /DATA/AppData/www/cremation
bash deploy/update.sh     # git pull → rebuild → restart (migrate auto)
```

### คำสั่งที่ใช้บ่อย

```bash
# ตั้ง alias สั้น ๆ
COMPOSE="docker compose -f docker-compose.prod.yml --env-file .env.production"

$COMPOSE ps                        # สถานะ
$COMPOSE logs -f api               # log api (migrate/boot errors)
$COMPOSE logs -f web
$COMPOSE --profile seed run --rm seed   # seed ซ้ำ (idempotent)
$COMPOSE up -d --force-recreate --no-deps api   # restart เฉพาะ api
$COMPOSE down                      # หยุดทั้งหมด (DB บน host ไม่โดนแตะ)
```

### เมื่อเปลี่ยน IP/port

`NEXT_PUBLIC_API_URL` ถูก **bake เข้า web image ตอน build** — ถ้าเปลี่ยน IP หรือ port ต้อง:
1. แก้ `.env.production` (`WEB_ORIGIN`, `NEXT_PUBLIC_API_URL`)
2. `$COMPOSE build web && $COMPOSE up -d --force-recreate web`

### 0.3 Backup

**ในเครื่อง** — service `backup` dump `cremation_db` วันละครั้งลง `backup/` เก็บ 14 วัน
(`BACKUP_RETAIN_DAYS`) ถ้า dump ล้ม สคริปต์จะ exit 1 และไม่เขียนไฟล์ทิ้งไว้ ตรวจได้ที่:

```bash
$COMPOSE logs backup --tail 20     # ต้องเห็น "[backup] done: ... N tables"
ls -lh backup/*.sql.gz             # ไฟล์ปกติ ~90KB+ ถ้าเจอไฟล์ 20 bytes แปลว่าพัง
```

**นอกเครื่อง (off-host)** — `backup/offsite.sh` เข้ารหัส dump ด้วย gpg (AES256) แล้วอัปขึ้น
cloud ผ่าน rclone รันบน **host** ไม่ใช่ใน container เพราะ image `mariadb:11` ไม่มี rclone

ตั้งค่าครั้งเดียว:

```bash
cd /DATA/AppData/www/cremation

# 1) ผูก remote (เลือก b2 หรือ s3) — ตั้งชื่อ remote ว่า b2
rclone config

# 2) สร้าง passphrase (ไม่แสดงบนจอ) แล้วล็อกสิทธิ์ไฟล์
openssl rand -base64 48 > .backup-passphrase
chmod 600 .backup-passphrase

# 3) เก็บ passphrase ใส่ password manager — ถ้าหาย restore ไม่ได้ตลอดกาล
cat .backup-passphrase

# 4) ตั้งค่าปลายทาง
cat > .env.offsite <<'EOF'
OFFSITE_REMOTE=b2:cremation-backups/db
OFFSITE_PASSPHRASE_FILE=/DATA/AppData/www/cremation/.backup-passphrase
OFFSITE_RETAIN_DAYS=90
EOF
chmod 600 .env.offsite

# 5) ทดสอบ แล้วตั้ง cron 03:30 ทุกวัน
bash backup/offsite.sh
crontab -e   # 30 3 * * * /DATA/AppData/www/cremation/backup/offsite.sh >> /DATA/AppData/www/cremation/backup/offsite.log 2>&1
```

กู้คืน:

```bash
bash backup/restore-offsite.sh --list    # ดูรายการบนปลายทาง
bash backup/restore-offsite.sh           # ดึงไฟล์ล่าสุดมาถอดรหัสไว้ที่ backup/restored/
```

`.env.offsite`, `.backup-passphrase`, `backup/.encrypted/`, `backup/restored/` ถูก gitignore ไว้
ห้าม commit — dump มีเลขบัตรประชาชนและ hash รหัสผ่านของสมาชิกทุกคน

### Troubleshooting (Docker)

| อาการ | สาเหตุ / วิธีแก้ |
|-------|------------------|
| api restart loop, log `Can't reach database` | MariaDB ไม่ bind 0.0.0.0 หรือ user `cremation_app` ยังไม่ grant ให้ต่อจาก docker subnet (`'%'` / `'172.%'`) |
| backup ได้ไฟล์ 20 bytes | dump ล้มแต่ pipeline กลืน error — แก้แล้วใน `backup.sh` ถ้าเจออีกให้ดู log ว่า auth ผ่านไหม และ container `backup` ถือ `DATABASE_URL` ตรงกับ `.env.production` หรือยัง (`update.sh` recreate ให้แล้ว) |
| `[offsite] FAILED: rclone ยังไม่มี remote` | ยังไม่ได้รัน `rclone config` บน host หรือชื่อ remote ไม่ตรงกับ `OFFSITE_REMOTE` |
| หน้าเว็บโหลดได้แต่ทุก API call ล้ม CORS | `WEB_ORIGIN` ไม่ตรงกับ URL ที่เปิดจริง — แก้แล้ว restart api |
| กด API แล้ว 404 / เรียกผิด host | `NEXT_PUBLIC_API_URL` เก่าค้างใน web image — rebuild web (ดูหัวข้อด้านบน) |
| `JWT_SECRET` too short → api boot ไม่ขึ้น | JWT_SECRET ต้อง ≥ 32 ตัวอักษร |

---

## 1. Prerequisites

### ระบบที่ต้องการ:
- **OS**: Ubuntu 20.04 LTS หรือใหม่กว่า
- **RAM**: อย่างน้อย 4GB (แนะนำ 8GB+)
- **Disk Space**: อย่างน้อย 5GB

### Software ที่ต้องติดตั้ง:
- Node.js 18+ 
- pnpm 8+
- MySQL Server 8.0+
- Git

---

## 2. ติดตั้ง Node.js และ pnpm

### 2.1 ติดตั้ง Node.js (ใช้ nvm - แนะนำ)

```bash
# ติดตั้ง nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell configuration
source ~/.bashrc

# ติดตั้ง Node.js LTS (เวอร์ชัน 20.x)
nvm install 20
nvm use 20
nvm alias default 20

# ตรวจสอบเวอร์ชัน
node -v  # ควรแสดง v20.x.x
npm -v
```

### 2.2 ติดตั้ง pnpm

```bash
# ติดตั้ง pnpm แบบ global
npm install -g pnpm

# ตรวจสอบเวอร์ชัน
pnpm -v  # ควรแสดง 8.x.x หรือใหม่กว่า
```

### 2.3 (ทางเลือก) ติดตั้ง Node.js แบบตรง

```bash
# อัปเดต package list
sudo apt update

# ติดตั้ง Node.js จาก NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# ตรวจสอบเวอร์ชัน
node -v
npm -v
```

---

## 3. ติดตั้ง MySQL

### 3.1 ติดตั้ง MySQL Server

```bash
# อัปเดต package list
sudo apt update

# ติดตั้ง MySQL Server
sudo apt install -y mysql-server

# เริ่ม service
sudo systemctl start mysql
sudo systemctl enable mysql

# ตรวจสอบสถานะ
sudo systemctl status mysql
```

### 3.2 ตั้งค่ารหัสผ่าน root

```bash
# รัน MySQL secure installation
sudo mysql_secure_installation

# หรือตั้งค่ารหัสผ่านผ่าน MySQL CLI
sudo mysql
```

ใน MySQL prompt:
```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
EXIT;
```

### 3.3 ตั้งค่า MySQL สำหรับ Case Sensitivity

**สำคัญ**: Ubuntu มี case sensitivity ที่เคร่งครัด ต้องตั้งค่า MySQL ให้ถูกต้อง

```bash
# แก้ไข MySQL configuration
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

เพิ่มหรือแก้ไขบรรทัดต่อไปนี้ใน `[mysqld]` section:

```ini
[mysqld]
# ตั้งค่าให้ table names เป็น lowercase (แนะนำสำหรับ Ubuntu)
lower_case_table_names = 1

# หรือถ้าต้องการให้ case-sensitive (default บน Linux)
# lower_case_table_names = 0
```

**หมายเหตุ**: 
- `lower_case_table_names = 1`: MySQL จะแปลง table names เป็น lowercase อัตโนมัติ (แนะนำ)
- `lower_case_table_names = 0`: MySQL จะใช้ case-sensitive ตามที่ Prisma สร้าง (PascalCase)

**Restart MySQL:**
```bash
sudo systemctl restart mysql
sudo systemctl status mysql
```

### 3.4 สร้าง Database

```bash
# เข้าสู่ MySQL
mysql -u root -p

# สร้าง database (ใช้ lowercase เสมอ)
CREATE DATABASE cremation_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# ตรวจสอบ
SHOW DATABASES;

# ตรวจสอบ case sensitivity setting
SHOW VARIABLES LIKE 'lower_case_table_names';

# ออกจาก MySQL
EXIT;
```

**สำคัญ**: 
- Database name ต้องเป็น **lowercase**: `cremation_db` (ไม่ใช่ `Cremation_DB` หรือ `CREMATION_DB`)
- Table names จะถูกสร้างตาม Prisma schema (PascalCase เช่น `User`, `School`) ซึ่งจะทำงานได้ปกติ

---

## 4. Clone และ Setup โปรเจกต์

### 4.1 Clone Repository

```bash
# Clone repository (แทนที่ <repository-url> ด้วย URL จริง)
git clone <repository-url>
cd cremation
```

### 4.2 ติดตั้ง Dependencies

```bash
# ติดตั้ง dependencies ทั้งหมด (root + apps/api + apps/web)
pnpm install

# ตรวจสอบว่า dependencies ติดตั้งสำเร็จ
pnpm list --depth=0
```

**หมายเหตุ**: การติดตั้งอาจใช้เวลาสักครู่ (5-10 นาที) ขึ้นอยู่กับความเร็วอินเทอร์เน็ต

---

## 5. ตั้งค่า Environment Variables

### 5.1 สร้างไฟล์ .env

```bash
# สร้างไฟล์ .env ใน root directory
cd /path/to/cremation
touch .env
```

### 5.2 แก้ไขไฟล์ .env

```bash
# เปิดไฟล์ด้วย text editor
nano .env
```

**เนื้อหาไฟล์ .env:**

```env
# Database
DATABASE_URL="mysql://root:your_password@localhost:3306/cremation_db"

# JWT
JWT_SECRET="your-super-secret-jwt-key-change-in-production-min-32-chars"
JWT_EXPIRES_IN="7d"

# API
API_PORT=3001
NODE_ENV=development

# Frontend
NEXT_PUBLIC_API_URL="http://localhost:3001/api"

# CORS Configuration (สำหรับ production หรือ multiple origins)
# ใช้ CORS_ORIGINS สำหรับหลาย origins (คั่นด้วย comma)
CORS_ORIGINS="http://localhost:3000,http://203.172.184.47:8889"
# หรือใช้ FRONTEND_URL สำหรับ origin เดียว
# FRONTEND_URL="http://localhost:3000"
```

**สำคัญ**: 
- แทนที่ `your_password` ด้วยรหัสผ่าน MySQL ที่ตั้งไว้
- แทนที่ `your-super-secret-jwt-key-change-in-production-min-32-chars` ด้วย secret key ที่ปลอดภัย (อย่างน้อย 32 ตัวอักษร)
- **Database name ต้องเป็น lowercase**: `cremation_db` (ไม่ใช่ `Cremation_DB` หรือ `CREMATION_DB`) - Ubuntu มี case sensitivity ที่เคร่งครัด
- **CORS Configuration**: 
  - สำหรับ development: ใช้ `CORS_ORIGINS` หรือ `FRONTEND_URL` ตามที่ frontend ทำงาน
  - สำหรับ production: ระบุ origins ที่อนุญาตทั้งหมดใน `CORS_ORIGINS` (คั่นด้วย comma)
  - ตัวอย่าง: `CORS_ORIGINS="http://localhost:3000,http://203.172.184.47:8889,https://yourdomain.com"`

### 5.3 ตรวจสอบไฟล์ .env

```bash
# ตรวจสอบว่าไฟล์ถูกสร้างแล้ว
cat .env
```

---

## 6. Setup Database

### 6.1 ตรวจสอบ Environment Variables

**สำคัญ**: ตรวจสอบว่า DATABASE_URL ในไฟล์ `.env` ใช้ database name เป็น **lowercase**

```bash
# ตรวจสอบ DATABASE_URL
cd /path/to/cremation
cat .env | grep DATABASE_URL

# ควรเห็น:
# DATABASE_URL="mysql://root:your_password@localhost:3306/cremation_db"
#                                                          ^^^^^^^^^^^ lowercase
```

### 6.2 Generate Prisma Client

```bash
# ไปที่ directory API
cd apps/api

# Generate Prisma Client
npx prisma generate

# ตรวจสอบว่า generate สำเร็จ
ls -la node_modules/.prisma/client/
```

### 6.3 Run Database Migrations

```bash
# รัน migrations เพื่อสร้าง tables
npx prisma migrate dev --name init

# หรือถ้ามี migrations อยู่แล้ว
npx prisma migrate deploy
```

**ตรวจสอบ tables ที่สร้าง:**
```bash
# เข้าสู่ MySQL
mysql -u root -p cremation_db

# ดู tables ทั้งหมด
SHOW TABLES;

# ควรเห็น tables เช่น: User, School, Member, MemberContribution, etc.
# (ชื่อ tables จะเป็น PascalCase ตาม Prisma schema)

# ออกจาก MySQL
EXIT;
```

### 6.4 Seed Demo Data

```bash
# รัน seed script เพื่อสร้างข้อมูลตัวอย่าง
npx ts-node --project tsconfig.json prisma/seed.ts

# หรือใช้ script จาก root
cd ../..
pnpm db:seed
```

**ตรวจสอบข้อมูลที่ seed:**
```bash
# เข้าสู่ MySQL
mysql -u root -p cremation_db

# ตรวจสอบข้อมูล
SELECT COUNT(*) FROM User;
SELECT COUNT(*) FROM School;
SELECT COUNT(*) FROM Member;

# ควรเห็นข้อมูลที่ถูกสร้างแล้ว

# ออกจาก MySQL
EXIT;
```

**ข้อมูลที่ถูกสร้าง:**
- โรงเรียนตัวอย่าง (3 โรงเรียน)
- ประเภทสมาชิก
- กลุ่มสมาชิก
- สมาชิกตัวอย่าง
- User accounts (admin, finance, accounting)
- งวดเงินสงเคราะห์ตัวอย่าง

### 6.4 ตรวจสอบ Database

```bash
# เปิด Prisma Studio เพื่อดูข้อมูล
cd apps/api
npx prisma studio
```

Prisma Studio จะเปิดที่: http://localhost:5555

---

## 7. Run Development Servers

### 7.1 วิธีที่ 1: รันทั้ง API และ Web พร้อมกัน

```bash
# จาก root directory
cd /path/to/cremation
pnpm dev
```

### 7.2 วิธีที่ 2: รันแยกกัน (แนะนำสำหรับ debugging)

**Terminal 1 - API Server:**
```bash
cd /path/to/cremation
pnpm dev:api
```

**Terminal 2 - Web Server:**
```bash
cd /path/to/cremation
pnpm dev:web
```

### 7.3 ตรวจสอบว่า Servers ทำงาน

- **API Server**: ควรแสดง `Nest application successfully started on port 3001`
- **Web Server**: ควรแสดง `Ready on http://localhost:3000`

---

## 8. การเข้าถึงระบบ

### 8.1 URLs

- **Frontend (Web)**: http://localhost:3000
- **API**: http://localhost:3001/api
- **Prisma Studio**: http://localhost:5555 (เมื่อรัน `npx prisma studio`)

### 8.2 Test Accounts

| Username | Password | Role     | Description        |
|----------|----------|----------|--------------------|
| admin    | 1234     | ADMIN    | ผู้ดูแลระบบ        |
| finance  | 1234     | FINANCE  | เจ้าหน้าที่การเงิน |
| account  | 1234     | ACCOUNTING | เจ้าหน้าที่บัญชี  |

### 8.3 Login

1. เปิดเบราว์เซอร์ไปที่ http://localhost:3000
2. ใช้ username และ password จากตารางด้านบน
3. เลือกโรงเรียน (ถ้ามีหลายโรงเรียน)

---

## 9. Troubleshooting

### 9.1 ปัญหา: pnpm command not found

**แก้ไข:**
```bash
# ติดตั้ง pnpm อีกครั้ง
npm install -g pnpm

# หรือเพิ่ม PATH
export PATH="$PATH:$(npm config get prefix)/bin"
```

### 9.2 ปัญหา: Cannot connect to MySQL

**ตรวจสอบ:**
```bash
# ตรวจสอบว่า MySQL service ทำงาน
sudo systemctl status mysql

# เริ่ม service ถ้ายังไม่ทำงาน
sudo systemctl start mysql

# ตรวจสอบ connection
mysql -u root -p -e "SELECT 1;"
```

**แก้ไข DATABASE_URL ใน .env:**
- ตรวจสอบ username, password, และ database name
- ตรวจสอบว่า port 3306 ถูกต้อง

### 9.3 ปัญหา: Prisma generate error

**แก้ไข:**
```bash
# ลบ node_modules และ .prisma
cd apps/api
rm -rf node_modules .prisma

# ติดตั้งใหม่
pnpm install

# Generate อีกครั้ง
npx prisma generate
```

### 9.4 ปัญหา: Port already in use

**แก้ไข:**
```bash
# หา process ที่ใช้ port 3000 หรือ 3001
sudo lsof -i :3000
sudo lsof -i :3001

# Kill process (แทนที่ <PID> ด้วย process ID)
sudo kill -9 <PID>

# หรือเปลี่ยน port ใน .env
```

### 9.5 ปัญหา: Permission denied

**แก้ไข:**
```bash
# ให้สิทธิ์ execute
chmod +x scripts/*.sh

# หรือใช้ sudo (ไม่แนะนำ)
```

### 9.6 ปัญหา: Module not found

**แก้ไข:**
```bash
# ลบ node_modules ทั้งหมด
rm -rf node_modules apps/*/node_modules

# ติดตั้งใหม่
pnpm install
```

### 9.7 ปัญหา: Database migration failed

**แก้ไข:**
```bash
# Reset database (ระวัง: จะลบข้อมูลทั้งหมด)
cd apps/api
npx prisma migrate reset

# หรือ migrate ใหม่
npx prisma migrate dev
```

### 9.9 ปัญหา: Table names case sensitivity error

**อาการ**: Error เช่น `Table 'cremation_db.user' doesn't exist` หรือ `Table 'cremation_db.User' doesn't exist`

**แก้ไข:**

1. **ตรวจสอบ lower_case_table_names:**
```bash
mysql -u root -p -e "SHOW VARIABLES LIKE 'lower_case_table_names';"
```

2. **ถ้าเป็น 0 (case-sensitive):**
   - ตรวจสอบว่า table names ใน database ตรงกับที่ Prisma สร้าง (PascalCase)
   - หรือตั้งค่า `lower_case_table_names = 1` ใน MySQL config และ restart

3. **ตรวจสอบ DATABASE_URL:**
```bash
# Database name ต้องเป็น lowercase
DATABASE_URL="mysql://root:password@localhost:3306/cremation_db"
#                                                          ^^^^^^^^^^^ lowercase
```

4. **ตรวจสอบ tables ที่มีอยู่:**
```bash
mysql -u root -p cremation_db -e "SHOW TABLES;"
```

### 9.10 ปัญหา: Seed file error - Cannot find module

**แก้ไข:**
```bash
# ตรวจสอบว่า Prisma Client ถูก generate แล้ว
cd apps/api
npx prisma generate

# ตรวจสอบ path ของ seed file
ls -la prisma/seed.ts

# รัน seed ด้วย absolute path
npx ts-node --project tsconfig.json $(pwd)/prisma/seed.ts
```

### 9.11 ปัญหา: CORS error - Access blocked by CORS policy

**อาการ**: Error `Access to XMLHttpRequest ... has been blocked by CORS policy`

**แก้ไข:**

1. **ตรวจสอบ CORS configuration ใน .env:**
```bash
# ตรวจสอบ CORS_ORIGINS หรือ FRONTEND_URL
cat .env | grep CORS
cat .env | grep FRONTEND_URL
```

2. **ตั้งค่า CORS_ORIGINS ใน .env:**
```bash
# แก้ไข .env
nano .env

# เพิ่มหรือแก้ไข:
CORS_ORIGINS="http://localhost:3000,http://203.172.184.47:8889"
# หรือ
FRONTEND_URL="http://203.172.184.47:8889"
```

3. **Restart API server:**
```bash
# หยุด server (Ctrl+C) แล้วรันใหม่
cd apps/api
pnpm start:dev
```

4. **ตรวจสอบว่า CORS ถูกตั้งค่าถูกต้อง:**
   - ดู console log เมื่อ start API server
   - ควรเห็น: `📡 CORS enabled for origins: ...`

5. **สำหรับ Development (ไม่แนะนำสำหรับ production):**
```bash
# เพิ่มใน .env
ALLOW_ALL_ORIGINS=true
NODE_ENV=development
```

**หมายเหตุ**: 
- Frontend origin ต้องตรงกับที่ระบุใน `CORS_ORIGINS` หรือ `FRONTEND_URL`
- ตรวจสอบว่า frontend ใช้ URL ที่ถูกต้อง (ดูที่ `NEXT_PUBLIC_API_URL` ใน frontend .env)

### 9.8 ปัญหา: JWT_SECRET too short

**แก้ไข:**
- ตรวจสอบว่า JWT_SECRET ใน .env มีความยาวอย่างน้อย 32 ตัวอักษร
- สร้าง secret key ใหม่:
```bash
# สร้าง random secret key
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## 10. Production Setup (เพิ่มเติม)

### 10.1 Build สำหรับ Production

```bash
# Build API
pnpm build:api

# Build Web
pnpm build:web
```

### 10.2 Run Production

```bash
# API
cd apps/api
pnpm start:prod

# Web
cd apps/web
pnpm start
```

### 10.3 ใช้ PM2 สำหรับ Process Management

```bash
# ติดตั้ง PM2
npm install -g pm2

# Start API
cd apps/api
pm2 start dist/main.js --name "cremation-api"

# Start Web
cd apps/web
pm2 start .next/standalone/server.js --name "cremation-web"

# ดู status
pm2 status

# ตั้งค่าให้ start อัตโนมัติเมื่อ boot
pm2 startup
pm2 save
```

---

## 11. คำสั่งที่มีประโยชน์

### 11.1 Database Commands

```bash
# จาก root directory
pnpm db:generate    # Generate Prisma Client
pnpm db:migrate     # Run migrations
pnpm db:seed        # Seed data
pnpm db:studio      # Open Prisma Studio
```

### 11.2 Development Commands

```bash
pnpm dev            # Run both API and Web
pnpm dev:api        # Run API only
pnpm dev:web        # Run Web only
pnpm build          # Build both
pnpm lint           # Lint all projects
```

### 11.3 Clean Commands

```bash
pnpm clean          # Remove node_modules, dist, .next
```

---

## 12. ข้อมูลเพิ่มเติม

- **Documentation**: ดูที่ `README.md`
- **Project Structure**: ดูที่ `README.md` section "Project Structure"
- **API Endpoints**: ดูที่ `README.md` section "API Endpoints"
- **Domain Knowledge**: ดูที่ `context.md`
- **Project Plan**: ดูที่ `plan.md`

---

## 13. Support

หากพบปัญหาหรือต้องการความช่วยเหลือ:
1. ตรวจสอบ Troubleshooting section (ข้อ 9)
2. ตรวจสอบ logs ใน terminal
3. ตรวจสอบ browser console (F12)
4. ตรวจสอบ API logs

---

**อัปเดตล่าสุด**: 2025-01-XX
**เวอร์ชัน**: 1.0.0

