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
        script {
          dockerImage = docker.build imagename
        }
      }
    }
    stage('Deploy Image') {
      steps{
        sh "docker tag $imagename $imagename:latest"
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push('latest')
          }
        }
      }
    }
  }
}
