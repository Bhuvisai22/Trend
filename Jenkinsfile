pipeline {
    agent any

    environment {
        IMAGE_NAME = "saidoc540/trend-app"
        TAG = "latest"   // you can change this
        DOCKERHUB_CREDENTIALS = "dockerhub-cred"   // Jenkins credential ID
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Bhuvisai22/Trend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${TAG} .
                    """
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh """
                    echo "Logging into DockerHub..."
                    echo "$PASS" | docker login -u "$USER" --password-stdin
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh """
                    docker push ${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }
    }
}
