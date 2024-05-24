#!/bin/bash

name="docker_"
size="18M"
image="${1:-}"
[ -n "$image" ] || exit 1

docker pull "$image"
[ $? == 0 ] || exit 1

rm -rf ./docker.offline
mkdir -p ./docker.offline
cd ./docker.offline
docker save -o ./docker.offline "$image"

split -b "$size" -d ./docker.offline "$name"

[ $? == 0 ] && ls docker_*

