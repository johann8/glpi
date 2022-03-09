#!/bin/bash

# set variables
_VERSION=1.0.1

# create build
docker build -t johann8/glpi:${_VERSION} .
_BUILD=$?
if ! [ ${_BUILD} = 0 ]; then
   echo "ERROR: Docker Image build was not successful"
   exit 1
else
   echo "Docker Image build successful"
   docker images -a
   docker tag johann8/glpi:${_VERSION} johann8/glpi:latest
fi

exit 0

#push image to dockerhub
if [ ${_BUILD} = 0 ]; then
   echo "Pushing docker images to dockerhub..."
   docker push johann8/glpi:latest
   _PUSH=$?
   docker push johann8/glpi:${_VERSION}
   _PUSH1=$?
   docker images -a |grep glpi
fi

#delete build
if [ ${_PUSH} = 0 ] && [ ${_PUSH1} = 0 ]; then
   echo "Deleting docker images..."
   docker rmi johann8/glpi:latest
   #docker images -a
   docker rmi johann8/glpi:${_VERSION}
   #docker images -a
   docker rmi centos:centos7
   docker images -a
fi
