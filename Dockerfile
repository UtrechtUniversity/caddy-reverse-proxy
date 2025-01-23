FROM caddy:2-alpine

ENV HTTP_LISTEN_PORT=80
ENV HTTPS_LISTEN_PORT=443

ENV LISTEN_PORT=80
ENV SERVICE_PORT=5000
ENV BASIC_USER=caddy
ENV BASIC_PW=""
ENV MATCHER=""
ENV HASH_ALGO=bcrypt
ENV REALM=""

COPY Caddyfile /etc/caddy/Caddyfile
