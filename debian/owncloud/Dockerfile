############################################################
# Dockerfile to build owncloud container images
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Install owncloud on micro best of my knowledge
ADD deb.list /etc/apt/sources.list.d/owncloud.list 
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN /bin/bash -c "curl http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/Release.key | apt-key add - "
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes owncloud
# Expose ports.
EXPOSE 80
