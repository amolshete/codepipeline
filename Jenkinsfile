pipeline{
    agent any
    tools {
        maven 'maven-3.8.6'
    }
    environment {
        DOCKER_IMAGE_NAME = "amol1996/springapp-4734348"
        DOCKER_IMAGE_TAG = "latest"
    }
    stages{
        stage("build with maven"){
            steps{
                echo "========executing build with maven========"
                sh "mvn clean install"
                }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "======== build with maven executed successfully========"
                }
                failure{
                    echo "======== build with maven execution failed========"
                }
            }
        }
        stage("docker build"){
                steps{
                    echo "========executing docker build========"
                    sh "docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG ."
                }
            }
        stage("docker push"){
            steps{
                echo "========executing docker push========"
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh "docker push $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"
                }
            }
        }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}