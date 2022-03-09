pipeline {
    agent any
    environment {
        registryCredential = 'hub.docker.com'
        IMAGE_NAME = 'jbhome/rpi-jenkins'
        IMAGE_TAG = "ci-jenkins-$BRANCH_NAME"
        CONTAINER_NAME = "$BUILD_TAG"
    }
    stages {
        stage('Get Jenkins & Docker') {
            steps {
                sh './get-jenkins-docker.sh'
            }
        }
        stage('Build') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }
        stage('Test & get versions') {
            steps {
                sh "docker run -d --rm --name $CONTAINER_NAME $IMAGE_NAME:$IMAGE_TAG"
                echo 'Sleep to allow Jenkins to start'
                sh 'date'
                sleep 120
                sh "./get-versions.sh $CONTAINER_NAME"	// Get jenkins, java, docker version in started container, store in version.properties
                load './version.properties'
                // echo "$JENKINS_VERSION"
                // echo "$JAVA_VERSION"
                // echo "$DOCKER_VERSION"
                sh 'date'
                sh "docker exec -t $CONTAINER_NAME wget --spider http://localhost:8080 | grep -e connected -e Forbidden"
                sh "time docker stop $CONTAINER_NAME"
            }
        }
        stage('Push') {
            steps {
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION"
                sh "docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$JENKINS_VERSION-$JAVA_VERSION-$DOCKER_VERSION"

                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push('latest')
                        dockerImage.push('$JENKINS_VERSION')
                        dockerImage.push('$JENKINS_VERSION-$JAVA_VERSION')
                        dockerImage.push('$JENKINS_VERSION-$JAVA_VERSION-$DOCKER_VERSION')
                    }
                }

                sh "docker rmi \$(docker images $IMAGE_NAME -q) -f"
            }
        }
    }
    post {
        failure {
            sh "docker rm -f $CONTAINER_NAME"
        }
    }
}
