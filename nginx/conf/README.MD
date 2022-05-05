# default
```
apt install -y nginx
bash <(wget -qO- https://github.com/MoeClub/apt/raw/master/nginx/conf/nginx.sh)

```

# nginx.conf

```
find /etc/nginx -type f,l |grep -v "/sites-available/" |xargs rm -rf
find /etc/nginx -maxdepth 1 -type d -empty |xargs rm -rf
mkdir -p /etc/nginx/conf.d /etc/nginx/sites-available
wget -qO /etc/nginx/nginx.conf https://github.com/MoeClub/apt/raw/master/nginx/conf/nginx.conf

```

