pipeline {
    agent any

    environment {
        IMAGE_NAME = "saidoc540/trend-app"
        DOCKERHUB_CREDENTIALS = "dockerhub-cred"
    }

    stages {

        stage('Clone Repository') {
            steps {
                script {
                    BRANCH = env.GIT_BRANCH ?: "main"
                    echo "Building branch: ${BRANCH}"
                    git branch: BRANCH, url: 'https://github.com/Bhuvisai22/Trend.git'
                }
            }
        }

        stage('Set Image Tag') {
            steps {
                script {
                    COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    IMAGE_TAG = "${BRANCH}-${COMMIT_HASH}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }
}
