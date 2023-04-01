module "network" {
        source= "./modules/network"
        project_tag= var.project_tag

        vpc_cidr = var.vpc_cidr
        public_subnet = {
          az = "us-east-1a"
          cidr = var.subnet_cidr
        }
        rt_public_cidr = "0.0.0.0/0"
}

module "jenkins_server" {
        source = "./modules/ec2"
        project_tag = var.project_tag
        vpc_id = module.network.vpc_main_id

        #EC2
        ec2_name = "jenkins_server"
        ec2_ami = {
          name_values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
          owners = ["amazon"]
        }
        ec2_instance_type = "t2.micro"
        ec2_instance_keypair = var.keypair
        associate_public_ip_address = true
        ec2_subnet_id = module.network.public_subnet_id

        #Security Group
        sg_name = "jenkins_server_securitygroup"
        sg_rules = {
          "port 22" = { type ="ingress",port ="22",protocol ="tcp",cidr_blocks =[var.allowed_ssh]}
          "port 8080" = { type ="ingress",port ="8080",protocol ="tcp",cidr_blocks =[var.allowed_ssh]}
          "port 5000" = { type ="ingress",port ="5000",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "egress all" = { type ="egress",port ="0",protocol ="-1",cidr_blocks =["0.0.0.0/0"]}
        }
}
module "K8S_master_server" {
        source = "./modules/ec2"
        project_tag = var.project_tag
        vpc_id = module.network.vpc_main_id

        #EC2
        ec2_name = "K8S_Master"
        ec2_ami = {
          name_values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
          owners = ["amazon"]
        }
        ec2_instance_type = "t2.micro"
        ec2_instance_keypair = var.keypair
        associate_public_ip_address = true
        ec2_subnet_id = module.network.public_subnet_id

        #Security Group
        sg_name = "K8S_Master_securitygroup"
        sg_rules = {
          "port 22" = { type ="ingress",port ="22",protocol ="tcp",cidr_blocks =[var.allowed_ssh]}
          "port 6443" = { type ="ingress",port ="6443",protocol ="tcp",cidr_blocks =[var.allowed_ssh]}
          "port 2379" = { type ="ingress",port ="2379",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "port 2380" = { type ="ingress",port ="2380",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "port 10250" = { type ="ingress",port ="10250",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "port 10259" = { type ="ingress",port ="10259",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "port 10257" = { type ="ingress",port ="10257",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "egress all" = { type ="egress",port ="0",protocol ="-1",cidr_blocks =["0.0.0.0/0"]}
        }
}
module "K8S_worker_server" {
        source = "./modules/ec2"
        project_tag = var.project_tag
        vpc_id = module.network.vpc_main_id

        #EC2
        ec2_name = "K8S_Worker"
        ec2_ami = {
          name_values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
          owners = ["amazon"]
        }
        ec2_instance_type = "t2.micro"
        ec2_instance_keypair = var.keypair
        associate_public_ip_address = true
        ec2_subnet_id = module.network.public_subnet_id

        #Security Group
        sg_name = "K8S_Worker_securitygroup"
        sg_rules = {
          "port 22" = { type ="ingress",port ="22",protocol ="tcp",cidr_blocks =[var.allowed_ssh]}
          "port 10250" = { type ="ingress",port ="10250",protocol ="tcp",cidr_blocks =[var.subnet_cidr]}
          "port 30000" = { type ="ingress",port ="30000",protocol ="tcp",cidr_blocks =["0.0.0.0/0"]}
          "egress all" = { type ="egress",port ="0",protocol ="-1",cidr_blocks =["0.0.0.0/0"]}
        }
}