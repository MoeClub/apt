#!/bin/bash

[ -d /etc/nginx ] || exit 1
nginxVersion="1.30.4_fp"

src="https://github.com/MoeClub/apt/raw/refs/heads/master/nginx"

# config
find /etc/nginx -type f,l |xargs rm -rf
find /etc/nginx -maxdepth 1 -type d -empty |xargs rm -rf
mkdir -p /etc/nginx/conf.d /etc/nginx/sites-available
wget -qO /etc/nginx/nginx.conf "${src}/conf/nginx.conf"
wget -qO /etc/nginx/sites-available/default "${src}/conf/default"

# nginx
case `uname -m` in aarch64|arm64) VER="arm64";; x86_64|amd64) VER="amd64";; *) VER="";; esac
[ -n "$VER" ] || exit 1;
nginxBin=`which nginx`
mv "$nginxBin" "${nginxBin}.bak"
wget -qO "$nginxBin" "${src}/nginx_${VER}_v${nginxVersion}"
chmod 755 "$nginxBin"

# restart nginx
systemctl restart nginx
systemctl status nginx

