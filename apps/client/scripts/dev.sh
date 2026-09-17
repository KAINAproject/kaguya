#!/bin/sh

set -eu

if ! command -v zenoh-bridge-remote-api >/dev/null 2>&1; then
  echo "zenoh-bridge-remote-api が PATH にありません。direnv または nix develop で devShell に入ってください。" >&2
  exit 127
fi

zenoh-bridge-remote-api \
  --mode "${ZENOH_BRIDGE_MODE:-peer}" \
  --listen "${ZENOH_BRIDGE_LISTEN:-tcp/0.0.0.0:7447}" \
  --ws-port "${ZENOH_BRIDGE_WS_PORT:-0.0.0.0:10000}" &
bridge_pid=$!

cleanup() {
  trap - EXIT INT TERM
  kill "$bridge_pid" 2>/dev/null || true
  wait "$bridge_pid" 2>/dev/null || true
}

trap cleanup EXIT INT TERM

vite --host &
vite_pid=$!
vite_status=0
wait "$vite_pid" || vite_status=$?
exit "$vite_status"
