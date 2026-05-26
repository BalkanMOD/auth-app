#!/usr/bin/env bash
set -e

TARGET_FILE="termux-auth.sh"
SCRIPT_URLS=(
  "https://raw.githubusercontent.com/BALKANMOD/auth-app/master/termux-auth.sh"
  "https://raw.githubusercontent.com/BALKANMOD/auth-app/main/termux-auth.sh"
)

if command -v curl >/dev/null 2>&1; then
  for SCRIPT_URL in "${SCRIPT_URLS[@]}"; do
    if curl -fsSL "$SCRIPT_URL" -o "$TARGET_FILE"; then
      break
    fi
  done
elif command -v wget >/dev/null 2>&1; then
  for SCRIPT_URL in "${SCRIPT_URLS[@]}"; do
    if wget -qO "$TARGET_FILE" "$SCRIPT_URL"; then
      break
    fi
  done
else
  echo "Error: curl or wget is required to download the installer script." >&2
  exit 1
fi

chmod +x "$TARGET_FILE"
echo "Installed $TARGET_FILE"
echo "Run: TERMUX_SERVER_URL=http://<server-ip>:4000 ./termux-auth.sh"

