pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "saidoc540"
        IMAGE_NAME = "trend-app"
        IMAGE_TAG = "latest"
        GIT_REPO = "https://github.com/Bhuvisai22/Trend.git"
    }

    stages {

        stage("Checkout Code") {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    sh "docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage("Login to DockerHub") {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-cred',
                        usernameVariable: 'USERNAME',
                        passwordVariable: 'PASSWORD'
                    )]) {
                        sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                    }
                }
            }
        }

        stage("Push
