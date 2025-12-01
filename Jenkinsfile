pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "saidoc540"
        GIT_USER = "Bhuvisai22"
        IMAGE_NAME = "trend-app"   // change if needed
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: "https://github.com/${Bhuvisai22}/${trend-app}.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKERHUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo $PASSWORD | docker login -u $USERNAME --password-stdin"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh """
                    docker rm -f ${IMAGE_NAME} || true
                    docker pull ${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}
                    docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${DOCKERHUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
    }
}
