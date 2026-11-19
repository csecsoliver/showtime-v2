FROM openresty/openresty:bookworm-fat
LABEL maintainer="csecsoliver"

# Match the host user so files written into the bind-mounted source dir
# (compiled .lua, sqlite db, logs) are owned by you on the host.
ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
    luarocks build-essential pkg-config git \
    libargon2-dev libsqlite3-dev libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install cmake -y
# Only the rocks the app actually imports:
#   yuescript  - compile .yue sources
#   lapis      - framework (+ its pure-lua deps, resolved automatically)
#   lsqlite3   - lapis.db sqlite backend
#   argon2     - password verify (login)
#   luaossl    - openssl.rand (CSRF + login tokens)
RUN luarocks install yuescript \
 && luarocks install lapis \
 && luarocks install lsqlite3 \
 && luarocks install argon2 \
 && luarocks install luaossl

RUN groupadd -g ${GID} app \
 && useradd -m -u ${UID} -g ${GID} -s /bin/sh app \
 && mkdir -p /app \
 && chown -R app:app /app /usr/local/openresty/nginx

USER app
WORKDIR /app
EXPOSE 8080
CMD sh -c "yue -c . && lapis migrate && (yue -w . &) && lapis server"
