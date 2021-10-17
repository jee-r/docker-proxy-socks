#!/bin/sh

curl --silent --socks5 127.0.0.1:"$LOCALPORT" ifconfig.co

if [ "$?" == 0 ]; then 
  echo "PROXY OK $GETIP" && exit 0
else 
  echo "PROXY FAILED $GETIP" && exit 1
fi

exit 0

