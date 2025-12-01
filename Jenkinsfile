pipeline {
    agent any

    environment {
        APP_NAME       = 'trend-app'
        DOCKERHUB_USER = 'your-dockerhub-username'  // ← UPDATE THIS
        IMAGE_TAG      = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        KUBECONFIG     = credentials('kubeconfig-eks')  // Jenkins credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def image = "${env.DOCKERHUB_USER}/${env.APP_NAME}:${env.IMAGE_TAG}"
                    sh "docker build -t ${image} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    script {
                        def image = "${env.DOCKERHUB_USER}/${env.APP_NAME}:${env.IMAGE_TAG}"
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${image}
                        """
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withEnv(["KUBECONFIG=${env.WORKSPACE}/kubeconfig"]) {
                    sh "mkdir -p ~/.kube"
                    sh "echo '${env.KUBECONFIG}' > ~/.kube/config"
                    sh "chmod 600 ~/.kube/config"

                    // Example: update deployment image
                    sh """
                        kubectl set image deployment/${env.APP_NAME} \
                        ${env.APP_NAME}=${env.DOCKERHUB_USER}/${env.APP_NAME}:${env.IMAGE_TAG} \
                        --namespace default
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
