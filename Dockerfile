FROM docker.io/library/eclipse-mosquitto

RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apk update && apk add bash && rm -rf /var/cache/apk/*
COPY start.sh /app/start.sh
ENTRYPOINT ["/app/start.sh"]
COPY mosquitto.conf /app/mosquitto.conf
CMD ["--config=/app/mosquitto.conf"]
