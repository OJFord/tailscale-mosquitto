# Can't just use COPY --from=, dependabot won't update it
# https://github.com/dependabot/dependabot-core/issues/6700
FROM docker.io/library/eclipse-mosquitto:2.0.22 AS mosquitto
FROM ghcr.io/tailscale/tailscale:v1.92.5

RUN apk update && apk add bash && rm -rf /var/cache/apk/*
COPY start.sh /app/
ENTRYPOINT ["/app/start.sh"]

ENV TS_SERVE_CONFIG=/app/ts-serve.json
COPY ts-serve.json "$TS_SERVE_CONFIG"

RUN addgroup -S -g 1883 mosquitto && adduser -S -u 1883 -D -H -h /var/empty -s /sbin/nologin -G mosquitto -g mosquitto mosquitto
COPY --from=mosquitto /usr/sbin/mosquitto /usr/sbin/
COPY --chown=mosquitto mosquitto.conf /app/
COPY --chown=mosquitto users.txt /app/
CMD ["mosquitto", "-c", "/app/mosquitto.conf"]
