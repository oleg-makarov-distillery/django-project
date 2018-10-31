pipeline {
    environment {
      git_name = 'django-test'
      registry = "flomsk/django-test"
      registryCredential = 'dockerhub'
      dockerImage = ''
      secret_key = credentials('django-secret-key')
      kube_config = credentials('kubectl-config')
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
                sh 'env'
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
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
                        buildImage.push()
                    }
                }
            }
        } 
        stage('Deploy to k8s') {
            steps {
                echo 'Working with k8s'

                script {
                    dockerImage = registry + ":$BUILD_NUMBER"
                    docker.image('flomsk/kubectl').inside("-u root -e kube_config=${env.kube_config}") {
                        sh """
                        cat $kube_config > ~/.kube/config
                        cat kube/kube.tpl | sed -e "s#APP_NAME#${env.git_name}#g" -e "s#IMAGE_NAME#${env.registry}:${env.BUILD_NUMBER}#g" -e "s#BRANCH#${env.BRANCH_NAME}#g" -e "s#SECRET_KEY#${env.secret_key}#g" > kubernetes.yml
                        kubectl apply -f kubernetes.yml
                        """
                    }
                }
            }
        }
    }
}
