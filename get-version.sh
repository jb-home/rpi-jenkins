#!/bin/bash
VERSIONS=version.properties
(
  echo JENKINS_VERSION=\"$(wget -qO - https://updates.jenkins.io/current/latestCore.txt)\"
) | tee $VERSIONS
