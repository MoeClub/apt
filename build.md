## openssl 1.1.1g
```
ver="1.1.1g"
wget "https://www.openssl.org/source/openssl-${ver}.tar.gz"
tar -xvf "openssl-${ver}.tar.gz"
cd "openssl-${ver}"
./config --prefix=/usr

make && make install

```

## python3
```
ver="3.7.8"
wget "https://www.python.org/ftp/python/${ver}/Python-${ver}.tar.xz"
tar -xvf "Python-${ver}.tar.xz"
cd "Python-${ver}"
./configure  --enable-optimizations --prefix=/usr

make && make install


```
