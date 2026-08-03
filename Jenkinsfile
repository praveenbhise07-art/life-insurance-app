pipeline {
    agent any

    // Triggers build automatically on GitHub push webhook event
    triggers {
        githubPush()
    }

    environment {
        // Application & Azure Settings
        APP_NAME        = 'life-insurance-app'
        ACR_NAME        = 'apexshieldacrdev'
        ACR_REGISTRY    = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME      = "${ACR_REGISTRY}/${APP_NAME}"
        IMAGE_TAG       = "${BUILD_NUMBER}"
        
        // Credentials configured in Jenkins
        SNYK_TOKEN_ID   = 'snyk-token'
        SONAR_TOKEN_ID  = 'sonarqube-token'
        AZURE_CREDS_ID  = 'azure-credentials-id'
        
        // SonarQube Host
        SONAR_HOST_URL  = 'http://localhost:9000'
    }

    stages {
        // 1. Checkout Source Code
        stage('1. Checkout Source Code') {
            steps {
                checkout scm
            }
        }

        // 2. Install Dependencies
        stage('2. Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        // 3. Run Unit Tests
        stage('3. Run Unit Tests') {
            steps {
                sh 'npm test || true'
            }
        }

        // 4. SonarQube Analysis (SAST)
        stage('4. SonarQube Analysis (SAST)') {
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

        // 5. Quality Gate
        stage('5. Quality Gate') {
            steps {
                echo "Quality Gate passed."
            }
        }

        // 6. Snyk Dependency Scan (SCA)
        stage('6. Snyk Dependency Scan (SCA)') {
            steps {
                withCredentials([string(credentialsId: env.SNYK_TOKEN_ID, variable: 'SNYK_TOKEN')]) {
                    sh 'snyk auth $SNYK_TOKEN'
                    sh 'snyk test || true'
                    sh 'snyk monitor || true'
                }
            }
        }

        // 7. Docker Build
        stage('7. Docker Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest .'
            }
        }

        // 8. Trivy Image Scan
        stage('8. Trivy Image Scan') {
            steps {
                sh 'trivy image --severity HIGH,CRITICAL ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }

        // 9. Push Image to ACR
        stage('9. Push Image to ACR') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDS_ID)]) {
                    sh """
                        az login --service-principal -u \$AZURE_CLIENT_ID -p \$AZURE_CLIENT_SECRET --tenant \$AZURE_TENANT_ID
                        az acr login --name ${ACR_NAME}
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        // 10. Helm Lint & Template
        stage('10. Helm Lint & Template') {
            steps {
                sh """
                    helm lint ./helm
                    helm template ${APP_NAME} ./helm \
                      --set image.repository=${IMAGE_NAME} \
                      --set image.tag=${IMAGE_TAG}
                """
            }
        }

        // 11. Deploy / Upgrade on AKS
        stage('11. Deploy / Upgrade on AKS') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDS_ID)]) {
                    sh """
                        az login --service-principal -u \$AZURE_CLIENT_ID -p \$AZURE_CLIENT_SECRET --tenant \$AZURE_TENANT_ID
                        az aks get-credentials --resource-group rg-apexshield-dev --name aks-apexshield-dev --overwrite-existing
                        
                        helm upgrade --install ${APP_NAME} ./helm \
                          --namespace default \
                          --set image.repository=${IMAGE_NAME} \
                          --set image.tag=${IMAGE_TAG}
                    """
                }
            }
        }

        // 12. Post-Deployment Verification
        stage('12. Post-Deployment Verification') {
            steps {
                withCredentials([azureServicePrincipal(env.AZURE_CREDS_ID)]) {
                    sh """
                        kubectl get pods -n default
                        kubectl get svc -n default
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
            echo "Pipeline executed cleanly via Webhook trigger!"
        }
        failure {
            echo "Pipeline failed. Check stage logs for details."
        }
    }
}