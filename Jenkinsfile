pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
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
