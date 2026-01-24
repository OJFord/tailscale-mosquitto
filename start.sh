#!/usr/bin/env bash
set -eEuo pipefail

>&2 echo 'Starting tailscale'
set -o monitor
containerboot &

>&2 echo "Starting '$@'"
su -s /bin/sh mosquitto -c "$1" -- "${@:1}" &

wait -n
