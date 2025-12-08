sudo apt-get -y install --no-install-recommends wget gnupg ca-certificates lsb-release
wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null
sudo apt-get update
sudo apt-get install openresty uuid-dev libmagickwand-dev luarocks libcurl4-openssl-dev libargon2-dev libssl-dev libsqlite3-dev -y

sudo luarocks install lapis moonscript markdown lsqlite3 bcrypt lua-uuid luafilesystem magick lume argon2 sendmail luasec
sudo env CURL_INCDIR=/usr/include/x86_64-linux-gnu luarocks install Lua-curl
moonc .
lapis migrate