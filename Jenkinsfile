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
                    docker.image("${env.registry}:${env.BUILD_ID}").withRun("-e secret_key=${env.secret_key}") { c ->
                        sh 'which pip3'
                        sh '/usr/local/bin/pip3 install virtualenv'
                        sh '/usr/local/bin/python3 -m virtualenv .env'
                        sh """
                        #!/bin/bash
                        . .env/bin/activate
                        if [[ -f requirements.txt ]]; then
                          pip install -r requirements.txt
                        fi
                        python manage.py test
                        """
                    }
                }
            }
        }
    }
}
