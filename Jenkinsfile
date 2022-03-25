pipeline {
  agent any
  environment {
    imagename = "jbhome/rpi-jenkins"
    registryCredential = 'hub.docker.com'
    dockerImage = ''
  }
  stages {
    stage('Building image') {
      steps{
        sh "chmod +x ./get-version.sh"
        sh "./get-version.sh"	// Get latest version number and store in version.properties
        load "./version.properties"
        script {
          dockerImage = docker.build imagename + ":$JENKINS_VERSION"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        sh "docker tag $imagename:$JENKINS_VERSION $imagename:latest"
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi debian:bullseye-slim"
        catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS')
        {
          sh "docker rmi \$(docker images -f dangling=true -q)"
        }
      }
    }
  }
}
