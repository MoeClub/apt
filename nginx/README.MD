# nginx
```
apt install -y nginx

nginxBin=`which nginx`
mv "$nginxBin" "${nginxBin}.bak"
wget -qO "$nginxBin" "https://raw.githubusercontent.com/MoeClub/apt/master/nginx/nginx_amd64_v1.18.0"
# wget -qO "$nginxBin" "https://raw.githubusercontent.com/MoeClub/apt/master/nginx/nginx_arm64_v1.18.0"
chmod 755 "$nginxBin"

```

# info
```
root@debian:~# /tmp/nginx/objs/nginx -V
nginx version: nginx/1.18.0
built by gcc 10.2.1 20210110 (Debian 10.2.1-6) 
built with OpenSSL 1.1.1k  25 Mar 2021
TLS SNI support enabled
configure arguments: --with-cc-opt='-static -static-libgcc' --with-ld-opt=-static --with-cpu-opt=generic --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/dev/null --http-log-path=/dev/null --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_flv_module --with-http_gzip_static_module --with-http_gunzip_module --with-http_mp4_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_v2_module --without-http_geo_module --without-http_userid_module --without-http_memcached_module --without-http_split_clients_module --with-pcre=../pcre --with-zlib=../zlib --with-openssl=../openssl --add-module=./modules/http-lua --add-module=./modules/http-ndk --add-module=./modules/http-echo --add-module=./modules/http-subs-filter

root@debian:~# ldd /tmp/nginx/objs/nginx
        not a dynamic executable
```

# build
```
wget -qO- https://github.com/MoeClub/apt/raw/master/nginx/nginx.sh |bash

```

# debian
```
apt remove --purge -y nginx nginx-common nginx-doc nginx-extras nginx-full nginx-light

apt install -y nginx

```

