############################################################
# Dockerfile to build firefox container images
# Based on armhf-debian
FROM [user.id]/[parent.repository][parent.tag]

###########################################################
# File Author / Maintainer
MAINTAINER [user.name] "[user.email]"
################## BEGIN INSTALLATION ######################
RUN apt-get update
RUN apt-get install -y codelite codelite-plugins

RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    #echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    #chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/bin/codelite
