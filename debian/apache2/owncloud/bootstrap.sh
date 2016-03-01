#!/bin/bash
# taken from https://doc.owncloud.org/server/8.1/admin_manual/installation/installation_wizard.html#setting-strong-directory-permissions
ocpath=$OWNCLOUD_DOCUMENTROOT
htuser=$APACHE_RUN_USER
htgroup=$APACHE_RUN_GROUP
#ls -laR  $OWNCLOUD_VOLUMEROOT
if [ -d "${OWNCLOUD_VOLUMEROOT}/data" ]; then
   #existing install:
   echo "existing install"
   mv $ocpath/apps $ocpath/_apps
   mv $ocpath/config $ocpath/_config
   mv $ocpath/data $ocpath/_data
   mv $ocpath/themes $ocpath/_themes
else
   #fresh install:
   echo "fresh install"
   id -u ${htuser}
#   umask g=r $ocpath
   umask o-rwx $ocpath
#   umask u=rw $ocpath
#   umask u+s $ocpath
   chown ${htuser}:$htgroup $ocpath
#   chmod g+xs $ocpath
   mv $ocpath/apps ${OWNCLOUD_VOLUMEROOT}/apps
   mv $ocpath/config ${OWNCLOUD_VOLUMEROOT}/config
   mv $ocpath/data ${OWNCLOUD_VOLUMEROOT}/data
   mv $ocpath/themes ${OWNCLOUD_VOLUMEROOT}/themes
fi
echo "binding mount"
ln -s ${OWNCLOUD_VOLUMEROOT}/apps $ocpath
ln -s ${OWNCLOUD_VOLUMEROOT}/config $ocpath
ln -s ${OWNCLOUD_VOLUMEROOT}/data $ocpath
ln -s ${OWNCLOUD_VOLUMEROOT}/themes $ocpath
echo "fix access rights"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R root:${htuser} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/

chown root:${htuser} ${ocpath}/.htaccess
chown root:${htuser} ${ocpath}/data/.htaccess

chmod 0644 ${ocpath}/.htaccess
chmod 0644 ${ocpath}/data/.htaccess
./start.sh
