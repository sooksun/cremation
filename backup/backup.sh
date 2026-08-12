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

TMP_FILE="${OUT_DIR}/.in-progress_${STAMP}.sql"
cleanup() { rm -f "${TMP_FILE}"; }
trap cleanup EXIT

echo "[backup] dumping ${DB_NAME}@${DB_HOST}:${DB_PORT} -> ${OUT_FILE}"

# Dump to a temp file rather than straight down a pipe into gzip: in a pipeline the
# shell only sees gzip's exit status, so a failed dump used to leave a valid but empty
# 20-byte .gz behind and still report success.
if ! MYSQL_PWD="${DB_PASS}" mariadb-dump \
  -h "${DB_HOST}" \
  -P "${DB_PORT}" \
  -u "${DB_USER}" \
  --single-transaction \
  --routines \
  --triggers \
  "${DB_NAME}" > "${TMP_FILE}"; then
  echo "[backup] FAILED: mariadb-dump could not dump ${DB_NAME}@${DB_HOST}:${DB_PORT}" >&2
  exit 1
fi

# A dump with no CREATE TABLE is not a backup, whatever its size.
if ! grep -q '^CREATE TABLE' "${TMP_FILE}"; then
  echo "[backup] FAILED: dump contains no tables — refusing to keep it" >&2
  exit 1
fi

TABLE_COUNT="$(grep -c '^CREATE TABLE' "${TMP_FILE}")"

gzip -9 -c "${TMP_FILE}" > "${OUT_FILE}"

# Only prune old backups once a good one is on disk, so a broken run cannot
# age out the last working backup.
find "${OUT_DIR}" -name 'cremation_*.sql.gz' -type f -mtime +"${RETAIN_DAYS}" -delete
echo "[backup] done: ${OUT_FILE} ($(du -h "${OUT_FILE}" | cut -f1), ${TABLE_COUNT} tables), retained ${RETAIN_DAYS} days"