#!/bin/bash

echo "whmcs" >/etc/hostname

bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/apt/master/bbr/bbr.sh') 0 0

bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/LinuxInit.sh')

DEBIAN_FRONTEND=noninteractive apt-get install -y openssl wget curl screen nload unzip vnstat gawk dnsutils net-tools p7zip-full python3-pip ipset iftop lsof

DEBIAN_FRONTEND=noninteractive apt-get install -y nginx mariadb-client mariadb-server

pip3 install flask pymysql

bash <(wget -qO- https://github.com/MoeClub/apt/raw/master/nginx/conf/nginx.sh)

bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/php.sh') 7.0
