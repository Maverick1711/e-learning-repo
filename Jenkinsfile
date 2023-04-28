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
        stage('POSTGRES_RDS Directory') {
            steps {
                dir('modules/postgres_RDS') {
                    echo 'Initializing postgres_RDS dir'
                    sh 'ls'
                    sh 'pwd'
                    sh 'terraform init'
                }
            }
        }
        // stage('ACM Directory') {
        //     steps {
        //         dir('./modules/acm') {
        //             echo 'Initializing postgres_RDS dir'
        //             sh 'ls'
        //             sh 'pwd'
        //             sh 'terraform init'
        //         }
        //     }
        // }
        stage('Change Directory') {
            steps {
                dir('./dev') {
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
