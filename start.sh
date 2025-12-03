#!/usr/bin/env bash
set -eEuo pipefail

>&2 echo 'Starting tailscale daemon'
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
>&2 echo 'Starting tailscale'
tailscale up --auth-key="$TAILSCALE_AUTHKEY" --hostname=mosquitto --advertise-tags=tag:mqtt-broker

>&2 echo 'Starting mosquitto'
set -o monitor
mosquitto "$@" &
tailscale serve --service=svc:mqtt-broker 1883
fg
