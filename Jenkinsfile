pipeline {
  agent any

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
            docker build -t ${USERNAME}/devops_assessment:${BUILD_NUMBER} .
        """
        }
      }
    }
    stage('PUSH') {
      steps {
        echo "This is push stage number ${BUILD_NUMBER}"
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        sh """
            docker push ${USERNAME}/devops_assessment:${BUILD_NUMBER}
            echo ${BUILD_NUMBER} > ../push_number.txt
        """
        }
      }
    }
    stage('Deploy') {
      steps {
        echo "This is deploy stage number ${BUILD_NUMBER}"
        sh """
        export BUILD_NUMBER=\$(cat ../push_number.txt)
        mv k8s/deployment.yaml k8s/deployment.yaml.tmp
        cat k8s/deployment.yaml.tmp | envsubst > k8s/deployment.yaml
        rm -f k8s/deployment.yaml.tmp
        [ -d /tmp/k8s ] && rm -r /tmp/k8s
        mv ./k8s  /tmp/
        ansible-playbook ./ansible_cd/playbook.yaml -i ./ansible_cd/inventory
        """
      }
    }
}
}