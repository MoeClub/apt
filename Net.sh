#!/bin/bash

function netmask() {
  n="${1:-32}"
  b=""
  m=""
  for((i=0;i<32;i++)){
    [ $i -lt $n ] && b="${b}1" || b="${b}0"
  }
  for((i=0;i<4;i++)){
    s=`echo "$b"|cut -c$[$[$i*8]+1]-$[$[$i+1]*8]`
    [ "$m" == "" ] && m="$((2#${s}))" || m="${m}.$((2#${s}))"
  }
  echo "$m"
}

iNet=`ip route show default |awk '{printf $NF}'`
iAddr=`ip addr show dev $iNet |grep "inet.*" |head -n1 |grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\/[0-9]\{1,2\}'`
ipAddr=`echo ${iAddr} |cut -d'/' -f1`
ipMask=`netmask $(echo ${iAddr} |cut -d'/' -f2)`
ipGate=`ip route show default |grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`

