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

# based on https://www.bennetrichter.de/anleitungen/apache2-php7-mysql-phpmyadmin/
RUN apt-get update && apt-get install php7.0 php7.0-apcu php7.0-cli php7.0-curl php7.0-gd php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-readline php7.0-sqlite3 php7.0-xml php7.0-xsl php7.0-zip php7.0-bz2 libapache2-mod-php7.0 -y
#RUN DEBIAN_FRONTEND=noninteractive rm -rf /usr/src/nextcloud/updater

VOLUME /var/nextcloud
#curl -fsSL -o nextcloud.tar.bz2 "https://download.nextcloud.com/server/releases/nextcloud-<version>.tar.bz2"
ADD nextcloud.tar.bz2 /var/www/
