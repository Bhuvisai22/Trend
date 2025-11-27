pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('saidoc540')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        IMAGE_TAG = "${DOCKERHUB_CREDS_USR}/trend-app:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build React App') {
            steps {
                sh 'npm ci'
                sh 'npm run build'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    docker.build(IMAGE_TAG, ".")
                    docker.withRegistry('https://registry.hub.docker.com', 'saidoc540') {
                        docker.image(IMAGE_TAG).push()
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    # Install kubectl
                    curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.9/2024-05-28/bin/linux/amd64/kubectl
                    chmod +x kubectl
                    sudo mv kubectl /usr/local/bin/

                    # Configure AWS CLI & kubectl
                    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                    aws configure set region ap-south-1
                    aws eks update-kubeconfig --name trend-app-eks --region ap-south-1

                    # Update image in deployment
                    kubectl set image deployment/trend-app nginx='$IMAGE_TAG'

                    # Wait for rollout
                    kubectl rollout status deployment/trend-app --timeout=120s
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! App is live."
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
