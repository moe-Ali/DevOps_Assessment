pipeline {
  agent any

  tools{
    terraform 'terraform'
  }
  stages {
    stage('Build Infrastucture') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-iam-user', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
        sh '''
          export AWS_DEFAULT_REGION=us-east-1
          terraform -chdir=./terraform init
          terraform -chdir=./terraform apply --auto-approve 
        '''
        }
      }
    }
    stage('BUILD') {
      steps {
        echo "This is build stage number ${BUILD_NUMBER}"
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh """
            docker login --username ${USERNAME} --password ${PASSWORD}
            docker build -t ${USERNAME}/fixed_soulations:${BUILD_NUMBER} .
        """
        }
      }
    }
    stage('PUSH') {
      steps {
        echo "This is push stage number ${BUILD_NUMBER}"
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh """
            docker push ${USERNAME}/fixed_soulations:${BUILD_NUMBER}
            echo ${BUILD_NUMBER} > ../push_number.txt
        """
        }
      }
    }
    stage('Deploy') {
      steps {
        echo "This is deploy stage number ${BUILD_NUMBER}"
        sh "ansible-playbook ./ansible_cd/playbook.yaml -i ././ansible_cd/inventory"
      }
    }
}
}