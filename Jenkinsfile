pipeline {
    agent any

    environment {
        GIT_REPO = "https://github.com/Bhuvisai22/Trend.git"
        DOCKER_IMAGE = "saidoc540/trend-app"
        GITHUB_CRED = credentials('github-token')
        DOCKER_CRED = credentials('Dockerhub-token')
    }

    stages {
        
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
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

        stage('Push Docker Image') {
            steps {
                bat """
                docker push %DOCKER_IMAGE%:latest
                docker push %DOCKER_IMAGE%:${BUILD_NUMBER}
                """
            }
        }
    }
}
