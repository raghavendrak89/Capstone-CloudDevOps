pipeline {
    agent any
    stages {
        stage('Clone Project') {
            steps {
                git url: 'https://github.com/raghavendrak89/Capstone-CloudDevOps.git'
            }
        }
        stage('PyLint') {
            steps {
                sh 'pylint ./webhook/app_flask.py'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t udacity_capstone:0.${BUILD_ID} .'
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker tag udacity_capstone:0.${BUILD_ID} raghavendrak/udacity_capstone:0.${BUILD_ID}'
                sh 'docker push raghavendrak/udacity_capstone:0.${BUILD_ID}'
            }
        }
        stage('Create kubernetes cluster') {
            steps {
                withAWS(region:'us-west-2', credentials:'aws-static') {
				    sh 'bash ./infra/hms-bootstrap.sh'	
                }
            }
        }
    }
}
