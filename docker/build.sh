#!/bin/bash

dockerName="${1:-debian:latest}"
[ `echo "$dockerName" |sed 's/^://g' |sed 's/:$//g' |grep -c ':'` -ne 1 ] && echo "Invalid Docker Name." && exit 1

userName="$(docker info 2>/dev/null |grep 'Username:' |cut -d':' -f2 |sed 's/[[:space:]]//g')"
[ ! -n "$userName" ] && echo "No Found UserName." && exit 1

dockerDir='./DockerFile'

rm -rf "${dockerDir}"
now="$(date +%s)"

mkdir -p "${dockerDir}"
cat >"${dockerDir}/Dockerfile"<<EOF
# Version 1.0

# 基础镜像
FROM debian:latest

# 镜像操作命令
RUN apt-get -yqq update && apt-get install -yqq wget openssl procps netcat-traditional


# 容器启动命令
CMD ["/bin/bash", "-c", "/bin/bash <(/usr/bin/wget --header 'timestamp: ${now}' -qO- 'http://localhost/install.sh') 1"]


EOF


dockerId=`docker build -t image:latest "$dockerDir" 2>/dev/null |grep '^Successfully built' |sed 's/^Successfully built \([0-9a-z]*\)/\1/g'`
[ ! -n "$dockerId" ] && echo "Build Docker Image Fail." && exit 1

docker tag "${dockerId}" "${userName}/${dockerName}"
[ $? -ne 0 ] && echo "Tag Docker Image Fail." && exit 1

remoteId=`docker push "${userName}/${dockerName}" |grep -o 'sha256:[0-9a-z]*' |cut -d':' -f2 |cut -c 1-12`
[ $? -ne 0 ] && echo "Push Docker Image Fail." && exit 1

docker images -a -q |xargs docker rmi -f >/dev/null 2>&1

echo -e "${dockerId} --> ${remoteId}\n${userName}/${dockerName}\n"
exit 0


