#!/bin/bash

# on edge server running docker daemon
#docker pull registry:2.7.1
#docker save registry:2.7.1 > registry_image.tar

# on bootstrap server
#docker load < registry_image.tar
docker run -d -p 5000:5000 --restart always --name registry registry:2.7.1
