FROM caddy:2-alpine

ENV LISTEN_PORT=80
ENV SERVICE_PORT=5000
ENV BASIC_USER=caddy
ENV BASIC_PW=""
ENV MATCHER=""
ENV HASH_ALGO=bcrypt
ENV REALM=""
RUN setcap -r /usr/bin/caddy
RUN apk add --update --no-cache curl && rm -rf /var/cache/apk/*
COPY Caddyfile /etc/caddy/Caddyfile
