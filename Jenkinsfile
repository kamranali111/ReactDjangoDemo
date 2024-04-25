pipeline {
    agent any
    
    environment {
        AWS_EC2_INSTANCE = '184.72.183.24'
        
        DOCKER_HUB_CREDENTIAL_ID = 'DOCKER_HUB_CREDENTIAL_ID'
        DOCKER_IMAGE_NAME = 'kamran111/react_django_demo_app'
        TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/chxtan/react_django_demo_app.git'
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build Docker image locally
                    sh "docker build --no-cache -t $DOCKER_IMAGE_NAME ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDENTIAL_ID, passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                        sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                    }
                    
                    // Tag the Docker image
                    sh "docker tag $DOCKER_IMAGE_NAME:$TAG $DOCKER_IMAGE_NAME"
                    // Push the Docker image to Docker Hub
                    sh "docker push $DOCKER_IMAGE_NAME"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // SSH into the AWS EC2 instance and pull the Docker image
                    sh "ssh -o StrictHostKeyChecking=no -i /home/kamran/aws-key.pem ubuntu@${AWS_EC2_INSTANCE} 'sudo docker pull $DOCKER_IMAGE_NAME:$TAG'"
                    
                    // Run Docker container on the AWS EC2 instance
                    sh "ssh -o StrictHostKeyChecking=no -i /home/kamran/aws-key.pem ubuntu@${AWS_EC2_INSTANCE} 'sudo docker run -p 8001:8001 -d $DOCKER_IMAGE_NAME:$TAG'"
                }
            }
        }
    }
}
