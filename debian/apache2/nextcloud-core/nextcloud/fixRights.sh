#!/bin/bash
echo "fix access rights"
ncpath=$NEXTCLOUD_DOCUMENTROOT
htuser=$APACHE_RUN_USER
htgroup=$APACHE_RUN_GROUP
find ${ncpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ncpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R root:${htuser} ${ncpath}/
chown -R ${htuser}:${htgroup} ${ncpath}/apps/
chown -R ${htuser}:${htgroup} ${ncpath}/config/
chown -R ${htuser}:${htgroup} ${ncpath}/custom_apps/
chown -R ${htuser}:${htgroup} ${ncpath}/data/
chown -R ${htuser}:${htgroup} ${ncpath}/themes/

touch ${ncpath}/.htaccess
touch ${ncpath}/data/.htaccess
chown root:${htuser} ${ncpath}/.htaccess
chown root:${htuser} ${ncpath}/data/.htaccess

chmod 0644 ${ncpath}/.htaccess
chmod 0644 ${ncpath}/data/.htaccess
chmod 0750 ${ncpath}/occ
echo "done fixing access rights"
