#!/bin/sh

GETIP=$(curl --silent --show-error --socks5 127.0.0.1:"$LOCALPORT" --connect-timeout 100 --max-time 119 https://ifconfig.co)

if [ "$?" == 0 ]; then 
  echo "PROXY OK $GETIP" && exit 0
else 
  echo "PROXY FAILED $GETIP" && exit 1
fi

exit 0

