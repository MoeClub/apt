#!/bin/sh
set -eu


SRC="https://raw.githubusercontent.com/MoeClub/apt/master"


VERSION_NGINX="1.30.4"
VERSION_OPENSSL="3.5.7"
VERSION_PCRE="8.45"
VERSION_ZLIB="1.2.11"
VERSION_LUAJIT="2.1-20250826"
VERSION_XML2="2.15.3"
VERSION_XSLT="1.1.45"
VERSION_QUICKJS="2026-06-04"

VERSION_NGX_SUBS="0.6.4"
VERSION_NGX_NDK="0.3.1"
VERSION_NGX_LUA="0.10.14-1"
VERSION_NGX_NJS="1.0.0"
VERSION_NGX_FP="1.0.5_2"
ENABLE_FP="${1:-1}"


case `apk --print-arch` in x86_64) ARCH="amd64";; aarch64) ARCH="arm64";; *) ARCH="";; esac
[ -n "$ARCH" ] || exit 1

fetch_tar() {
    url="$1"; dest="$2"; mkdir -p "$dest"; echo "fetch: $url"
    echo "${url}" |grep -q '\.xz$' && tf="-Jx" || tf="-zx"
    wget --no-check-certificate -qO- "$url" | tar "${tf}" --strip-components=1 -C "$dest"
}


apk add --no-cache build-base coreutils findutils linux-headers make musl-dev grep perl sed tar wget xz

WORKDIR=`mktemp -d` && cd "$WORKDIR"


# openssl, pcre, zlib
echo "$VERSION_OPENSSL" |grep -q '^1' && VerOpenSSL="OpenSSL_${VERSION_OPENSSL//./_}" || VerOpenSSL="openssl-${VERSION_OPENSSL}"
fetch_tar "https://github.com/openssl/openssl/releases/download/${VerOpenSSL}/openssl-${VERSION_OPENSSL}.tar.gz" "$WORKDIR/openssl"
fetch_tar "${SRC}/nginx/src/pcre/pcre-${VERSION_PCRE}.tar.gz" "$WORKDIR/pcre"
fetch_tar "${SRC}/nginx/src/zlib/zlib-${VERSION_ZLIB}.tar.gz" "$WORKDIR/zlib"


# nginx
fetch_tar "${SRC}/nginx/src/nginx/nginx-${VERSION_NGINX}.tar.gz" "$WORKDIR/nginx"

# modules
fetch_tar "${SRC}/nginx/src/nginxModule/http-subs-filter_v${VERSION_NGX_SUBS}.tar.gz" "$WORKDIR/nginx/modules/http-subs-filter"
fetch_tar "${SRC}/nginx/src/nginxModule/http-ndk_v${VERSION_NGX_NDK}.tar.gz" "$WORKDIR/nginx/modules/http-ndk"
fetch_tar "${SRC}/nginx/src/nginxModule/http-lua_v${VERSION_NGX_LUA}.tar.gz" "$WORKDIR/nginx/modules/http-lua"
fetch_tar "${SRC}/nginx/src/nginxModule/http-njs-${VERSION_NGX_NJS}.tar.gz" "$WORKDIR/nginx/modules/http-njs"

if [ "$ENABLE_FP" == "1" ]; then
    fetch_tar "${SRC}/nginx/src/nginxModule/ssl-fingerprint-${VERSION_NGX_FP}.tar.gz" "$WORKDIR/nginx/modules/ssl-fp"
    patch -p1 -d "$WORKDIR/nginx" < "$WORKDIR/nginx/modules/ssl-fp/patches/release-1.30.4.patch"
    patch -p1 -d "$WORKDIR/openssl" < "$WORKDIR/nginx/modules/ssl-fp/patches/openssl-3.5.7.patch"
fi


# libxml2
fetch_tar "${SRC}/nginx/src/quickjs/libxml2-${VERSION_XML2}.tar.xz" "$WORKDIR/xml2Build"
cd "$WORKDIR/xml2Build"
./configure --prefix="/usr" --disable-shared --enable-static --without-python --without-zlib --without-debug
CFLAGS='-fPIC' make install -j`nproc`

# libxslt
fetch_tar "${SRC}/nginx/src/quickjs/libxslt-${VERSION_XSLT}.tar.xz" "$WORKDIR/xsltBuild"
cd "$WORKDIR/xsltBuild"
./configure --prefix="/usr" --with-libxml-prefix="/usr" --disable-shared --enable-static --without-python --without-crypto --without-debugger --without-debug
CFLAGS='-fPIC' make install -j`nproc`

# quickjs
fetch_tar "${SRC}/nginx/src/quickjs/quickjs-${VERSION_QUICKJS}.tar.xz" "$WORKDIR/quickjsBuild"
cd "$WORKDIR/quickjsBuild"
CFLAGS='-fPIC' make install -j`nproc` PREFIX="/usr"

# luajit
fetch_tar "${SRC}/nginx/src/luajit/luajit_v${VERSION_LUAJIT}.tar.gz" "$WORKDIR/luajitBuild"
cd "$WORKDIR/luajitBuild"
mkdir -p "$WORKDIR/LuaJIT"
CFLAGS='-fPIC' make install -j`nproc` PREFIX="$WORKDIR/LuaJIT" BUILDMODE=static
find "$WORKDIR/LuaJIT/lib" -maxdepth 1 -name '*.so*' -delete


# build
cd "$WORKDIR/nginx"
export LUAJIT_LIB="$WORKDIR/LuaJIT/lib"
export LUAJIT_INC=`find "$WORKDIR/LuaJIT/include" -maxdepth 1 -type d -name 'luajit-*' | sort | head -n 1`
export ExtModule=""; for item in `find "./modules" -maxdepth 3 -type f -name "config" |xargs dirname`; do echo "$item" |grep -q '/$' || ExtModule="${ExtModule}--add-module=${item} "; done


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
    --with-http_xslt_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_v3_module \
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
    --with-pcre-opt='-DSUPPORT_UTF -DSUPPORT_UCP' \
    --with-pcre-jit \
    --with-zlib=../zlib \
    --with-openssl=../openssl \
    $(echo "$ExtModule")


make -j`nproc`

[ $? -eq 0 ] && [ -f "$(pwd)/objs/nginx" ] || exit 1
TAEGETDIR="/mnt/nginx"
TARGET="nginx_${ARCH}_v${VERSION_NGINX}"
[ "$ENABLE_FP" == "1" ] && TARGET="${TARGET}_fp"
echo "$(pwd)/objs/nginx"
mkdir -p "${TAEGETDIR}"
cp -rf "$(pwd)/objs/nginx" "${TAEGETDIR}/${TARGET}"
strip "${TAEGETDIR}/${TARGET}"
echo "${TAEGETDIR}/${TARGET}"
"${TAEGETDIR}/${TARGET}" -V
