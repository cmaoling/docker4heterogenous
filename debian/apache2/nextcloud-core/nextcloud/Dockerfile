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

ADD apcu.config.php /var/www/nextcloud/config/
ADD opcache.php.ini /etc/php/7.0/apache2/conf.d/10-opcache.ini

ENV NEXTCLOUD_DOCUMENTROOT=/var/www/nextcloud
ENV NEXTCLOUD_VOLUMEROOT=/var/nextcloud
RUN rm /etc/apache2/sites-enabled/001-docker.conf
ADD ./001-nextcloud.conf /etc/apache2/sites-available/
RUN ln -sf /etc/apache2/sites-available/001-nextcloud.conf /etc/apache2/sites-enabled/
#recommondation in https://docs.nextcloud.com/server/9/admin_manual/installation/source_installation.html#apache-configuration-label
ADD host.key /etc/ssl/private/apache.key
ADD host.crt /etc/ssl/certs/apache.crt
# already enabled RUN /usr/sbin/a2enmod env
# already enabled RUN /usr/sbin/a2enmod dir
# already enabled RUN /usr/sbin/a2enmod mime
RUN ln -sf /var/www/ca.pem /var/www/html
CMD ["bash", "-c", "/usr/sbin/apache2ctl restart"]
ADD bootstrap.sh /nextcloud.sh
RUN chmod 0700 /nextcloud.sh
ADD fixRights.sh /nextcloud-fixRights.sh
RUN chmod 0700 /nextcloud-fixRights.sh
RUN echo "========================" >>  ${APACHE_LOG_DIR}/access.log
RUN echo "========================" >>  ${APACHE_LOG_DIR}/error.log 
CMD ["bash", "nextcloud.sh"]
