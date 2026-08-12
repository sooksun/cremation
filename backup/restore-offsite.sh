#!/bin/sh
# ============================================================
# ดึง backup จากปลายทาง off-host กลับมาถอดรหัส (ไม่ import เข้า DB ให้)
#
#   backup/restore-offsite.sh                 # ดึงไฟล์ล่าสุด
#   backup/restore-offsite.sh <ชื่อไฟล์.gpg>   # ดึงไฟล์ที่ระบุ
#   backup/restore-offsite.sh --list          # ดูรายการบนปลายทาง
#
# ได้ไฟล์ .sql ออกมาใน backup/restored/ แล้วค่อยตรวจก่อน import เอง:
#   docker exec -i mariadb mariadb -uroot -p<pw> cremation_db < <ไฟล์.sql>
# ============================================================
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
CONF="${ROOT_DIR}/.env.offsite"

[ -f "${CONF}" ] || { echo "[restore] ไม่พบ ${CONF}" >&2; exit 1; }
# shellcheck disable=SC1090
. "${CONF}"
: "${OFFSITE_REMOTE:?[restore] OFFSITE_REMOTE ไม่ได้ตั้งค่า}"
: "${OFFSITE_PASSPHRASE_FILE:?[restore] OFFSITE_PASSPHRASE_FILE ไม่ได้ตั้งค่า}"

if [ "${1:-}" = "--list" ]; then
  rclone lsl "${OFFSITE_REMOTE}" --include '*.sql.gz.gpg'
  exit 0
fi

TARGET="${1:-}"
if [ -z "${TARGET}" ]; then
  TARGET="$(rclone lsf "${OFFSITE_REMOTE}" --include '*.sql.gz.gpg' 2>/dev/null | sort | tail -1)"
  [ -n "${TARGET}" ] || { echo "[restore] ไม่มีไฟล์บน ${OFFSITE_REMOTE}" >&2; exit 1; }
  echo "[restore] ใช้ไฟล์ล่าสุด: ${TARGET}"
fi

OUT_DIR="${ROOT_DIR}/backup/restored"
mkdir -p "${OUT_DIR}"
chmod 700 "${OUT_DIR}"

echo "[restore] downloading ${TARGET}"
rclone copyto "${OFFSITE_REMOTE}/${TARGET}" "${OUT_DIR}/${TARGET}" --retries 3

SQL_OUT="${OUT_DIR}/$(basename "${TARGET}" .sql.gz.gpg).sql"
echo "[restore] decrypting -> ${SQL_OUT}"
gpg --batch --yes --quiet --decrypt \
  --passphrase-file "${OFFSITE_PASSPHRASE_FILE}" \
  "${OUT_DIR}/${TARGET}" | gzip -dc > "${SQL_OUT}"

if ! grep -q '^CREATE TABLE' "${SQL_OUT}"; then
  echo "[restore] FAILED: ไฟล์ที่ได้ไม่มี CREATE TABLE — backup อาจเสีย" >&2
  exit 1
fi

echo "[restore] ok: ${SQL_OUT} ($(du -h "${SQL_OUT}" | cut -f1), $(grep -c '^CREATE TABLE' "${SQL_OUT}") tables)"
echo "[restore] ตรวจไฟล์ก่อน แล้วค่อย import เข้า DB เอง"
