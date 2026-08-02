#!/bin/sh
set -e

dockerProject="nginx"
dockerBase="alpine:3.20"
dockerName="${dockerProject}_buildx"

for arch in "amd64" "arm64"; do
  docker run --rm --platform "linux/${arch}" "${dockerBase}" apk --print-arch >/dev/null 2>&1 || docker run --privileged --rm tonistiigi/binfmt --install "${arch}"
  docker rm -f "${dockerName}" >/dev/null 2>&1 || true
  docker run --rm --platform "linux/${arch}" --name "${dockerName}" -it -v /mnt:/mnt "${dockerBase}" /bin/sh /mnt/nginx_musl.sh 0
  docker run --rm --platform "linux/${arch}" --name "${dockerName}" -it -v /mnt:/mnt "${dockerBase}" /bin/sh /mnt/nginx_musl.sh 1
done
