# ชุดติดตั้ง Docker — Cremation Welfare System (server 192.168.1.4)

วันที่: 2026-07-13
สถานะ: อนุมัติแล้ว (design approved)

## เป้าหมาย

Deploy ระบบด้วย Docker บน Ubuntu server ที่ path `/DATA/AppData/www/cremation`
เข้าถึงหน้าเว็บที่ `http://192.168.1.4:9950` โดย build image บน server จาก source.

## การตัดสินใจ (ยืนยันกับผู้ใช้)

1. **2 port แยก** — `web` = 9950, `api` = 9951 (browser เรียก api ตรงที่ `192.168.1.4:9951/api`)
2. **External MariaDB** — ใช้ MariaDB ที่รันอยู่บน host แล้ว (`host.docker.internal:3306`),
   database `cremation_db`, user เฉพาะ `cremation_app` (ไม่ใช้ root)
3. **Build บน server** — git clone/rsync source → `docker compose build` บนเครื่องปลายทาง

## สถาปัตยกรรม

| Service  | Host port | เข้าถึง                        | หมายเหตุ                                   |
|----------|-----------|-------------------------------|-------------------------------------------|
| `web`    | 9950:3000 | `http://192.168.1.4:9950`     | Next.js standalone (จุดเข้าหลัก)          |
| `api`    | 9951:4000 | `http://192.168.1.4:9951/api` | NestJS + Prisma, global prefix `/api`     |
| `backup` | —         | —                             | mariadb-dump รายวัน → `./backup` เก็บ 14 วัน |
| `seed`   | —         | —                             | รันครั้งเดียวตอนติดตั้ง (profile `seed`)   |

ทุก service อยู่บน bridge network `cremation-net` + `extra_hosts: host.docker.internal:host-gateway`
เพื่อให้ container ต่อ MariaDB บน host ได้.

## ค่าคอนฟิกสำคัญ

- `NEXT_PUBLIC_API_URL=http://192.168.1.4:9951/api` — **bake ตอน build** ผ่าน compose build arg
  (ถ้า IP/port เปลี่ยน ต้อง rebuild web)
- `CORS_ORIGINS=http://192.168.1.4:9950` (map จาก `WEB_ORIGIN`) — api อนุญาต browser จาก web origin
  (`credentials:true` + custom origin callback มีอยู่แล้วใน `main.ts`)
- `DATABASE_URL=mysql://cremation_app:<pass>@host.docker.internal:3306/cremation_db`
  — ค่าจริงอยู่ใน `.env.production` (gitignored) เท่านั้น

## Migration & Seed

- **Migration**: `prisma migrate deploy` รัน auto ตอน api boot (อยู่ใน `Dockerfile.api` CMD แล้ว)
- **Seed** (ครั้งแรกเท่านั้น): `docker compose --profile seed run --rm seed`
  ใช้ **builder stage** ของ `Dockerfile.api` (มี source ครบ + ts-node) เพราะ `prisma/seed.ts`
  import จาก `../src/...` (TS source) ซึ่งไม่มีใน prod bundle → รันใน prod image ไม่ได้

## ไฟล์ที่แก้/เพิ่ม

1. `docker-compose.prod.yml` — port 9950/9951, build arg `NEXT_PUBLIC_API_URL`, service `seed`
2. `.env.production.example` — ค่าเฉพาะ 192.168.1.4 + `cremation_db` + user `cremation_app`
3. `deploy/install.sh` — ติดตั้งครั้งแรก (build → up → seed)
4. `deploy/update.sh` — อัปเดต (pull → build → up, migrate auto)
5. `deploy/mariadb-setup.sql` — สร้าง DB + user + grant
6. `SETUP_UBUNTU.md` — เพิ่มหัวข้อ "Docker Deploy" ขั้นตอนตามลำดับ

## ขั้นตอน deploy บน server

1. เตรียม MariaDB: รัน `deploy/mariadb-setup.sql` (สร้าง `cremation_db` + `cremation_app` + grant จาก docker subnet)
2. clone/rsync source → `/DATA/AppData/www/cremation`
3. `cp .env.production.example .env.production` → เติม `DATABASE_URL` (รหัสจริง), `JWT_SECRET`
4. `bash deploy/install.sh` (build → up → migrate auto → seed)
5. เปิด `http://192.168.1.4:9950` (login admin จาก seed แล้วเปลี่ยนรหัสทันที)

## ข้อควรระวัง

- ทั้งสอง origin เป็น http (ไม่มี TLS) บน LAN — ไม่มี mixed-content เพราะ web/api เป็น http ทั้งคู่
- MariaDB ต้อง bind `0.0.0.0:3306` และ grant `cremation_app` ให้ต่อจาก docker bridge subnet
  (`172.16.0.0/12` หรือ `%`) ได้ — ไม่งั้น container ต่อไม่ติด
- port 9950/9951 เปิดเฉพาะ LAN — ห้าม forward ออก public ที่ router
- `.env.production` ต้อง gitignored (ตรวจ `git check-ignore .env.production`)

## อัปเดต (2026-07-13): วิธีส่งมอบ = git-pull

เปลี่ยนจาก tarball → **deploy ด้วย git clone/pull จาก branch `main` ผ่าน SSH deploy key**:
- server clone: `git clone -b main git@github.com:sooksun/cremation.git /DATA/AppData/www/cremation`
- อัปเดต: `deploy/update.sh` = `git fetch/pull --ff-only origin main` → rebuild → restart (migrate auto)
- SSH deploy key (read-only) เพิ่มที่ GitHub → Settings → Deploy keys (ทำผ่านหน้าเว็บ)
- ต้อง merge งานเข้า `main` + push origin/main ก่อน (main fast-forward ได้จาก branch นี้)
- ขั้นตอนเต็มอยู่ใน `SETUP_UBUNTU.md` หัวข้อ 0.1–0.2
