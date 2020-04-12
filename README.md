# Remove Cache
```
rm -rf /etc/apt/trusted.gpg.d/*
rm -rf /var/lib/apt/lists/*
rm -rf /etc/apt/trusted.gpg
mkdir -p /var/lib/apt/lists/
mkdir -p /etc/apt/trusted.gpg.d
```

# Install key
```
wget -qO- https://ftp-master.debian.org/keys/release-8.asc |apt-key add -
wget -qO- https://ftp-master.debian.org/keys/release-9.asc |apt-key add -
wget -qO- https://ftp-master.debian.org/keys/release-10.asc |apt-key add -
```

# sources.list
```
deb [trusted=yes] http://deb.debian.org/debian jessie main
deb-src [trusted=yes] http://deb.debian.org/debian jessie main
deb [trusted=yes] http://deb.debian.org/debian stretch main
deb-src [trusted=yes] http://deb.debian.org/debian stretch main
deb [trusted=yes] http://deb.debian.org/debian-security stretch/updates main
deb-src [trusted=yes] http://deb.debian.org/debian-security stretch/updates main

```
