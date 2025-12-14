{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "lapis-env";

  # Dependencies
  buildInputs = with pkgs; [
    openresty
    libuuid
    libargon2
    openssl
    openssl.dev
    sqlite
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.moonscript
    lua51Packages.markdown
    lua51Packages.luafilesystem
    lua51Packages.lua-curl
    lua51Packages.luaossl
  ];

  # Environment Variables
  shellHook = ''
    export PATH="$HOME/.luarocks/bin:$PATH"
    eval "$(luarocks path --bin)"
    mkdir -p logs
    export LAPIS_OPENRESTY=$(which openresty)
    luarocks install sendmail --local
    luarocks install luasec --local
    luarocks install json-lua --local
    luarocks install lapis --local CRYPTO_DIR=${pkgs.openssl.out} CRYPTO_INCDIR=${pkgs.openssl.dev}/include OPENSSL_DIR=${pkgs.openssl.out} OPENSSL_INCDIR=${pkgs.openssl.dev}/include
    luarocks install argon2 --local ARGON2_DIR=${pkgs.libargon2} ARGON2_INCDIR=${pkgs.libargon2}/include ARGON2_LIBDIR=${pkgs.libargon2}/lib
    luarocks install lua-uuid --local UUID_DIR=${pkgs.libuuid} UUID_INCDIR=${pkgs.libuuid.dev}/include UUID_LIBDIR=${pkgs.libuuid.out}/lib
    luarocks install lsqlite3 --local SQLITE_DIR=${pkgs.sqlite.dev} SQLITE_INCDIR=${pkgs.sqlite.dev}/include SQLITE_LIBDIR=${pkgs.sqlite.out}/lib
  '';
}
