############################################################
# Dockerfile to build owncloud container images
# Based on armhf-debian
FROM colinas/apache2

###########################################################
# File Author / Maintainer
MAINTAINER Colinas Maoling "colinas.maoling@t-online.de"
################## BEGIN INSTALLATION ######################
# Install owncloud on micro best of my knowledge
ADD deb.list /etc/apt/sources.list.d/owncloud.list 
ENV DEBIAN_FRONTEND noninteractive
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN /bin/bash -c "curl http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/Release.key | apt-key add - "
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes owncloud
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5-ldap
VOLUME /var/owncloud
ENV OWNCLOUD_DOCUMENTROOT=/var/www/owncloud
ENV OWNCLOUD_VOLUMEROOT=/var/owncloud
ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -sf /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/
RUN /etc/init.d/apache2 restart
ADD bootstrap.sh /owncloud.sh
RUN chmod 0755 /owncloud.sh
CMD ["bash", "owncloud.sh"]

