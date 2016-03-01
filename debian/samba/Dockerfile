############################################################
# Dockerfile to build  images
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
ENV DEBIAN_FRONTEND "noninteractive"
ENV USERS smbuser
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN apt-get install -y samba-common samba gettext
# Ports: https://wiki.samba.org/index.php/Samba_port_usage
#NetBIOS Name Service   137     udp
#NetBIOS Datagram       138     udp
#NetBIOS Session        139     tcp
#(LDAP  389     tcp/udp)
#SMB over TCP   445     tcp
EXPOSE 137
EXPOSE 138
EXPOSE 139
EXPOSE 445

ADD share.tmpl /share.tmpl
VOLUME /srv/samba/share
RUN ls -la /etc/samba/smb.conf 
RUN testparm -s /etc/samba/smb.conf > /etc/samba/smb.conf

ADD start.sh /start.sh
RUN chmod 0755 /start.sh
ENTRYPOINT exec /start.sh
