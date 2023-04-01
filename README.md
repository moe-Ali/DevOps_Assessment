# DevOps_assessment
This is a full devops project on AWS done only by using AWS free tier and free programs
## Digram
![digram](https://github.com/moe-Ali/DevOps_Assessment/blob/master/Diagram/AWS_Infrastructure.png)

## Tools:
- Python and Bash for scripting
- Git for version control
- Terraform for Infrastructure As Code
- Ansible for Configuration As Code
- Jenkins for Continuous Integration/Continuous Deployment
- Docker for Containerization
- Kuberenates for Orchestration
- AWS to build the infrastructure on
## What i did
- Created S3 bucket and DynamoDB table to work as the backend for Terraform(stores terraform.tfstat in s3 and terraform.lock in DynamoDB)
- Used Terraform to build AWS infrastructure that contains:
    - network module that contains:
        - vpc
        - public subnet
        - route table for the public subnet
        - internet gateway
    - using 3(Jenkins,Master_node,Worker_node) of ec2 module that contains:
        - ami which is a data type resource that searchs on AWS for the latest  ubuntu ami
        - instance of the type t2.micro
        - security group attached to the instance
    - making keypair and storing it localy
    - remote-state.tf to use S3 and DynamoDB as backend
- used Ansible to configure the AWS instances:
    - jenkins role for the Jenkins server
    - k8s role for Master_node and Worker node
- Used a python script to:
    - Automate Infrastructure creation using Terraform commands
    - Install Jenkins and kubeadm on the machines using Ansible
    - Print out the initialAdminPassword of Jenkins
- created Jenkins pipeline that pulls this repo and use Jenkinsfile to:
    - Apply the new changes into the infrastructure code (Terraform)
    - Create image from Nginx and use ./website as the webpage the will be displayed
    - Push the image to my DockerHub account (mohamd556) by the tag of the number of the Jenkins pipeline run
    - Use the pushed docker image in making a deployment file and used service type NodePort to be accessed at port 30000
    - Use Ansible to ssh to Kubernates Master node and apply the deployment and service files
## Steps to run the project
- git clone https://github.com/moe-Ali/DevOps_Assessment
- cd DevOps_Assessment
- python main.py
- Enter 4 for full project (Terraform apply and Ansible)
- On K8S_Master run:
    - sudo kubeadm init --ignore-preflight-errors=all #Note Copy the kubeadm join message
    - mkdir -p /home/ubuntu/.kube
    - sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    - sudo chown 1000:1000 /home/ubuntu/.kube/config
    - kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
- On K8S run the copied kubeadm join message and --ignore-preflight-errors=all to the end of it
- Access jenkins on port 8080 from web browser:
    - add AWS credentials => name: aws-iam-user type: username with password
    - add dockerhub credentials => name: dockerhub type: username with password
    - add dockerhub credentials => name: githublogin type: username with password
    - create pipeline that will pull from GitHub repo that is forked from (https://github.com/moe-Ali/DevOps_Assessment)
- On GitHub add a webhook for Jenkins server
- Make changes in the code to see it works
## to cleanup
- python main.py
- Enter 2 to destroy the infrastructure on AWS using Terraform
## Notes
- kubeadmin kube-system pods keeps restarting i tryed to solve this problem alot but i couldnt so i suggest using eks or kubeadmin on ec2 with 2 CPU and 2GB RAM at least
- for better pipeline preformance use Jenkins ec2 hight than t2.micro or add another ec2 as Jenkins slave
- we can use autoscaling group for the worker nodes but this will get us out of free tier
- security group can be modified to allow only the company IP or specific IPs to access the jenkins webpage and ssh to the 3 instances by changing the allowed_ssh variable
- assuming the website(bakehouse) code is the Microservice, this code was copied from one of my instructor at ITI Eng.Kareem

## Screenshots
![webhook](https://github.com/moe-Ali/DevOps_Assessment/blob/master/screenshots/webhook.png)
![kubeadmin](https://github.com/moe-Ali/DevOps_Assessment/blob/master/screenshots/ready_kubeadm.png)
![dockerhub](https://github.com/moe-Ali/DevOps_Assessment/blob/master/screenshots/dockerhub_image.png)
