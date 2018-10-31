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
                    docker.image('lachlanevenson/k8s-kubectl').inside("-u root -e kube_config=${env.kube_config}") {
                        sh """
                        cat $kube_config > ~/.kube/config
                        kubectl get nodes
                        """
                    }
                }
            }
        }
    }
}
