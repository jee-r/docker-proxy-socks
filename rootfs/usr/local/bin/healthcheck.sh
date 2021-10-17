#!/bin/sh

GETIP=$(curl --silent --socks5 127.0.0.1:"$LOCALPORT" ifconfig.co)

if [ "$GETIP" = "$REMOTEHOST" ] 
then 
  echo "PROXY OK $GETIP" && exit 0
else 
  echo "PROXY FAILED $GETIP" && exit 1
fi
exit 0

