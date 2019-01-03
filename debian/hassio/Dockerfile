############################################################
# Dockerfile to build owncloud container images
FROM [user.id]/[parent.repository][parent.tag]
###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
# Install Hass.io on micro based on  https://www.home-assistant.io/hassio/installation/
RUN /bin/bash -c "apt-get update && apt-get upgrade -y && apt-get clean && apt-get autoremove"
#Sqlite, CURL, APACHE2 and NANO packages installation:
RUN apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat software-properties-common \
nano

CMD ["bash", "-c", "curl -sL https://raw.githubusercontent.com/home-assistant/hassio-build/master/install/hassio_install | bash -s" ]

##################### INSTALLATION END #####################

