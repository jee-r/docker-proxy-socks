#!/bin/sh
deluser abc
addgroup --gid $GUID abc
adduser --system --shell /bin/sh --no-create-home --ingroup abc --uid $PUID abc
chown abc:abc /usr/local/bin/healtcheck.sh

#exec su-exec $PUID:$GUID /sbin/tini -- /usr/bin/ssh -4 -D 0.0.0.0:"$LOCALPORT" -C  -N -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "StrictHostKeyChecking=false" -o "ServerAliveInterval=180" -i /config/key -p "$REMOTEPORT" "$REMOTEUSER"@"$REMOTEHOST" 
exec su-exec $PUID:$GUID /sbin/tini -- /usr/bin/autossh -M 0 -N -D 0.0.0.0:"$LOCALPORT" -p "$REMOTEPORT" "$REMOTEUSER"@"$REMOTEHOST" -i /config/key -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -o "StrictHostKeyChecking=false" -o "ServerAliveInterval=180" 
