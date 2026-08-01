#!/bin/sh
set -eu


SRC="https://raw.githubusercontent.com/MoeClub/apt/master"


VERSION_NGINX="1.30.4"
VERSION_OPENSSL="1.1.1w"
VERSION_PCRE="8.45"
VERSION_ZLIB="1.2.11"
VERSION_LUAJIT="2.1-20190221"

VERSION_NGX_SUBS="0.6.4"
VERSION_NGX_NDK="0.3.4"
VERSION_NGX_LUA="0.10.14"
VERSION_NGX_NJS="1.0.0"
VERSION_NGX_JA3="0.1.0-alpha"
ENABLE_JA3="${1:-0}"


case `apk --print-arch` in x86_64) ARCH="amd64";; aarch64) ARCH="arm64";; *) ARCH="";; esac
[ -n "$ARCH" ] || exit 1

fetch_tgz() {
    url="$1"; dest="$2"; mkdir -p "$dest"
    wget --no-check-certificate -qO- "$url" | tar -zx --strip-components=1 -C "$dest"
}


apk add --no-cache build-base coreutils findutils linux-headers make musl-dev grep perl sed tar wget xz

WORKDIR=`mktemp -d` && cd "$WORKDIR"

# luajit
fetch_tgz "${SRC}/nginx/src/luajit/luajit-v${VERSION_LUAJIT}.tar.gz" "$WORKDIR/luajitBuild"
cd "$WORKDIR/luajitBuild"
mkdir -p "$WORKDIR/LuaJIT"
make install -j`nproc` PREFIX="$WORKDIR/LuaJIT" BUILDMODE=static
find "$WORKDIR/LuaJIT/lib" -maxdepth 1 -name '*.so*' -delete

# openssl, pcre, zlib
fetch_tgz "${SRC}/nginx/src/openssl/openssl-${VERSION_OPENSSL}.tar.gz" "$WORKDIR/openssl"
fetch_tgz "${SRC}/nginx/src/pcre/pcre-${VERSION_PCRE}.tar.gz" "$WORKDIR/pcre"
fetch_tgz "${SRC}/nginx/src/zlib/zlib-${VERSION_ZLIB}.tar.gz" "$WORKDIR/zlib"


# nginx
fetch_tgz "${SRC}/nginx/src/nginx/nginx-${VERSION_NGINX}.tar.gz" "$WORKDIR/nginx"
cd "$WORKDIR/nginx"
mkdir -p ./modules

fetch_tgz "${SRC}/nginx/src/nginxModule/http-subs-filter_v${VERSION_NGX_SUBS}.tar.gz" "$WORKDIR/nginx/modules/http-subs-filter"
fetch_tgz "${SRC}/nginx/src/nginxModule/http-ndk_v${VERSION_NGX_NDK}.tar.gz" "$WORKDIR/nginx/modules/http-ndk"
fetch_tgz "${SRC}/nginx/src/nginxModule/http-lua_v${VERSION_NGX_LUA}.tar.gz" "$WORKDIR/nginx/modules/http-lua"
fetch_tgz "${SRC}/nginx/src/nginxModule/http-njs-${VERSION_NGX_NJS}.tar.gz" "$WORKDIR/nginx/modules/http-njs"
[ "$ENABLE_JA3" == "1" ] && fetch_tgz "${SRC}/nginx/src/nginxModule/ssl-ja3-v${VERSION_NGX_JA3}.tar.gz" "$WORKDIR/nginx/modules/ssl-ja3"

ExtModule=""; for item in `find ./modules/ -maxdepth 3 -type f -name "config" |xargs dirname`; do echo "$item" |grep -q '/$' || ExtModule="${ExtModule}--add-module=${item} "; done


# patch
if [ "$ENABLE_JA3" == "1" ]; then
    SSL_JA3_NGINX_PATCH="nginx.1.29.8.ssl.extensions.patch"
    sed -i 's|SSL_set_options(sc->connection, SSL_OP_NO_TICKET);|/* SSL_set_options(sc->connection, SSL_OP_NO_TICKET); */|' "$WORKDIR/nginx/modules/ssl-ja3/patches/${SSL_JA3_NGINX_PATCH}"
    sed -i 's/OPENSSL_VERSION_NUMBER >= 0x30000000L/OPENSSL_VERSION_NUMBER >= 0x10101000L/' "$WORKDIR/nginx/modules/ssl-ja3/patches/${SSL_JA3_NGINX_PATCH}"
    patch -p1 -d "$WORKDIR/nginx" < "$WORKDIR/nginx/modules/ssl-ja3/patches/${SSL_JA3_NGINX_PATCH}"
    grep -q 'ciphers_sz' "$WORKDIR/nginx/src/event/ngx_event_openssl.h"
    case "$VERSION_OPENSSL" in 3.*) SSL_JA3_OPENSSL_PATCH="openssl-3.extensions.patch";; *) SSL_JA3_OPENSSL_PATCH="openssl-1.1.1.extensions.patch";; esac
    patch -p1 -d "$WORKDIR/openssl" < "$WORKDIR/nginx/modules/ssl-ja3/patches/${SSL_JA3_OPENSSL_PATCH}"
fi

# build
export LUAJIT_LIB="$WORKDIR/LuaJIT/lib"
export LUAJIT_INC=`find "$WORKDIR/LuaJIT/include" -maxdepth 1 -type d -name 'luajit-*' | sort | head -n 1`
export NJS_LIBXSLT=NO

./configure \
    --with-cc-opt='-static -static-libgcc' \
    --with-ld-opt='-static -static-libgcc' \
    --with-cpu-opt=generic \
    --prefix=/usr/share/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/dev/null \
    --http-log-path=/dev/null \
    --lock-path=/var/lock/nginx.lock \
    --pid-path=/run/nginx.pid \
    --modules-path=/usr/lib/nginx/modules \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --http-scgi-temp-path=/var/lib/nginx/scgi \
    --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_gzip_static_module \
    --with-http_gunzip_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_dav_module \
    --with-http_stub_status_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-file-aio \
    --without-http_geo_module \
    --without-http_userid_module \
    --without-http_memcached_module \
    --with-pcre=../pcre \
    --with-pcre-jit \
    --with-zlib=../zlib \
    --with-openssl=../openssl \
    $(echo "$ExtModule")

make -j`nproc`

[ $? -eq 0 ] && [ -f "$(pwd)/objs/nginx" ] || exit 1
TARGET="nginx_${ARCH}_v${VERSION_NGINX}"
[ "$ENABLE_JA3" == "1" ] && TARGET="${TARGET}_ja3"
echo "$(pwd)/objs/nginx"
cp -rf "$(pwd)/objs/nginx" "/mnt/${TARGET}"
strip "/mnt/${TARGET}"
echo "/mnt/${TARGET}"
"/mnt/${TARGET}" -V


