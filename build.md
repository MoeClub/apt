## openssl 1.1.1g
```
ver="1.1.1g"
wget "https://www.openssl.org/source/openssl-${ver}.tar.gz"
tar -xvf "openssl-${ver}.tar.gz"
cd "openssl-${ver}"
./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl

make && make install

```

## python3
```
apt-get install -y build-essential gcc make
apt-get install -y zlib1g-dev libsqlite3-dev libffi-dev libreadline-dev

ver="3.7.8"
wget "https://www.python.org/ftp/python/${ver}/Python-${ver}.tar.xz"
tar -xvf "Python-${ver}.tar.xz"
cd "Python-${ver}"

sed -i "s/^#readline/readline/g" Modules/Setup.dist
sed -i "s/^#SSL=.*/SSL=\/usr\/local\/openssl/g" Modules/Setup.dist
sed -i "s/^#_ssl/_ssl/g" Modules/Setup.dist
sed -i "s/^#[\t]*-DUSE_SSL/-DUSE_SSL/g" Modules/Setup.dist
sed -i "s/^#[\t]*-L\$(SSL)/-L\$(SSL)/g" Modules/Setup.dist

./configure --enable-shared --prefix=/usr

make && make install


```
