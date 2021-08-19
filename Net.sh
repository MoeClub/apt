#!/bin/bash

## License: GPL
## It can reinstall Debian, Ubuntu, CentOS system with network.
## Default root password: MoeClub.org
## Blog: https://moeclub.org
## Written By MoeClub.org


export tmpVER=''
export tmpDIST=''
export tmpURL=''
export tmpWORD=''
export tmpMirror=''
export tmpSSL=''
export ipAddr=''
export ipMask=''
export ipGate=''
export Relese=''
export ddMode='0'
export setNet='0'
export setRDP='0'
export setIPv6='0'
export isMirror='0'
export FindDists='0'
export loaderMode='0'
export IncFirmware='0'
export SpikCheckDIST='0'
export setInterfaceName='0'
export UNKNOWHW='0'
export UNVER='6.4'

while [[ $# -ge 1 ]]; do
  case $1 in
    -a|--auto)
      shift
      ;;
    -m|--manual)
      shift
      ;;
    -v|--ver)
      shift
      tmpVER="$1"
      shift
      ;;
    -d|--debian)
      shift
      Relese='Debian'
      tmpDIST="$1"
      shift
      ;;
    -u|--ubuntu)
      shift
      Relese='Ubuntu'
      tmpDIST="$1"
      shift
      ;;
    -c|--centos)
      shift
      Relese='CentOS'
      tmpDIST="$1"
      shift
      ;;
    -dd|--image)
      shift
      ddMode='1'
      tmpURL="$1"
      shift
      ;;
    -p|--password)
      shift
      tmpWORD="$1"
      shift
      ;;
    -i|--interface)
      shift
      interface="$1"
      shift
      ;;
    --ip-addr)
      shift
      ipAddr="$1"
      shift
      ;;
    --ip-mask)
      shift
      ipMask="$1"
      shift
      ;;
    --ip-gate)
      shift
      ipGate="$1"
      shift
      ;;
    --dev-net)
      shift
      setInterfaceName='1'
      ;;
    --loader)
      shift
      loaderMode='1'
      ;;
    -apt|-yum|--mirror)
      shift
      isMirror='1'
      tmpMirror="$1"
      shift
      ;;
    -rdp)
      shift
      setRDP='1'
      WinRemote="$1"
      shift
      ;;
    -ssl)
      shift
      tmpSSL="$1"
      shift
      ;;
    -firmware)
      shift
      IncFirmware="1"
      ;;
    -port)
      shift
      sshPORT="$1"
      shift
      ;;
    --ipv6)
      shift
      setIPv6='1'
      ;;
    *)
      if [[ "$1" != 'error' ]]; then echo -ne "\nInvaild option: '$1'\n\n"; fi
      echo -ne " Usage:\n\tbash $(basename $0)\t-d/--debian [\033[33m\033[04mdists-name\033[0m]\n\t\t\t\t-u/--ubuntu [\033[04mdists-name\033[0m]\n\t\t\t\t-c/--centos [\033[33m\033[04mdists-verison\033[0m]\n\t\t\t\t-v/--ver [32/\033[33m\033[04mi386\033[0m|64/amd64]\n\t\t\t\t--ip-addr/--ip-gate/--ip-mask\n\t\t\t\t-apt/-yum/--mirror\n\t\t\t\t-dd/--image\n\t\t\t\t-a/--auto\n\t\t\t\t-m/--manual\n"
      exit 1;
      ;;
    esac
  done

[[ "$EUID" -ne '0' ]] && echo "Error:This script must be run as root!" && exit 1;

function dependence(){
  Full='0';
  for BIN_DEP in `echo "$1" |sed 's/,/\n/g'`
    do
      if [[ -n "$BIN_DEP" ]]; then
        Found='0';
        for BIN_PATH in `echo "$PATH" |sed 's/:/\n/g'`
          do
            ls $BIN_PATH/$BIN_DEP >/dev/null 2>&1;
            if [ $? == '0' ]; then
              Found='1';
              break;
            fi
          done
        if [ "$Found" == '1' ]; then
          echo -en "[\033[32mok\033[0m]\t";
        else
          Full='1';
          echo -en "[\033[31mNot Install\033[0m]";
        fi
        echo -en "\t$BIN_DEP\n";
      fi
    done
  if [ "$Full" == '1' ]; then
    echo -ne "\n\033[31mError! \033[0mPlease use '\033[33mapt-get\033[0m' or '\033[33myum\033[0m' install it.\n\n\n"
    exit 1;
  fi
}

function selectMirror(){
  [ $# -ge 3 ] || exit 1
  Relese=$(echo "$1" |sed -r 's/(.*)/\L\1/')
  DIST=$(echo "$2" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  VER=$(echo "$3" |sed 's/\ //g' |sed -r 's/(.*)/\L\1/')
  New=$(echo "$4" |sed 's/\ //g')
  [ -n "$Relese" ] && [ -n "$DIST" ] && [ -n "$VER" ] || exit 1
  if [ "$Relese" == "debian" ] || [ "$Relese" == "ubuntu" ]; then
    TEMP="SUB_MIRROR/dists/${DIST}/main/installer-${VER}/current/images/netboot/${relese}-installer/${VER}/initrd.gz"
  elif [ "$Relese" == "centos" ]; then
    TEMP="SUB_MIRROR/${DIST}/os/${VER}/isolinux/initrd.img"
  fi
  [ -n "$TEMP" ] || exit 1
  mirrorStatus=0
  declare -A MirrorBackup
  MirrorBackup=(["debian0"]="" ["debian1"]="http://deb.debian.org/debian" ["debian2"]="http://archive.debian.org/debian" ["ubuntu0"]="" ["ubuntu1"]="http://archive.ubuntu.com/ubuntu" ["centos0"]="" ["centos1"]="http://mirror.centos.org/centos" ["centos2"]="http://vault.centos.org")
  echo "$New" |grep -q '^http://\|^https://\|^ftp://' && MirrorBackup[${Relese}0]="$New"
  for mirror in $(echo "${!MirrorBackup[@]}" |sed 's/\ /\n/g' |sort -n |grep "^$Relese")
    do
      Current="${MirrorBackup[$mirror]}"
      [ -n "$CurMirror" ] || continue
      MirrorURL=`echo "$TEMP" |sed "s#SUB_MIRROR#${Current}#g"`
      wget --no-check-certificate --spider --timeout=3 -o /dev/null "$MirrorURL"
      [ $? -eq 0 ] && mirrorStatus=1 && break
    done
  [ $mirrorStatus -eq 1 ] && echo "$Current" || exit 1
}

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

