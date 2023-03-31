import subprocess
import requests
import re
import os

        
def terraform_apply():
    print("\n!!Terraform Apply!!\n")
    subprocess.run(["terraform", "init"],cwd="./terraform")
    subprocess.run(["terraform", "apply","-auto-approve"],cwd="./terraform")
      

def terraform_destroy():
    print("\n!!Terraform Destroy!!\n")
    subprocess.run(["terraform", "destroy","-auto-approve"],cwd="./terraform")
    open("./ansible/inventory", "w").close()

def shh_known_hosts():
    print("!!Putting the IP in the Known_hosts file!!")
    known_hosts_file = os.path.expanduser('~/.ssh/known_hosts') #Python doesn't understand the "~" from itself so we are giving it some help :)
    with open('./ansible/inventory', 'r') as file:
        lines = file.readlines()
    for line in lines:
        inventory_hostip=re.search("ansible_host=([0-9\.]*)",line)
        # Run the ssh-keyscan command to get the remote host key
        process = subprocess.Popen(['ssh-keyscan', inventory_hostip[1]], stdout=subprocess.PIPE)
        # Extract the host key from the process output
        host_key = process.communicate()[0]
        with open(known_hosts_file, 'a') as file:
            file.write(host_key.decode())
            
def ansible_start():
    print("\n!!Ansible Start!!\n")
    shh_known_hosts() # so we dont get asked yes/no to add the ip to known hosts
    subprocess.run(["ansible-playbook", "playbook.yaml", "-i","inventory"],cwd="./ansible")

def get_jenkins_passwod():
    with open('./ansible/inventory', 'r') as file:
        lines = file.readlines()
    for line in lines:
        if "jenkins_server" in line:
            password = re.search("ansible_host=([0-9\.]*)",line)
    print("Jenkins initialAdminPassword:")
    subprocess.run(["ssh","-i","../devops_assessment.pem","ubuntu@{}".format(password[1]),"sudo","cat","/var/lib/jenkins/secrets/initialAdminPassword"])

def ansible_cd():
    new_key="/opt/devops_assessment.pem"
    with open('./ansible/inventory', 'r') as file:
        lines = file.readlines()
    for line in lines:
        if "K8S_Master" in line:
            k8s_master=line
    with open('./ansible_cd/inventory', 'w') as file:
        new_line = re.sub(r'ansible_ssh_private_key_file=[^ ]+', f'ansible_ssh_private_key_file={new_key}', line)
        file.writelines(new_line)
        
def main():
    print("Choose a number\nOptions:",
          """
        1) Terraform Apply
        2) Terraform Destroy
        3) Ansible Start
        4) start Project(Terraform Apply then Ansible Start and will output the Jenkins initialAdminPassword)
          """)
    picked_number=input("Your choise: ")
    
    if picked_number == "1":
        terraform_apply()
        ansible_cd()
    elif picked_number == "2":
        terraform_destroy()
    elif picked_number == "3":
        ansible_start()
        get_jenkins_passwod()
    elif picked_number == "4":
        terraform_apply()
        ansible_start()
        get_jenkins_passwod()
    else:
        print("Please make sure to Enter on of this numbers [1,2,3,4]")
        main()
main()
