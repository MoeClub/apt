# Debian8 
```
DEBIAN_FRONTEND=noninteractive apt-get install -y curl screen nload p7zip-full nginx vnstat gawk spawn-fcgi libfcgi0ldbl fcgiwrap unzip mysql-server mysql-client php php-mysql php-cgi php-gd php-sqlite3 php-curl python3-pip ipset cadaver iftop
```

# Windows
```
# win7emb_x86.tar.gz:
https://api.moeclub.org/GoogleDrive/1srhylymTjYS-Ky8uLw4R6LCWfAo1F3s7 

# win8.1emb_x64.tar.gz:
https://api.moeclub.org/GoogleDrive/1cqVl2wSGx92UTdhOxU9pW3wJgmvZMT_J

# win10ltsc_x64.tar.gz:
https://api.moeclub.org/GoogleDrive/1OVA3t-ZI2arkM4E4gKvofcBN9aoVdneh
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
bash <(wget --no-check-certificate -qO- 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh') -d 9 -v 64 -a
```

# Timezone
```
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" >/etc/timezone
```

# Root
```
#!/bin/bash
echo root:Vicer |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
```


