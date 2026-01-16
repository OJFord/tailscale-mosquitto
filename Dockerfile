FROM docker.io/library/eclipse-mosquitto:2.0.21

RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*
COPY --from=ghcr.io/tailscale/tailscale:v1.92.4 /usr/local/bin/tailscale /usr/local/bin/
COPY --from=ghcr.io/tailscale/tailscale:v1.92.4 /usr/local/bin/tailscaled /usr/local/bin/
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apk update && apk add bash && rm -rf /var/cache/apk/*
COPY start.sh /app/start.sh
ENTRYPOINT ["/app/start.sh"]

COPY mosquitto.conf /app/mosquitto.conf
COPY --chown=mosquitto users.txt /app/users.txt
CMD ["-c", "/app/mosquitto.conf"]
