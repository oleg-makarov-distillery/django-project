pipeline {
    agent {
        docker { image 'python' }
    }

    stages {
        stage('Deploy') {
            steps {
                sh 'which python3'
                echo 'Deploying....'
            }
        }
    }
}
