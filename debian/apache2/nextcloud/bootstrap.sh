#!/bin/bash
# taken from https://doc.owncloud.org/server/8.1/admin_manual/installation/installation_wizard.html#setting-strong-directory-permissions
# and http://idroot.net/linux/install-nextcloud-debian-8/ 
ncpath=$NEXTCLOUD_DOCUMENTROOT
htuser=$APACHE_RUN_USER
htgroup=$APACHE_RUN_GROUP
#ls -laR  $NEXTCLOUD_VOLUMEROOT
if [ -d "${NEXTCLOUD_VOLUMEROOT}/data" ]; then
   #existing install:
   echo "existing install"
   mv $ncpath/config $ncpath/_config
   mv $ncpath/custom_apps $ncpath/_custom_apps
   mv $ncpath/data $ncpath/_data
   mv $ncpath/themes $ncpath/_themes
   echo " - delete any existing apache2 PID"
   rm -rf /run/apache2.pid
else
   #fresh install:
   echo "fresh install"
   id -u ${htuser}
#   umask g=r $ocpath
   umask o-rwx $ncpath
#   umask u=rw $ocpath
#   umask u+s $ocpath
   chown ${htuser}:$htgroup $ncpath
#   chmod g+xs $ocpath

    mv $ncpath/config ${NEXTCLOUD_VOLUMEROOT}/
   mkdir -p ${NEXTCLOUD_VOLUMEROOT}/custom_apps
   mkdir -p ${NEXTCLOUD_VOLUMEROOT}/data
   mv $ncpath/themes ${NEXTCLOUD_VOLUMEROOT}/
fi
echo "binding mount"
ln -s ${NEXTCLOUD_VOLUMEROOT}/config $ncpath
ln -s ${NEXTCLOUD_VOLUMEROOT}/custom_apps $ncpath
ln -s ${NEXTCLOUD_VOLUMEROOT}/data $ncpath
ln -s ${NEXTCLOUD_VOLUMEROOT}/themes $ncpath
echo "fix access rights"
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
rm ${ncpath}/data
./start.sh
