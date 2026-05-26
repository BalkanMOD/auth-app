#!/usr/bin/env bash
set -e

if [ "$#" -ne 3 ]; then
  cat <<EOF
Usage: $0 <server-ip> <email> <password>

Example:
  ./termux-quickstart.sh 10.0.2.2 user@example.com secret
EOF
  exit 1
fi

SERVER_IP="$1"
EMAIL="$2"
PASSWORD="$3"
TARGET_FILE="termux-auth.sh"
SCRIPT_URL="https://raw.githubusercontent.com/BalkanMOD/auth-app/master/termux-auth.sh"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SCRIPT_URL" -o "$TARGET_FILE"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$TARGET_FILE" "$SCRIPT_URL"
else
  echo "Error: curl or wget is required to download the helper script." >&2
  exit 1
fi

chmod +x "$TARGET_FILE"

echo "Installed $TARGET_FILE"
export TERMUX_SERVER_URL="http://$SERVER_IP:4000"

echo "Registering user $EMAIL..."
./"$TARGET_FILE" register "$EMAIL" "$PASSWORD"

echo "Logging in user $EMAIL..."
./"$TARGET_FILE" login "$EMAIL" "$PASSWORD"

echo "Quickstart complete. Use the returned token with:"
echo "  ./termux-auth.sh profile <token>"
