pipeline {
  agent any

  environment {
    IMAGENAME = "jenkins"
    DOCKER_ID = credentials('DOCKER_ID')
    DOCKER_PASSWORD = credentials('DOCKER_PASSWORD')
  }

  stages {
    stage('Init') {
      steps{
        sh "chmod +x ./get-version.sh"
        sh "./get-version.sh"	// Get latest version number and store in version.properties
        load "./version.properties"
        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_ID --password-stdin'
      }
    }
    stage('Build') {
      steps{
        sh 'docker buildx build -t $DOCKER_ID/$IMAGENAME .'
      }
    }
    stage('Publish') {
      steps{
        sh "docker tag $IMAGENAME $IMAGENAME:latest"
        sh "docker tag $IMAGENAME $IMAGENAME:$JENKINS_VERSION"
        sh 'docker buildx build --push --platform linux/arm/v7,linux/arm64,linux/arm/v6,linux/amd64 -t $DOCKER_ID/$IMAGENAME:latest .'
        sh 'docker buildx build --push --platform linux/arm/v7,linux/arm64,linux/arm/v6,linux/amd64 -t $DOCKER_ID/$IMAGENAME:$JENKINS_VERSION .'
      }
    }
    stage('Cleanup') {
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
