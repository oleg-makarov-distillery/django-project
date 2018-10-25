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
                    dockerImage = registry + ":$BUILD_NUMBER"
                    buildImage = docker.build(dockerImage)
                }
            }
        }
        stage('Unit test') {
            steps {
                echo 'Testing docker image'

                script {
                    docker.image(dockerImage).inside("-e secret_key=${env.secret_key}") { 
                        sh 'python manage.py test'
                    }
                }
            }
        }
        stage('Upload to hub') {
            steps {
                echo 'Uploading docker image to docker hub'

                script {
                    docker.withRegistry( 'https://index.docker.io', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }        
    }
}
