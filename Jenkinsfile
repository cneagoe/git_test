pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('Prebuild') {
            steps {
                sh './test.sh'
            }
        }
    }
}