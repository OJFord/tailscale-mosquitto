#!/usr/bin/env bash
set -eEuo pipefail

>&2 echo 'Starting tailscale'
set -o monitor
containerboot &

>&2 echo 'Starting mosquitto'
mosquitto "$@"
