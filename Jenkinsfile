pipeline {
    agent any

    environment {
        REPO_URL = "https://github.com/Bhuvisai22/Trend.git"
        BRANCH = "main"
        IMAGE_NAME = "saidoc540/trend-app"
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
                    def IMAGE_TAG = "${env.BUILD_NUMBER}"
                    env.IMAGE_TAG = IMAGE_TAG
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
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    sh """
                    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                    """
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
