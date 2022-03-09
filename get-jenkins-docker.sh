#!/bin/bash

# get jenkins
JENKINS_VERSION=2.319.3
wget --timestamping --no-verbose http://mirrors.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war

# get docker binaries
DOCKER_VERSION=20.10.12
wget --timestamping --no-verbose https://download.docker.com/linux/static/stable/armhf/docker-$DOCKER_VERSION.tgz
tar xzvf docker-$DOCKER_VERSION.tgz --strip 1 docker/docker
