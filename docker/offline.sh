#!/bin/bash

size="18M"
image="${1:-}"
name="${2:-}"
[ -n "$image" ] || exit 1
work="./docker.offline"

docker pull "$image"
[ $? == 0 ] || exit 1

rm -rf "${work}"; mkdir -p "${work}"; cd "${work}"
docker save -o "${work}" "$image"
# docker images -a -q |xargs docker rmi -f >/dev/null 2>&1

split -b "$size" -d "${work}" "$name"

[ $? == 0 ] && rm -rf "${work}" && ls *
