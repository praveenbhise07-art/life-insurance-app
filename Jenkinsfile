pipeline {
    agent any

    environment {
        // Application & Azure Settings
        APP_NAME        = 'life-insurance-app'
        ACR_NAME        = 'apexshieldacrdev' // Replace 'yourACRName' with your actual ACR name
        ACR_REGISTRY    = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME      = "${ACR_REGISTRY}/${APP_NAME}"
        IMAGE_TAG       = "${BUILD_NUMBER}"
        
        // Credentials configured in Jenkins
        SNYK_TOKEN_ID   = 'snyk-token'
        SONAR_TOKEN_ID  = 'sonarqube-token'
        AZURE_CREDS_ID  = 'azure-credentials-id'
        
        // SonarQube Host (Adjust IP/Port if running elsewhere)
        SONAR_HOST_URL  = 'http://localhost:9000'
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('2. Dependencies & Snyk Security Scan') {
            steps {
                sh 'npm install'
                withCredentials([string(credentialsId: env.SNYK_TOKEN_ID, variable: 'SNYK_TOKEN')]) {
                    sh 'snyk auth $SNYK_TOKEN'
                    sh 'snyk test || true' 
                }
            }
        }

        stage('3. SonarQube Code Quality Analysis') {
            steps {
                withCredentials([string(credentialsId: env.SONAR_TOKEN_ID, variable: 'SONAR_TOKEN')]) {
                    sh """
                        npx sonar-scanner \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.token=\$SONAR_TOKEN \
                          -Dsonar.projectKey=${APP_NAME} \
                          -Dsonar.projectName="${APP_NAME}" \
                          -Dsonar.sources=. \
                          -Dsonar.exclusions=node_modules/**,coverage/**
                    """
                }
            }
        }

        stage('4. Trivy File System Scan') {
            steps {
                sh 'trivy fs .'
            }
        }

        stage('5. Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('6. Trivy Container Image Scan') {
            steps {
                sh 'trivy image ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }

        stage('7. Push Docker Image to ACR') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDS_ID)]) {
                    sh 'az acr login --name ${ACR_NAME}'
                    sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
                    sh 'docker push ${IMAGE_NAME}:latest'
                }
            }
        }

        stage('8. Deploy to AKS via Helm') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDS_ID)]) {
                    sh """
                        az aks get-credentials --resource-group rg-apexshield-dev --name aks-apexshield-dev
                        
                        helm upgrade --install ${APP_NAME} ./helm \
                          --namespace default \
                          --set image.repository=${IMAGE_NAME} \
                          --set image.tag=${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f'
        }
        success {
            echo "Pipeline completed successfully! Deployed version ${IMAGE_TAG}."
        }
        failure {
            echo "Pipeline execution failed. Please check logs above."
        }
    }
}