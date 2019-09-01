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

# outsource access right management
./nextcloud-fixRights.sh

#Nextcloud security advise. Need to be set in the config/config.php to actual data path rather than linking
rm ${ncpath}/data

#https://unix.stackexchange.com/questions/155150/where-in-apache-2-do-you-set-the-servername-directive-globally
echo "ServerName ${APACHE_SERVERNAME}" >> /etc/apache2/apache2.conf
apache2ctl configtest
apache2ctl restart
tail -f ${APACHE_LOG_DIR}/*.log
