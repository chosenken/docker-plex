#!/bin/bash -eux
GROUP=plextmp

CONFIGDIR=/config
DATADIR=/mnt/Downloads
USER=plex

mkdir -p ${CONFIGDIR}/logs/supervisor
chown -R ${USER} ${CONFIGDIR}

touch /supervisord.log
touch /supervisord.pid
chown ${USER}: /supervisord.log /supervisord.pid

TARGET_GID=$(stat -c "%g" ${DATADIR})
EXISTS=$(cat /etc/group | grep ${TARGET_GID} | wc -l)

# Create new group using target GID and add plex user
if [ $EXISTS = "0" ]; then
  groupadd --gid ${TARGET_GID} ${GROUP}
else
  # GID exists, find group name and add
  GROUP=$(getent group $TARGET_GID | cut -d: -f1)
  usermod -a -G ${GROUP} ${USER}
fi
usermod -a -G ${GROUP} ${USER}

# Current defaults to run as root while testing.
if [ "${RUN_AS_ROOT}" = true ]; then
  /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
  su ${USER} -c "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"
fi
