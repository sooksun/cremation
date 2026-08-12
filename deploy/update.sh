#!/usr/bin/env bash
# ============================================================
# อัปเดตเวอร์ชันบน server ด้วย git pull (ไม่ seed ใหม่)
# migration รัน auto ตอน api boot
#
#   cd /DATA/AppData/www/cremation
#   bash deploy/update.sh
#
# ปรับ branch ได้:  DEPLOY_BRANCH=main bash deploy/update.sh
# ============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

DEPLOY_BRANCH="${DEPLOY_BRANCH:-main}"
COMPOSE="docker compose -f docker-compose.prod.yml --env-file .env.production"

if [ ! -d .git ]; then
  echo "ERROR: ที่นี่ไม่ใช่ git repo — ต้อง clone ก่อน (ดู SETUP_UBUNTU.md หัวข้อ 0)" >&2
  exit 1
fi
if [ ! -f .env.production ]; then
  echo "ERROR: ไม่พบ .env.production" >&2
  exit 1
fi

echo "==> git fetch + pull (branch: ${DEPLOY_BRANCH})"
git fetch origin "${DEPLOY_BRANCH}"
git checkout "${DEPLOY_BRANCH}"
git pull --ff-only origin "${DEPLOY_BRANCH}"

echo "==> rebuild api + web"
$COMPOSE build api web

echo "==> restart (api รัน 'prisma migrate deploy' ตอน boot)"
# backup ต้อง recreate ด้วย ไม่งั้นจะค้าง env เก่า (เช่น DATABASE_URL ที่เปลี่ยนรหัสผ่านแล้ว)
# จน dump ไม่ผ่านเงียบ ๆ
$COMPOSE up -d --force-recreate --no-deps api web backup

echo "==> สถานะ"
$COMPOSE ps
echo "เสร็จ. — http://192.168.1.4:9950"
