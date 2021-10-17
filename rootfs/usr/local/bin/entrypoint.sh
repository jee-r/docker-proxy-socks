#!/bin/sh

if [ -f /config/key ]; then
  echo "Trying to connect with ssh-key"
  #/usr/bin/ssh -4 -D 0.0.0.0:"$LOCALPORT" -C  -N -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "StrictHostKeyChecking=false" -o "ServerAliveInterval=180" -i /config/key -p "$REMOTEPORT" "$REMOTEUSER"@"$REMOTEHOST" 
  /usr/bin/autossh -M 0 -N -D 0.0.0.0:$LOCALPORT -p $REMOTEPORT $REMOTEUSER@$REMOTEHOST -i /config/key -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "StrictHostKeyChecking=false" -o "ServerAliveInterval=180" 
elif [ ! -z $REMOTEPWD ]; then 
  echo "Trying to connect with password"
  /usr/bin/sshpass -p "$REMOTEPWD" /usr/bin/autossh -M 0 -N -D 0.0.0.0:$LOCALPORT -p $REMOTEPORT $REMOTEUSER@$REMOTEHOST -o "PubkeyAuthentication=no" -o "PasswordAuthentication=yes" -o "StrictHostKeyChecking=false" -o "ServerAliveInterval=180" 
else 
  echo 'You must provide a password or a private ssh-key'
fi
