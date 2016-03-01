#!/bin/bash
export READONLY=${READONLY:-"no"}
export LOCKING=${LOCKING:-"no"}
export GUESTOK=${GUESTOK:-"no"}
export FORCEUSER=${FORCEUSER:-"dummy"}
export FORCEGROUP=${FORCEGROUP:-"none"}
export BROWSABLE=${BROWSABLE:-"no"}
export FILEMOD=${FILEMOD:-0755}
export DIRMOD=${DIRMOD:-0755}
export MASKMOD=${MASKMOD:-0755}
export MAPARCHIVE=${MAPARCHIVE:-"no"}
export MAPSYSTEM=${MAPSYSTEM:-"no"}
export MAPHIDDEN=${MAPHIDDEN:-"no"}
export WORKGROUP=${WORKGROUP:-"WORKGROUP"}
# Start pagemaster
echo $USERS
export WUSER=$USERS
for user in $USERS; do
  echo $user
  useradd -ms /bin/bash $user
  smbpasswd -a $user 
done
echo "workgroup = $WORKGROUP
server string = %h server (Samba, Ubuntu)
security = user
encrypt passwords = true
invalid users = root
" >> /etc/samba/smb.conf
chmod 700 /etc/samba/smbpasswd
for vol in $VOLUMES; do
  echo "add $vol"
  export VOLUME=$vol
  export VOLUME_NAME=$(echo "$VOLUME" |sed "s/\///" |tr '[\/<>:"\\|?*+;,=]' '_')
  cat /share.tmpl | envsubst >> /etc/samba/smb.conf
done
/etc/init.d/samba start
netstat -tulpn | egrep "samba|smbd|nmbd|winbind"
top
