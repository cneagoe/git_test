pipeline {
    agent any
    environment {
        CI = 'true'
        registry = "ngciprian/appimg"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    stages {
        stage('install packages') {
            steps {
                sh 'npm install'
            }
        }
        stage('test') {
            steps {
                sh 'nohup npm start &'
                sleep 10
                sh 'curl -k localhost:3000'
            }
        }
        stage('build app') {
            steps {
                sh 'npm run build'
                sh 'tar -czvf build.tar.gz build/*'
                archiveArtifacts artifacts: 'build.tar.gz', followSymlinks: false
            }
        }
        // stage('publish docker img')
        stage('build docker image'){
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('publish docker image'){
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
        stage('cleanup containers'){
            steps{
                sh '''
                    if docker container ls -a | grep app ;
                    then 
                        docker container stop app
                        docker container rm app
                    fi
                '''
                }
            }
        stage('deploy image'){
            steps{
                sh 'docker run -d -p 4000:80 --name app appimg'
                sleep 10
                sh 'curl -k localhost:4000'
            }
        }
    }
}