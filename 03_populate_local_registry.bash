#!/bin/bash

#konvoy cluster.yaml local registry setting:
#kind: ClusterConfiguration
#apiVersion: konvoy.mesosphere.io/v1alpha1
#spec:
#  imageRegistries:
#    - server: https://myregistry.fqdn:5000
#      username: "myuser"
#      password: "mypassword"
#      default: true


REGISTRY_FQDN=registry.glocaldomain:5000

#read image data from images.json in cwd
COUNT=0
for REG in `grep -Eo '"registry":.*?[^\\]",' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'`
do
  COUNT=$(($COUNT+1))
  REG_NAMES[$COUNT]=$REG
done

COUNT=0
for IMG in `grep -Eo '"image":.*?[^\\]",' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'`
do
  COUNT=$(($COUNT+1))
  IMG_NAMES[$COUNT]=$IMG
done

COUNT=0
for TAG in `grep -Eo '"tag":.*?[^\\]*' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'`
do
  COUNT=$(($COUNT+1))
  TAG_NAMES[$COUNT]=$TAG
  IMAGE_LIST[$COUNT]=${REG_NAMES[$COUNT]}/${IMG_NAMES[$COUNT]}:$TAG
done
NUM_IMAGES=$COUNT


#Tag each image and push to local registry
for (( COUNT=1; COUNT<=$NUM_IMAGES; COUNT++ ))
do
  THIS_IMG=${IMAGE_LIST[$COUNT]}
  echo processing image[$COUNT]: $THIS_IMG

  docker tag $THIS_IMG $REGISTRY_FQDN/${IMG_NAMES[$COUNT]}:${TAG_NAMES[$COUNT]}
  RET_STAT=$?
  if [ "$RET_STAT" != "0" ]
  then
    echo Error, tag return status: $RET_STAT
  else
    docker push $REGISTRY_FQDN/${IMG_NAMES[$COUNT]}:${TAG_NAMES[$COUNT]}
    RET_STAT=$?; if [ "$RET_STAT" != "0" ]; then   echo Error, push return status: $RET_STAT; fi
  fi
done

