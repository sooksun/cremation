#!/bin/sh
# ============================================================
# ส่ง backup ออกนอกเครื่อง (off-host) — เข้ารหัสด้วย gpg แล้วอัปโหลดผ่าน rclone
#
# รันบน "host" ไม่ใช่ใน container เพราะ image mariadb:11 ไม่มี rclone
# ตั้งค่าใน .env.offsite (ไม่ commit ลง git — ดู SETUP_UBUNTU.md)
#
#   /DATA/AppData/www/cremation/backup/offsite.sh
# ============================================================
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
CONF="${ROOT_DIR}/.env.offsite"

if [ ! -f "${CONF}" ]; then
  echo "[offsite] FAILED: ไม่พบ ${CONF} — ยังไม่ได้ตั้งค่า off-host backup" >&2
  exit 1
fi
# shellcheck disable=SC1090
. "${CONF}"

: "${OFFSITE_REMOTE:?[offsite] OFFSITE_REMOTE ไม่ได้ตั้งค่าใน .env.offsite}"
: "${OFFSITE_PASSPHRASE_FILE:?[offsite] OFFSITE_PASSPHRASE_FILE ไม่ได้ตั้งค่าใน .env.offsite}"
RETAIN_DAYS="${OFFSITE_RETAIN_DAYS:-90}"

if [ ! -s "${OFFSITE_PASSPHRASE_FILE}" ]; then
  echo "[offsite] FAILED: ไม่พบ passphrase ที่ ${OFFSITE_PASSPHRASE_FILE} (หรือไฟล์ว่าง)" >&2
  exit 1
fi

SRC_DIR="${ROOT_DIR}/backup"
STAGE_DIR="${SRC_DIR}/.encrypted"
mkdir -p "${STAGE_DIR}"
chmod 700 "${STAGE_DIR}"

# rclone ต้องรู้จัก remote ก่อน ไม่งั้นจะ upload ไปที่ไหนก็ไม่รู้
REMOTE_NAME="${OFFSITE_REMOTE%%:*}"
if ! rclone listremotes 2>/dev/null | grep -qx "${REMOTE_NAME}:"; then
  echo "[offsite] FAILED: rclone ยังไม่มี remote ชื่อ '${REMOTE_NAME}' — รัน 'rclone config' ก่อน" >&2
  exit 1
fi

echo "[offsite] encrypting new dumps -> ${STAGE_DIR}"
encrypted=0
for f in "${SRC_DIR}"/cremation_*.sql.gz; do
  [ -e "$f" ] || continue
  base="$(basename "$f")"
  out="${STAGE_DIR}/${base}.gpg"
  [ -f "$out" ] && continue

  tmp="${out}.partial"
  if ! gpg --batch --yes --quiet \
        --symmetric --cipher-algo AES256 \
        --passphrase-file "${OFFSITE_PASSPHRASE_FILE}" \
        --output "$tmp" "$f"; then
    rm -f "$tmp"
    echo "[offsite] FAILED: เข้ารหัส ${base} ไม่สำเร็จ" >&2
    exit 1
  fi
  mv "$tmp" "$out"
  encrypted=$((encrypted + 1))
done
echo "[offsite] encrypted ${encrypted} new file(s)"

# copy (ไม่ใช่ sync) — ไฟล์ที่อัปแล้วจะถูกข้าม และรอบที่แล้วที่ล้มจะถูกลองใหม่เอง
echo "[offsite] uploading -> ${OFFSITE_REMOTE}"
if ! rclone copy "${STAGE_DIR}" "${OFFSITE_REMOTE}" \
      --include '*.sql.gz.gpg' --transfers 2 --retries 3 --stats-one-line; then
  echo "[offsite] FAILED: อัปโหลดขึ้น ${OFFSITE_REMOTE} ไม่สำเร็จ" >&2
  exit 1
fi

# ยืนยันว่าไฟล์ล่าสุดขึ้นไปจริง ไม่ใช่แค่ rclone คืน exit 0
NEWEST="$(ls -1t "${STAGE_DIR}"/*.sql.gz.gpg 2>/dev/null | head -1 || true)"
if [ -n "${NEWEST}" ]; then
  NEWEST_BASE="$(basename "${NEWEST}")"
  if ! rclone lsf "${OFFSITE_REMOTE}" 2>/dev/null | grep -qx "${NEWEST_BASE}"; then
    echo "[offsite] FAILED: ไม่พบ ${NEWEST_BASE} บนปลายทางหลังอัปโหลด" >&2
    exit 1
  fi
  echo "[offsite] verified on remote: ${NEWEST_BASE}"
fi

# ล้างของเก่าหลังอัปสำเร็จแล้วเท่านั้น
rclone delete "${OFFSITE_REMOTE}" --min-age "${RETAIN_DAYS}d" --include '*.sql.gz.gpg' 2>/dev/null || true
find "${STAGE_DIR}" -name '*.sql.gz.gpg' -type f -mtime +"${RETAIN_DAYS}" -delete
find "${STAGE_DIR}" -name '*.partial' -type f -mtime +1 -delete

REMOTE_COUNT="$(rclone lsf "${OFFSITE_REMOTE}" 2>/dev/null | grep -c '\.sql\.gz\.gpg$' || true)"
echo "[offsite] done: ${REMOTE_COUNT} file(s) on ${OFFSITE_REMOTE}, retained ${RETAIN_DAYS} days"
