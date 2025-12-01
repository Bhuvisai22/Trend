pipeline {
    agent any

    environment {
        GITHUB_CRED   = credentials('github-token')        
        DOCKER_CRED   = credentials('Dockerhub-token')      
        DOCKER_REPO   = "saidoc540/trend"                  
    }

    stages {

        stage('Clone Repository') {
            steps {
                git(
                    url: 'https://github.com/Bhuvisai22/Trend.git',
                    branch: 'main',
                    credentialsId: 'github-token'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                docker build -t %DOCKER_REPO%:latest .
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

        stage('Push to DockerHub') {
            steps {
                bat """
                docker push %DOCKER_REPO%:latest
                """
            }
        }
    }
}
