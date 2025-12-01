// Jenkinsfile for the Trend repository

pipeline {
    agent any

    environment {
        // Define environment variables for Docker image name and tag
        DOCKER_IMAGE_NAME = 'your-dockerhub-username/trend-app'
        DOCKER_IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
        
        // AWS credentials are bound here using the 'withCredentials' step later
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        
        // DockerHub credentials are also bound later
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/Bhuvisai22/Trend.git'
                echo "Code checkout completed."
            }
        }

        stage('Configure AWS CLI') {
            steps {
                echo "Configuring AWS CLI with credentials..."
                withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region us-east-1 # Change region if needed
                        aws sts get-caller-identity # Verify authentication
                    '''
                }
                echo "AWS CLI configured successfully."
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh """
                    docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} .
                """
                echo "Docker image built successfully."
            }
        }

        stage('Login to DockerHub') {
            steps {
                echo "Logging into DockerHub..."
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                    """
                }
                echo "Logged into DockerHub successfully."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to DockerHub..."
                sh """
                    docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                """
                echo "Docker image pushed successfully."
            }
        }

        // Optional: Deploy to AWS (e.g., ECS, EKS)
        // Uncomment and modify this stage based on your deployment needs.
        /*
        stage('Deploy to AWS') {
            steps {
                echo "Deploying to AWS..."
                // Example: Update ECS service
                // sh '''
                //     aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
                // '''
                echo "Deployment to AWS completed."
            }
        }
        */
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
            // Optionally send notifications here
        }
    }
}
