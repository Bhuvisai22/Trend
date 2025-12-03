pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Bhuvisai22/Trend.git"
        BRANCH = "main"
        IMAGE_NAME = "yourdockerhubusername/trend-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Cloning branch: ${BRANCH}"
                git branch: BRANCH, url: REPO_URL
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    IMAGE_TAG = "${env.BUILD_NUMBER}"
                    echo "Image tag: ${IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh """
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Build completed successfully!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
