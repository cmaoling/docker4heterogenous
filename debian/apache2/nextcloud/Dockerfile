###########################################################
# Dockerfile to build nextcloud container images
# Based on armhf-debian
FROM  [user.id]/[parent.repository][parent.tag]

###########################################################
# File Author / Maintainer
MAINTAINER  [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Install nextcloud on micro best of my knowledge
ENV DEBIAN_FRONTEND noninteractive
RUN DEBIAN=FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove

RUN apt-get update && apt-get install -y php5-gd php5-json php5-sqlite php5-curl php5-intl php5-mcrypt php5-mysqlnd smbclient

#RUN DEBIAN_FRONTEND=noninteractive rm -rf /usr/src/nextcloud/updater

VOLUME /var/nextcloud
#curl -fsSL -o nextcloud.tar.bz2 "https://download.nextcloud.com/server/releases/nextcloud-<version>.tar.bz2"
ADD nextcloud.tar.bz2 /var/www/

ADD apcu.config.php /var/www/nextcloud/config/
ADD opcache.php.ini /etc/php5/apache2/conf.d/10-opcache.ini

ENV NEXTCLOUD_DOCUMENTROOT=/var/www/nextcloud
ENV NEXTCLOUD_VOLUMEROOT=/var/nextcloud
ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -sf /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/
#recommondation in https://docs.nextcloud.com/server/9/admin_manual/installation/source_installation.html#apache-configuration-label
RUN /usr/sbin/a2enmod headers
# already enabled RUN /usr/sbin/a2enmod env
# already enabled RUN /usr/sbin/a2enmod dir
# already enabled RUN /usr/sbin/a2enmod mime
CMD ["bash", "-c", "/etc/init.d/apache2 restart"]
ADD bootstrap.sh /nextcloud.sh
RUN chmod 0700 /nextcloud.sh
RUN chmod 0750 /var/www/nextcloud/occ
CMD ["bash", "nextcloud.sh"]

