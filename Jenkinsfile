
pipeline {
    agent any
    tools {
        terraform 'terraform-10'
    }
    
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Maverick1711/e-learning-repo.git'
            }
        }
        stage('VPC Directory') {
            steps {
                dir('modules/vpc') {
                    echo 'Initializing vpc dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('ECS Directory') {
            steps {
                dir('modules/ecs') {
                    echo 'Initializing ecs dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('ROUTE 53 Directory') {
            steps {
                dir('modules/route 53') {
                    echo 'Initializing route-53 dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('POSTGRE_RDS Directory') {
            steps {
                dir('modules/postgre_RDS') {
                    echo 'Initializing postgre_RDS dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('ACM Directory') {
            steps {
                dir('modules/acm') {
                    echo 'Initializing ACM dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('Change Directory') {
            steps {
                dir("./${environment}") {
                    timeout(time: 10, unit: 'MINUTES') {
                        echo "Welcome to ${environment} Enviroment"
                        sh 'ls'
                        sh 'pwd'
                        sh 'terraform init'
                        echo "terraform is performing ==> ${action} action"
                        sh "terraform ${action} -var-file='terraform.tfvars' -auto-approve"

                    }
                    
                }
            }
        }
        
    }
}
