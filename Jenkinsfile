pipeline {
    agent any

    environment {
        // Git
        GIT_REPO = "https://github.com/Bhuvisai22/Trend.git"

        // Docker
        DOCKER_IMAGE = "saidoc540/trend-app"
        DOCKER_CRED = credentials('saidoc540')

        // AWS (optional for EKS deployment)
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'Github',
                    url: "${GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                docker build -t %DOCKER_IMAGE%:latest .
                docker tag %DOCKER_IMAGE%:latest %DOCKER_IMAGE%:${BUILD_NUMBER}
                """
            }
        }

        stage('Docker Login') {
            steps {
                bat """
                echo %DOCKER_CRED_PSW% | docker login -u %DOCKER_CRED_USR% --password-stdin
                """
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                bat """
                docker push %DOCKER_IMAGE%:latest
                docker pu
