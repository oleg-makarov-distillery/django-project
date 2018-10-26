pipeline {
    environment {
      registry = "flomsk/django-test"
      registryCredential = 'dockerhub'
      dockerImage = ''
      secret_key = 'django-secret-key'
      kube_config = credentials('kubectl-config')
    }
    agent any
    stages {
        stage('Deploy to k8s') {
            steps {
                echo 'Working with k8s'

                script {
                    docker.image('docker:latest').inside("-e kube_config=${env.kube_config}") {
                        sh 'echo $kube_config'
                    }
                }
            }
        }
    }
}
