#!/bin/bash

#grep -Eo '"registry":.*?[^\\]",' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'
#grep -Eo '"image":.*?[^\\]",' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'
#grep -Eo '"tag":.*?[^\\]*' images.json|sed 's/\"//g'|sed 's/\,//g'|awk '{print $2}'

# read image data from images.json in cwd and populate arrays
# note: this will take over an hour as will pull down 5G of data and some registries are slower than others
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
  IMAGE_LIST[$COUNT]=${REG_NAMES[$COUNT]}/${IMG_NAMES[$COUNT]}:$TAG
done
NUM_IMAGES=$COUNT


for (( COUNT=1; COUNT<=$NUM_IMAGES; COUNT++ ))
do
  IMG_NAME=${IMAGE_LIST[$COUNT]}
  echo downloading image: $IMG_NAME
  docker pull $IMG_NAME
done

# include a copy of the docker registry image in the export..
docker pull registry:2.7.1


# Move images by exporting / importing to near registry server location
# note: this is around 5.2GB file
echo docker save $(docker images -q) -o registry_images.tar
# docker load < registry_images.tar

