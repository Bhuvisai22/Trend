pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub'
        IMAGE_NAME = "saidoc540/trend-app"
        TAG = "latest"     // change to your tag
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
                script {
                    sh """
                    echo "Logging into DockerHub..."
                    docker login -u ${params.DOCKER_USER} -p ${params.DOCKER_PASS}
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
