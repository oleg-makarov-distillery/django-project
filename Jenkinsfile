pipeline {
    environment {
      registry = "flomsk/django-test"
      registryCredential = 'dockerhub'
      dockerImage = ''
      secret_key = 'django-secret-key'
    }
    agent any
    stages {
        stage('Build image') {
            steps {
                sh 'env'
                echo 'Starting to build docker image'

                script {
                    checkout scm
                    def dockerImage = docker.build("${env.registry}:${env.BUILD_ID}")
                }
            }
        }
        stage('Unit test') {
            steps {
                echo 'Testing docker image'

                script {
                    docker.image('dockerImage').withRun("-e secret_key=${env.secret_key}") { c ->
                        sh 'env'
                        sh 'python manage.py test'
                    }
                }
            }
        }
    }
}
