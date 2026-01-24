# Can't just use COPY --from=, dependabot won't update it
# https://github.com/dependabot/dependabot-core/issues/6700
FROM ghcr.io/tailscale/tailscale:v1.92.5 AS tailscale
FROM docker.io/library/eclipse-mosquitto:2.0.22

RUN apk update && apk add ca-certificates iptables-legacy  && rm -rf /var/cache/apk/*
COPY --from=tailscale /usr/local/bin/containerboot /usr/local/bin/
COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apk update && apk add bash && rm -rf /var/cache/apk/*
COPY start.sh /app/start.sh
ENTRYPOINT ["/app/start.sh"]

ENV TS_SERVE_CONFIG=/app/ts-serve.json
COPY ts-serve.json "$TS_SERVE_CONFIG"

COPY mosquitto.conf /app/mosquitto.conf
COPY --chown=mosquitto users.txt /app/users.txt
CMD ["-c", "/app/mosquitto.conf"]
