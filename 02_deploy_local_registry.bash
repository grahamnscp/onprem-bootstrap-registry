#!/bin/bash

# on edge server running docker daemon:

#docker pull registry:2.7.1
#docker save registry:2.7.1 > registry_image.tar


# on bootstrap server:

# note: you will need to add the registry name to the insecure registry list
# docker daemon config as the image does not have an SSL server
# /etc/docker/daemon.json:
#{
#  "storage-driver": "overlay2",
#  "storage-opts": ["overlay2.override_kernel_check=true"],
#  "log-driver": "journald",
#  "log-level": "info",
#  "log-opts": {
#    "tag":"{{.ImageName}}/{{.Name}}/{{.ID}}"
#  },
#  "insecure-registries":["bootstrap.gkvop.mesoslab.io:5000"]
#}
# and restart docker: sudo systemctl restart docker

#docker load < registry_image.tar
docker run -d -p 5000:5000 --restart always --name registry registry:2.7.1
