pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('azure-client-id')
        ARM_CLIENT_SECRET   = credentials('azure-client-secret')
        ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        ARM_TENANT_ID       = credentials('azure-tenant-id')
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Azure Login') {
            steps {
                sh '''
                  az login --service-principal \
                    --username $ARM_CLIENT_ID \
                    --password $ARM_CLIENT_SECRET \
                    --tenant $ARM_TENANT_ID

                  az account set --subscription $ARM_SUBSCRIPTION_ID
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -reconfigure'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        success {
            echo '✅ Terraform pipeline completed successfully'
        }
        failure {
            echo '❌ Terraform pipeline failed'
        }
    }
}
