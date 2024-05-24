#!/bin/bash

Num="${1:-}"
User="${2:-}"
File="${3:-}"
[ -n "$User" ] && [ -n "Num" ] || exit 1

Dir="/tmp/offline"
List=()


rm -rf "${Dir}"
mkdir -p "${Dir}"

for((i=0;i<$Num;i++)); do
  s=`printf %02d $i`;
  n="${File}${s}";
  u="https://raw.githubusercontent.com/${User}/main/${n}"
  wget -qO "${Dir}/${n}" "$u"
  [ $? == 0 ] || break
  List+=("${Dir}/${n}")
done

[ "${#List[@]}" == "$Num" ] || exit 1
cat "${List[@]}" >"${Dir}/_"
docker load -i "${Dir}/_"

rm -rf "${Dir}"


