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
--with-http_ssl_module \
--with-pcre=../pcre \
--with-zlib=../zlib \
--with-openssl=../openssl \
--add-module=./debian/modules/http-lua

```
