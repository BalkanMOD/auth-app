#!/usr/bin/env bash

# Usage:
#   ./termux-auth.sh register user@example.com secret
#   ./termux-auth.sh login user@example.com secret
#   ./termux-auth.sh profile <token>

SERVER_URL="http://<server-ip>:4000"

if [ -n "$TERMUX_SERVER_URL" ]; then
  SERVER_URL="$TERMUX_SERVER_URL"
fi

function usage() {
  cat <<EOF
Usage:
  TERMUX_SERVER_URL=http://<server-ip>:4000 ./termux-auth.sh register <email> <password>
  TERMUX_SERVER_URL=http://<server-ip>:4000 ./termux-auth.sh login <email> <password>
  TERMUX_SERVER_URL=http://<server-ip>:4000 ./termux-auth.sh profile <token>

Set SERVER_URL in the script or via TERMUX_SERVER_URL environment variable.
EOF
  exit 1
}

function register_user() {
  local email="$1"
  local password="$2"

  curl -s -X POST "$SERVER_URL/register" \
    -H "Content-Type: application/json" \
    -d "{\"email\": \"$email\", \"password\": \"$password\"}"
  echo
}

function login_user() {
  local email="$1"
  local password="$2"

  curl -s -X POST "$SERVER_URL/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\": \"$email\", \"password\": \"$password\"}"
  echo
}

function get_profile() {
  local token="$1"

  curl -s -X GET "$SERVER_URL/profile" \
    -H "Authorization: Bearer $token"
  echo
}

if [ "$#" -lt 1 ]; then
  usage
fi

command="$1"
shift

case "$command" in
  register)
    [ "$#" -eq 2 ] || usage
    register_user "$1" "$2"
    ;;
  login)
    [ "$#" -eq 2 ] || usage
    login_user "$1" "$2"
    ;;
  profile)
    [ "$#" -eq 1 ] || usage
    get_profile "$1"
    ;;
  *)
    usage
    ;;
 esac
