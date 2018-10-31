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
                    docker.image('lachlanevenson/k8s-kubectl').inside("-u root -v ${env.kube_config}:/root/.kube/config") {
                        sh """
                        kubectl get nodes
                        """
                    }
                }
            }
        }
    }
}
