############################################################
# Dockerfile to build base OS to be referred later
FROM [user.id]/[parent.repository][parent.tag]
# based on https://github.com/gbraad/dockerfile-dnsmasq-alpine/blob/master/Dockerfile
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
RUN apk --no-cache add dnsmasq

COPY dnsmasq.conf /etc/
COPY resolv.dnsmasq.conf /etc/

COPY dnsmasq.hosts /etc/
# VOLUME /etc/dnsmasq.hosts

EXPOSE 53/udp
EXPOSE 53/tcp

ENTRYPOINT ["dnsmasq", "-k"]
