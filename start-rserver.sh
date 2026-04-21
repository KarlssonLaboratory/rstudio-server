#!/usr/bin/env bash
set -euo pipefail

PORT="${RSTUDIO_PORT:-8080}"
ADDRESS="${RSTUDIO_ADDRESS:-0.0.0.0}"
USER_NAME="$(id -un)"
WORKDIR="${RSTUDIO_TMPDIR:-$HOME/.rstudio-server-run}"

mkdir -p "$WORKDIR"/{run,lib,log,tmp}

# Generate a password if not supplied
if [ -z "${PASSWORD:-}" ]; then
  PASSWORD=$(openssl rand -base64 15)
  echo "=================================================="
  echo "RStudio login:"
  echo "  User:     $USER_NAME"
  echo "  Password: $PASSWORD"
  echo "=================================================="
fi
export PASSWORD

# rserver wants this in a .conf file too
cat > "$WORKDIR/database.conf" <<EOF
provider=sqlite
directory=$WORKDIR/lib
EOF

exec /usr/lib/rstudio-server/bin/rserver \
  --www-port="$PORT" \
  --www-address="$ADDRESS" \
  --www-verify-user-agent=0 \
  --auth-none=0 \
  --auth-pam-helper-path=pam-helper \
  --auth-stay-signed-in-days=30 \
  --auth-timeout-minutes=0 \
  --server-user="$USER_NAME" \
  --server-data-dir="$WORKDIR/run" \
  --database-config-file="$WORKDIR/database.conf" \
  --secure-cookie-key-file="$WORKDIR/secure-cookie-key" \
  --server-daemonize=0