# Debian8 
```
DEBIAN_FRONTEND=noninteractive apt-get install -y curl screen nload p7zip-full nginx vnstat gawk spawn-fcgi libfcgi0ldbl fcgiwrap unzip mysql-server mysql-client php php-mysql php-cgi php-gd php-sqlite3 php-curl python3-pip ipset cadaver iftop
```

# Debian8/9 Kernel
```
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/Debian_Kernel.sh')
```

# Debian8/9 LotServer
```
bash <(wget --no-check-certificate -qO- https://github.com/MoeClub/lotServer/raw/master/Install.sh) uninstall
```

# Debian8/9 Nginx
```
wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/nginx_update.sh' |bash
```

# Linux limits
```
[ -f /etc/security/limits.conf ] && LIMIT='262144' && sed -i '/^\(\*\|root\)[[:space:]]*\(hard\|soft\)[[:space:]]*\(nofile\|memlock\)/d' /etc/security/limits.conf && echo -ne "*\thard\tmemlock\t${LIMIT}\n*\tsoft\tmemlock\t${LIMIT}\nroot\thard\tmemlock\t${LIMIT}\nroot\tsoft\tmemlock\t${LIMIT}\n*\thard\tnofile\t${LIMIT}\n*\tsoft\tnofile\t${LIMIT}\nroot\thard\tnofile\t${LIMIT}\nroot\tsoft\tnofile\t${LIMIT}\n\n" >>/etc/security/limits.conf

```

# ReInstall
```
bash <(wget —no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 9 -v 64 -a
```
