###########################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM colinas/apache2

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Install owncloud on micro best of my knowledge
ENV DEBIAN_FRONTEND noninteractive
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
ADD deb.list /etc/apt/sources.list.d/owncloud.list

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN /bin/bash -c "curl https://download.owncloud.org/download/repositories/stable/Debian_7.0/Release.key | apt-key add - "

# based on https://www.stewright.me/2016/03/turn-raspberry-pi-3-php-7-powered-web-server/
RUN /bin/bash -c "gpg --keyserver pgpkeys.mit.edu --recv-key CCD91D6111A06851"
RUN /bin/bash -c "gpg --armor --export CCD91D6111A06851 | apt-key add -"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get --yes autoremove

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes owncloud-files owncloud
RUN DEBIAN_FRONTEND=noninteractive apt-get --purge --yes remove $(dpkg --list | grep php | awk '/^ii/{ print $2}')

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-curl php7.0-xml php7.0-mbstring php7.0-gd php7.0-json php7.0-mcrypt php7.0-mysql
# php7 unneded: php7.0-apcu php7.0-zip php7.0-imap php7.0-opcache php7.0-xmlrp

VOLUME /var/owncloud
ENV OWNCLOUD_DOCUMENTROOT=/var/www/owncloud
ENV OWNCLOUD_VOLUMEROOT=/var/owncloud
ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -sf /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/
CMD ["bash", "-c", "/etc/init.d/apache2 restart"]
ADD bootstrap.sh /owncloud.sh
RUN chmod 0755 /owncloud.sh
CMD ["bash", "owncloud.sh"]

