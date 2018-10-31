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
        stage('Deploy to k8s') {
            steps {
                echo 'Working with k8s'

                script {
                    docker.image('flomsk/kubectl').inside("-u root -v ${env.kube_config}:/root/.kube/config") {
                        sh """
                        cat kube/kube.tpl | sed -e "s#APP_NAME#${env.git_name}#g" -e "s#BRANCH#${env.BRANCH_NAME}#g" -e  "s#SECRET_KEY#${env.secret_key}#g" > kubernetes.yml
                        ls
                        sleep 600
                        cat kubernetes.yaml
                        """
                    }
                }
            }
        }
    }
}
