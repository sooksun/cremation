#!/bin/sh
set -eu

if [ -z "${DATABASE_URL:-}" ]; then
  echo "[backup] DATABASE_URL is not set" >&2
  exit 1
fi

RETAIN_DAYS="${BACKUP_RETAIN_DAYS:-14}"
OUT_DIR="/backup"
STAMP="$(date +%Y%m%d_%H%M%S)"
OUT_FILE="${OUT_DIR}/cremation_${STAMP}.sql.gz"

url="${DATABASE_URL#mysql://}"
userpass="${url%%@*}"
remainder="${url#*@}"
DB_USER="${userpass%%:*}"
DB_PASS="${userpass#*:}"
hostpart="${remainder%%/*}"
DB_NAME="${remainder#*/}"
DB_NAME="${DB_NAME%%\?*}"

if echo "$hostpart" | grep -q ':'; then
  DB_HOST="${hostpart%%:*}"
  DB_PORT="${hostpart#*:}"
else
  DB_HOST="$hostpart"
  DB_PORT=3306
fi

mkdir -p "${OUT_DIR}"

echo "[backup] dumping ${DB_NAME}@${DB_HOST}:${DB_PORT} -> ${OUT_FILE}"
MYSQL_PWD="${DB_PASS}" mariadb-dump \
  -h "${DB_HOST}" \
  -P "${DB_PORT}" \
  -u "${DB_USER}" \
  --single-transaction \
  --routines \
  --triggers \
  "${DB_NAME}" | gzip -9 > "${OUT_FILE}"

find "${OUT_DIR}" -name 'cremation_*.sql.gz' -type f -mtime +"${RETAIN_DAYS}" -delete
echo "[backup] done, retained ${RETAIN_DAYS} days"