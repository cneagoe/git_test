pipeline {
    agent any
    environment {
        CI = 'true'
    }
    stages {
        stage('Install packages') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm start'
                sh 'sleep 10'
                sh 'curl localhost:3000'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
    }
}