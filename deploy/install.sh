#!/usr/bin/env bash
# ============================================================
# ติดตั้งครั้งแรกบน Ubuntu server (git-based deploy)
# path: /DATA/AppData/www/cremation
# เข้าถึง: http://192.168.1.4:9950
#
# bootstrap (ครั้งแรก, ทำเองก่อน):
#   git clone -b main git@github.com:sooksun/cremation.git /DATA/AppData/www/cremation
#   cd /DATA/AppData/www/cremation
#
# แล้วก่อนรันสคริปต์นี้:
#   1) เตรียม DB บน host MariaDB:  mysql -u root -p < deploy/mariadb-setup.sql
#   2) cp .env.production.example .env.production  แล้วเติมค่า DATABASE_URL, JWT_SECRET
#   3) bash deploy/install.sh
#
# อัปเดตภายหลัง:  bash deploy/update.sh   (git pull main → rebuild → restart)
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

COMPOSE="docker compose -f docker-compose.prod.yml --env-file .env.production"

if [ ! -f .env.production ]; then
  echo "ERROR: ไม่พบ .env.production" >&2
  echo "  cp .env.production.example .env.production && \${EDITOR:-nano} .env.production" >&2
  exit 1
fi

echo "==> [1/4] build images (web จะ bake NEXT_PUBLIC_API_URL ตอนนี้)"
$COMPOSE build

echo "==> [2/4] start api + web + backup (api รัน 'prisma migrate deploy' ตอน boot)"
$COMPOSE up -d api web backup

echo "==> [3/4] รอ api ทำ migrate ให้เสร็จ"
sleep 12
$COMPOSE ps

echo "==> [4/4] seed ข้อมูลตั้งต้น (idempotent — รันซ้ำได้ปลอดภัย)"
$COMPOSE --profile seed run --rm seed

echo
echo "=========================================================="
echo " ติดตั้งเสร็จ — เปิด: http://192.168.1.4:9950"
echo " login admin จาก seed แล้วเปลี่ยนรหัสทันที"
echo "=========================================================="
