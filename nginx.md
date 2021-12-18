# debian 11
```
apt install -y wget make gcc build-essential xz-utils

```

# nginx src
```
# src nginx
rm -rf ./nginx; mkdir -p ./nginx
wget -qO- http://deb.debian.org/debian/pool/main/n/nginx/nginx_1.18.0.orig.tar.gz |tar -zxv --strip-components 1 -C ./nginx
wget -qO- http://deb.debian.org/debian/pool/main/n/nginx/nginx_1.18.0-6.1.debian.tar.xz |tar -zxv -C ./nginx

# src openssl
rm -rf ./openssl; mkdir -p ./openssl
wget -qO- https://www.openssl.org/source/old/1.1.1/openssl-1.1.1k.tar.gz |tar -xv --strip-components 1 -C ./openssl

# src pcre
rm -rf ./pcre; mkdir -p ./pcre
wget -qO- "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.gz" | tar -zxv --strip-components 1 -C ./pcre

# src zlib
rm -rf ./zlib; mkdir -p ./zlib
wget -qO- "https://zlib.net/fossils/zlib-1.2.11.tar.gz" | tar -zxv --strip-components 1 -C ./zlib


```

# luajit
```
rm -rf luajit; mkdir -p ./luajit
wget -qO- http://security.debian.org/debian-security/pool/updates/main/l/luajit/luajit_2.0.4+dfsg.orig.tar.gz |tar -zxv --strip-components 1 -C ./luajit
cd ./luajit
make install PREFIX=/usr/local/LuaJIT -j $(grep "cpu cores" /proc/cpuinfo | wc -l)

```

# nginx configure
```
./configure \
--with-cc-opt="-static -static-libgcc" \
--with-ld-opt="-static" \
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
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_gunzip_module \
--with-http_mp4_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--without-http_geo_module \
--without-http_userid_module \
--without-http_memcached_module \
--without-http_split_clients_module \
--with-pcre=../pcre \
--with-zlib=../zlib \
--with-openssl=../openssl \
--add-module=./debian/modules/http-subs-filter \
--add-module=./debian/modules/http-ndk \
--add-module=./debian/modules/http-lua

make -j $(grep "cpu cores" /proc/cpuinfo | wc -l)
```

