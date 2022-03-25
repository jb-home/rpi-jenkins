#!/bin/bash
VERSIONS=version.properties
(
  echo JENKINS_VERSION=\"$(curl --silent https://updates.jenkins.io/current/latestCore.txt)\"
) | tee $VERSIONS
