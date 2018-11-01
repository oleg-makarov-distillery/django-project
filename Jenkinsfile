pipeline {
    environment {
      git_name = 'django-test'
      registry = "flomsk/django-test"
      registryCredential = 'dockerhub'
      dockerImage = ''
      secret_key = credentials('django-secret-key')
      kube_config = credentials('kubectl-config')
      // Slack configuration
      SLACK_CHANNEL = '#ci-cd-webhook-tests'
      SLACK_COLOR_DANGER  = '#E01563'
      SLACK_COLOR_INFO    = '#6ECADC'
      SLACK_COLOR_WARNING = '#FFC300'
      SLACK_COLOR_GOOD    = '#3EB991'
    }
    agent any
    stages {
        stage('Build image') {
            steps {
                echo 'Starting to build docker image'

                wrap([$class: 'BuildUser']) { script { env.USER_ID = "${BUILD_USER_ID}" } }

                slackSend (color: "${env.SLACK_COLOR_INFO}",
                   channel: "${params.SLACK_CHANNEL}",
                   message: "*STARTED:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} by ${env.USER_ID}\n More info at: ${env.BUILD_URL}")

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
    post {

      aborted {

        echo "Sending message to Slack"
        slackSend (color: "${env.SLACK_COLOR_WARNING}",
                   channel: "${params.SLACK_CHANNEL}",
                   message: "*ABORTED:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} by ${env.USER_ID}\n More info at: ${env.BUILD_URL}")
      } // aborted

      failure {

        echo "Sending message to Slack"
        slackSend (color: "${env.SLACK_COLOR_DANGER}",
                   channel: "${params.SLACK_CHANNEL}",
                   message: "*FAILED:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} by ${env.USER_ID}\n More info at: ${env.BUILD_URL}")
      } // failure

      success {
        echo "Sending message to Slack"
        slackSend (color: "${env.SLACK_COLOR_GOOD}",
                   channel: "${params.SLACK_CHANNEL}",
                   message: "*SUCCESS:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} by ${env.USER_ID}\n More info at: ${env.BUILD_URL}")
      } // success
   }
}
