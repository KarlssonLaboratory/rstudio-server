#!/usr/bin/env bash
set -euo pipefail

PORT="${RSTUDIO_PORT:-8787}"
ADDRESS="${RSTUDIO_ADDRESS:-0.0.0.0}"

if [ "$(id -u)" -eq 0 ]; then
  # --- Docker path: running as root, use rocker's built-in init ---
  # rocker/rstudio ships /init which sets up the rstudio user and launches rserver.
  # Honor a password if provided, otherwise disable auth (only safe behind a tunnel).
  export PASSWORD="${PASSWORD:-}"
  if [ -z "$PASSWORD" ]; then
    export DISABLE_AUTH=true
  fi
  exec /init

else
  # --- Apptainer path: rootless, everything must live under $HOME ---
  USER_NAME="$(id -un)"
  USER_ID="$(id -u)"
  WORKDIR="${RSTUDIO_TMPDIR:-$HOME/.rstudio-server-run}"
  mkdir -p "$WORKDIR"/{run,lib,log,tmp}

  COOKIE_KEY="$WORKDIR/secure-cookie-key"
  if [ ! -s "$COOKIE_KEY" ]; then
    uuidgen > "$COOKIE_KEY"
    chmod 0600 "$COOKIE_KEY"
  fi

  cat > "$WORKDIR/database.conf" <<EOF
provider=sqlite
directory=$WORKDIR/lib
EOF

  cat > "$WORKDIR/rserver.conf" <<EOF
www-port=$PORT
www-address=$ADDRESS
www-verify-user-agent=0
auth-none=1
auth-minimum-user-id=$USER_ID
server-user=$USER_NAME
server-data-dir=$WORKDIR/run
secure-cookie-key-file=$COOKIE_KEY
database-config-file=$WORKDIR/database.conf
server-daemonize=0
EOF

  exec /usr/lib/rstudio-server/bin/rserver --config-file="$WORKDIR/rserver.conf"
fi
