#!/bin/bash

[ -d /etc/nginx ] || exit 1

# config
find /etc/nginx -type f,l |xargs rm -rf
find /etc/nginx -maxdepth 1 -type d -empty |xargs rm -rf
mkdir -p /etc/nginx/conf.d /etc/nginx/sites-available
wget -qO /etc/nginx/nginx.conf https://github.com/MoeClub/apt/raw/master/nginx/conf/nginx.conf
wget -qO /etc/nginx/sites-available/default https://github.com/MoeClub/apt/raw/master/nginx/conf/default

# nginx
case `uname -m` in aarch64|arm64) VER="arm64";; x86_64|amd64) VER="amd64";; *) VER="";; esac
[ -n "$VER" ] || exit 1;
nginxBin=`which nginx`
mv "$nginxBin" "${nginxBin}.bak"
wget -qO "$nginxBin" "https://raw.githubusercontent.com/MoeClub/apt/master/nginx/nginx_${VER}_v1.18.0"
chmod 755 "$nginxBin"

# restart nginx
systemctl restart nginx
systemctl status nginx

