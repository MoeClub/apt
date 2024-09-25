#!/bin/bash

size="18M"
image="${1:-}"
name="${2:-}"
[ -n "$image" ] || exit 1
work="$(mktemp -d)"
trap "rm -rf ${work}" EXIT

docker pull "$image" >/dev/null 2>&1
[ $? == 0 ] || exit 1

docker save -o "${work}/_" "$image" >/dev/null 2>&1
[ $? == 0 ] || exit 1
# docker images -a -q |xargs docker rmi -f >/dev/null 2>&1

split -b "$size" -d "${work}/_" "$name"
[ $? == 0 ] || exit 1
trap "rm -rf ${work}/_" EXIT
echo "${work}"

