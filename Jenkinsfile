pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-iam-user').username
    AWS_SECRET_ACCESS_KEY = credentials('aws-iam-user').password
    AWS_DEFAULT_REGION = 'us-east-1'
  }

  stages {
    stage('Build Infrastucture') {
      steps {
        sh """
        terraform init ./terraform
        terraform apply -auto-approve ./terraform
        """
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
        // sh "ansible-playbook playbook.yaml"
      }
    }
}
}