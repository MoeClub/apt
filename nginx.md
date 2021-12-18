# nginx
```
# src nginx
rm -rf ./nginx; mkdir -p ./nginx

wget -qO- http://deb.debian.org/debian/pool/main/n/nginx/nginx_1.18.0.orig.tar.gz |tar -zxv --strip-components 1 -C ./nginx

wget -qO- http://deb.debian.org/debian/pool/main/n/nginx/nginx_1.18.0-6.1.debian.tar.xz |tar -zxv -C ./nginx

# src openssl
rm -rf ./openssl; mkdir -p ./openssl

wget -qO- https://www.openssl.org/source/old/1.1.1/openssl-1.1.1k.tar.gz |tar -xv --strip-components 1 -C ./openssl

```
