# nginx
```
apt install -y nginx

nginxBin=`which nginx`
mv "$nginxBin" "${nginxBin}.bak"
wget -qO "$nginxBin" "https://github.com/MoeClub/apt/raw/refs/heads/master/nginx/nginx_amd64_v1.30.4_fp"
# wget -qO "$nginxBin" "https://github.com/MoeClub/apt/raw/refs/heads/master/nginx/nginx_arm64_v1.30.4_fp"
chmod 755 "$nginxBin"

```


# build
```
wget -qO- https://github.com/MoeClub/apt/raw/master/nginx/nginx_musl.sh |sh

```

# debian
```
apt remove --purge -y nginx nginx-common nginx-doc nginx-extras nginx-full nginx-light

apt install -y nginx

```

