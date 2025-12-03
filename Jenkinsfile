pipeline {
    agent any

    environment {
        IMAGE_NAME = "saidoc540/trend-app"
        DOCKERHUB_CREDENTIALS = "dockerhub-cred"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/Bhuvisai22/Trend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${env.BRANCH_NAME} ."
                }
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
                script {
                    sh "docker push ${IMAGE_NAME}:${env.BRANCH_NAME}"
                }
            }
        }

        stage('Deploy on EC2') {
            when {
                branch 'master'
            }
            steps {
                script {
                    // Replace with your EC2 SSH details
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@<EC2_PUBLIC_IP> '
                      docker stop trend-app || true &&
                      docker rm trend-app || true &&
                      docker run -d -p 80:80 --name trend-app ${IMAGE_NAME}:master
                    '
                    """
                }
            }
        }
    }
}
