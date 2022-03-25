pipeline {
    agent any
    environment {
        registryCredential = 'hub.docker.com'
        IMAGE_NAME = 'jbhome/rpi-jenkins'
        IMAGE_TAG = "latest"
    }
    stages {
        stage('Build') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }
        stage('Push') {
            steps {
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"

                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
