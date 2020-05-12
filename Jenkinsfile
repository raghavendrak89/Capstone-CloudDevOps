pipeline {
   agent any
   parameters {
        choice(
            choices: ['install' , 'upgrade'],
            description: 'Install/Upgrade',
            name: 'DEPLOYMENT_ACTION')
       	string(name: 'app', description: 'Application name to be Deployed')
       	string(name: 'image', description: 'Image to be Deployed')
    }
   stages {
       stage('Install') {
            when {
                // Only say hello if a "greeting" is requested
                expression { params.DEPLOYMENT_ACTION == 'install' }
            }
            steps {
                sh 'echo "Installing the deployment .."'
                sh 'kubectl apply -f ./${ params.app }-deployment.yaml'
                sh 'kubectl apply -f ./${ params.app }-service.yaml'
                sh 'echo "Successfully created the deployment"'
            }
            when {
                expression { params.DEPLOYMENT_ACTION == 'upgrade' }
            }
            steps {
                sh 'echo "Upgrading the deployment (Rolling upgrade) .."'
                sh "kubectl set image deployments/${ params.app } ${ params.app }=${ params.image }"
            }
			stage('Test webhook') {
				steps {
					sh 'python3 ./test/test.py'
				}
			}
       }
   }
}
