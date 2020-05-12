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
        #stage('Test webhook') {
        #    steps {
        #        sh 'python3 ./test/test.py'
        #    }
        #}
        stage('Build Image') {
            steps {
                sh 'docker build -t udacity_capstone:0.${BUILD_ID} .'
            }
        }
        stage('Security Scan') {
            steps {
                aquaMicroscanner imageName: 'udacity_capstone:0.${BUILD_ID}', notCompleted: 'exit 1', onDisallowed: 'fail'
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
				    sh ./infra/hms-bootstrap.sh	
                }
            }
        }
    }
}
