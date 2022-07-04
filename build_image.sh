#!/bin/bash

# set variables
_VERSION=9.5.8

# build image glpi
docker build -t johann8/glpi:${_VERSION} apache/
_BUILD=$?
if ! [ ${_BUILD} = 0 ]; then
   echo "ERROR: Docker Image build was not successful"
   exit 1
else
   echo "Docker Image build successful"
   docker images -a
fi

#push image to dockerhub
if [ ${_BUILD} = 0 ]; then
   echo "Pushing docker images to dockerhub..."
   docker push johann8/glpi:${_VERSION}
   _PUSH=$?
   docker images -a |grep glpi
fi

#
### build docker contsiner image glpi crond
#
if [ ${_PUSH} = 0 ]; then
   echo "Building container glpi-crond..."
   docker build -t johann8/glpi:${_VERSION}-crond crond/
   _BUILD1=$?
   if ! [ ${_BUILD1} = 0 ]; then
      echo "ERROR: Docker Container Image build was not successful"
      exit 1
   else
      echo "Docker Container Image build successfull"
      docker images -a
      echo "Pushing docker images to dockerhub..."
      docker push johann8/glpi:${_VERSION}-crond
      _PUSH1=$?
   fi
fi

#delete build
if [ ${_PUSH} = 0 ] && [ ${_PUSH1} = 0 ]; then
   echo "Deleting docker images..."
   docker rmi johann8/glpi:${_VERSION}-crond
   #docker images -a
   docker rmi johann8/glpi:${_VERSION}
   #docker images -a
   docker rmi centos:7
   docker images -a
fi
