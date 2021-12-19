# nginx
```
apt install -y nginx
nginxBin=`which nginx`
mv "$nginxBin" "${nginxBin}.bak"
wget -qO "$nginxBin" "https://raw.githubusercontent.com/MoeClub/apt/master/nginx/nginx"

```
