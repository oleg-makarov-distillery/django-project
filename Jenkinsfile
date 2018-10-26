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
                    docker.image('docker:latest').inside("-u root -e kube_config=${env.kube_config}") {
                        sh """
                        apk add --update curl
                        curl -LO https://storage.googleapis.com/kubernetes-release/release/\$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
                        chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl
                        rm ~/.kube/config || echo "doesnt exist"
                        mkdir ~/.kube || echo "already exist"
                        cat $kube_config > ~/.kube/config
                        kubectl get nodes
                        """
                    }
                }
            }
        }
    }
}
