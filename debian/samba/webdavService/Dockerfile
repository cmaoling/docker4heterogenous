############################################################
# Dockerfile to build a webdav link within a docker container
# container has to be called w/ --privilege option to enable mount
# provide as WEBDAV the server to connect to
# link target volume with /webdav volume in container
# secrets may be shared from host by providing a "secret" file in the target mounting directory
# sample call: "docker run -d --privilege -v /home/user/webdav:/webdav <image> 
# sample secret file: <your server ID> <your password on WEBDAV server>
# t-online: https://webdav.mediencenter.t-online.de 
# GMX: https://mediacenter.gmx.net
# 1und1: https://webdav.office.1und1.de
#
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ####################### example call: docker run --privilege -t colinas/webdav
RUN apt-get update
ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get -y install davfs2
ENV WEBDAV_CONF /webdav-conf
#RUN ln -s /var/lib/samba /webdav-conf
VOLUME /webdav-conf
ENV WEBDAV_ROOT /webdav
ADD start_webdav.sh /start_webdav.sh
RUN chmod 0755 /start_webdav.sh
ENTRYPOINT exec /start_webdav.sh
