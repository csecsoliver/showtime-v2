FROM openresty/openresty:bookworm-fat
LABEL maintainer="csecsoliver"
RUN apt-get update && apt-get install -y luarocks build-essential cmake git unzip uuid-dev libmagickwand-dev libcurl4-openssl-dev libargon2-dev libsqlite3-dev libssl-dev liblua5.1.0-dev pkg-config

RUN luarocks install luasec
RUN luarocks install yuescript
RUN luarocks install lapis
RUN luarocks install moonscript
RUN luarocks install markdown
RUN luarocks install lsqlite3
RUN luarocks install bcrypt
RUN luarocks install lua-uuid
RUN luarocks install luafilesystem
RUN luarocks install magick
RUN luarocks install lume
RUN luarocks install argon2
RUN luarocks install sendmail
RUN luarocks install Lua-curl CURL_INCDIR=/usr/include/x86_64-linux-gnu
RUN luarocks install json-lua
WORKDIR /app
EXPOSE 8080
CMD sh -c "yue -c . && (yue -w . &) && lapis server"
