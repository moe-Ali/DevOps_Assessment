# DevOps_assessment

## Digram
## what i did:
- Created S3 bucket and DynamoDB table to work as the backend for Terraform(stores terraform.tfstat in s3 and terraform.lock in DynamoDB)
- Used a python script to:
    - Automate Infrastructure creation using Terraform commands
    - Install Jenkins and kubeadm on the machines using Ansible
    - Print out the initialAdminPassword of Jenkins
- Used Jenkinsfile to:
    - Apply the new changes into the infrastructure code (Terraform)
    - Create image from Nginx and use ./website as the webpage the will be displayed
    - Pushed the image to my DockerHub account by the tag of the version of the Jenkins pipeline run
    - Use the pushed docker image in making a deployment file and used service type NodePort to be accessed at port 30000
    - Use Ansible to ssh to the Master node and apply the deployment and service files
## Steps to run:
- python main.py
- Enter 4 for full project (Terraform apply and Ansible)
- On K8S_Master run:
    - sudo kubeadm init --ignore-preflight-errors=all #Note Copy the kubeadm join message
    - mkdir -p /home/ubuntu/.kube
    - sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    - sudo chown 1000:1000 /home/ubuntu/.kube/config
    - kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
- On K8S run the copied kubeadm join message
- Access jenkins on port 8080 from web browser:
    - add aws credentials => name: aws-iam-user type: username with password
    - add dockerhub credentials => name: dockerhub type: username with password
    - add github credentials => name: githublogin type: username with password
    - create pipeline that will pull from GitHub (https://github.com/moe-Ali/DevOps_Assessment)
- On GitHub add a webhook for Jenkins server
- Make changes in the code to see it works

## Notes:
- kubeadmin kube-system pods keeps restarting i tryed to solve this problem alot but i couldnt so i suggest using eks or kubeadmin on ec2 with 2 CPU and 2GB RAM at least
- for better pipeline preformance use Jenkins ec2 hight than t2.micro or add another ec2 as Jenkins slave
- assuming the bakehouse code is the Microservice, this code was copied from one of my instructor at ITI Eng.Kareem