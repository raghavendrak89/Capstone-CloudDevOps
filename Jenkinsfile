pipeline {
   agent any
   stages {
       stage('Upgrade[BG]') {
            steps {
                sh 'echo "Upgrading the deployment (Rolling upgrade) .."'
                sh "kubectl set image deployments/webhook-latest webhook=raghavendrak/udacity_capstone:latest"
                sh 'echo "Successfully upgraded the deployment"'
            }
       }
        stage('Test webhook') {
            steps {
                sh 'python3 ./test/test.py'
            }
        }
   }
}
