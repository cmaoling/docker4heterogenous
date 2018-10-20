############################################################
# Dockerfile to build  images
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Create pagemaster container on micro best of my knowledge
ENV DEBIAN_FRONTEND "noninteractive"
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN apt-get install -y smbclient jq
VOLUME /sambaConnect
ADD sambaConnect /sambaConnect.sh
RUN chmod 0755 /sambaConnect.sh
ENTRYPOINT exec /sambaConnect.sh start /sambaConnect/sambaConnect.json

