#!/bin/bash
echo -n "Creating WEBDAV mounts in $WEBDAV_ROOT"
mkdir -p $WEBDAV_ROOT
chown root:sambashare $WEBDAV_ROOT
chmod g+s $WEBDAV_ROOT
echo "- completed (DOMAIN: $WORKGROUP USERS: <$USERS>)"
for file in $WEBDAV_CONF/*secret; do
	echo "Found Webdav links: "$file
	if [ -e $file ]; then
		touch /etc/davfs2/secrets
		cat $file  | grep -v "\#" | grep [a-zA-Z] | cut -d" " -f1,3- | sed -e "s|^|$WEBDAV_ROOT\/|" >> /etc/davfs2/secrets
		cat $file  | grep -v "\#" | while read p; do
		  if [ `echo $p | wc -c` -gt 10  ]; then
			  MNT=`echo $p  | cut -d" " -f1`
			  SERVER=`echo $p | cut -d" " -f2`
			  if [ `echo "$MNT$SERVER" | wc -c` -gt 15  ]; then
				  mkdir -p /$WEBDAV_ROOT/$MNT
				  echo "Mounting $SERVER as <$USERS> => $WEBDAV_ROOT/$MNT"
				  mount -t davfs $SERVER $WEBDAV_ROOT/$MNT -ogid=sambashare,file_mode=0770,dir_mode=0770
			  fi
		  else
			echo "Config ignored <$p>" `echo $p | wc -c`
		  fi
		done
	else
	  echo "No secret provided."
	fi
	#cat /etc/davfs2/secrets
done
export USERS=""
export VOLUMES=$WEBDAV_ROOT
/start_samba.sh
tail -f /var/log/bootstrap.log

