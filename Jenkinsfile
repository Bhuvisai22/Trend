pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKERHUB_USERNAME = "saidoc540"
        IMAGE_NAME = "trend-app"
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh """
                    docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest .
                    """
                }
            }
        }

        stage('DockerHub Login') {
            steps {
                script {
                    sh """
                    echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub..."
                    sh """
                    docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    echo "Deploying to AWS EKS..."
                    
                    sh """
                    aws eks update-kubeconfig --name trend-cluster --region ${AWS_DEFAULT_REGION}

                    kubectl set image deployment/trend-deployment trend-container=${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest

                    kubectl rollout status deployment/trend-deployment
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
