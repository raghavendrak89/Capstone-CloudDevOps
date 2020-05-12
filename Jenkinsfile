pipeline {
   agent any
   stages {
       stage('Install') {
            steps {
                sh 'echo "Installing the deployment .."'
                sh 'kubectl apply -f ./kubernetes/webhook-deployment.yaml'
                sh 'kubectl apply -f ./kubernetes/webhook-service.yaml'
                sh 'echo "Successfully created the deployment"'
            }
       }
        stage('Test webhook') {
            steps {
                sh 'python3 ./test/test.py'
            }
        }
   }
}
