pipeline {
    agent any

    environment {
        GITHUB_CRED   = credentials('github-token')        // GitHub PAT
        DOCKER_CRED   = credentials('Dockerhub-token')     // DockerHub Token
        DOCKER_REPO   = "saidoc540/trend"                  // Change if needed
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
                sh """
                docker build -t ${DOCKER_REPO}:latest .
                """
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                echo ${DOCKER_CRED_PSW} | docker login -u ${DOCKER_CRED_USR} --password-stdin
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh """
                docker push ${DOCKER_REPO}:latest
                """
            }
        }
    }
}
