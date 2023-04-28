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
                dir('vpc') {
                    echo 'Initializing vpc dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('ECS Directory') {
            steps {
                dir('./ecs') {
                    echo 'Initializing ecs dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('ROUTE 53 Directory') {
            steps {
                dir('./route 53') {
                    echo 'Initializing route-53 dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        stage('POSTGRES_RDS Directory') {
            steps {
                dir('./postgres_RDS') {
                    echo 'Initializing postgres_RDS dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        // stage('ACM Directory') {
        //     steps {
        //         dir('./acm') {
        //             echo 'Initializing postgres_RDS dir'
        //             sh 'ls'
        //             sh 'pwd'
        //             sh 'terraform init'
        //         }
        //     }
        // }
        stage('Change Directory') {
            steps {
                dir('../../dev') {
                    echo 'Welcome to Dev Enviroment'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                    sh "terraform apply -var-file='terraform.tfvars' -auto-approve"
                }
            }
        }
        
    }
}