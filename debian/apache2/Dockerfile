############################################################
# Dockerfile to build owncloud container images
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Install APACHE2 on micro best of my knowledge
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
#Sqlite packages installation:
RUN apt-get install -y sqlite3

#CURL packages installation:
RUN apt-get install -y curl

#Apache2 webserver packages installation:
RUN apt-get install -y apache2 libapache2-mod-php5 nano

#based on https://github.com/jacksoncage/apache-docker/blob/master/Dockerfile
ADD ./001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/
# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www

# FIX: "apache2: could-not-reliably-determine-the-servers-fully-qualified-domain-name"
# based on http://aslamnajeebdeen.com/blog/how-to-fix-apache-could-not-reliably-determine-the-servers-fully-qualified-domain-name-using-127011-for-servername-error-on-ubuntu
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf
# based on http://askubuntu.com/questions/256013/could-not-reliably-determine-the-servers-fully-qualified-domain-name
RUN echo "ServerName localhost" >> /etc/apache2/conf.d/fqdn
#Php5 packages installation:
#RUN apt-get install -y php5-gd php5-json php5-sqlite php5-curl php5-intl php5-mcrypt php5-imagick php-net-ftp php5-gmp php-apc php5-apcu php5-imagick
#create key
#RUN /usr/bin/openssl genrsa -out /etc/ssl/private/apache.key 2048
#http://www.flatmtn.com/article/setting-openssl-create-certificates
#RUN curl -L https://raw.githubusercontent.com/cmaoling/docker4micro/master/apache2/sslCertDefaults | /usr/bin/openssl req -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt
ADD host.key /etc/ssl/private/apache.key
ADD host.crt /etc/ssl/certs/apache.crt
RUN /usr/sbin/a2enmod ssl
RUN /usr/sbin/a2enmod rewrite
RUN /usr/sbin/a2dissite default
RUN /usr/sbin/a2dissite default-ssl
#RUN /usr/sbin/a2ensite default-ssl.conf
RUN /usr/sbin/service apache2 force-reload 
RUN /usr/sbin/service apache2 restart
RUN /usr/sbin/update-rc.d apache2 enable
VOLUME /var/www
EXPOSE 443
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]

##################### INSTALLATION END #####################
