# Project Description

The purpose of this project is to set up a server with Prometheus Server, Alert Manager, and Node Exporter, and trigger a High CPU alert to a slack channel if CPU% > 85%.

This project will perform the following actions:

1. Create an EC2 instance and the needed networking services with Terraform
2. Execute an Ansible playbook, which will then trigger the installation of three services, using Ansible Community Roles: Prometheus server, Prometheus Node Exporter, and Prometheus Alert Manager
3. Trigger a High-CPU alert, which will then be sent to a Slack Channel via Slack Webhooks

These resources will be created in AWS:
- Virtual Private Network (VPC)
- Private subnet
- Internet gateway
- Route table and route table association
- Security group (To open all required ports)
- Ingress and egress rules
- EC2 instance (RHEL 9)

# Prerequisites
- [Install Terraform](https://developer.hashicorp.com/terraform/install)
- [Install Ansible version 9.9.0](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), which is the latest supported Ansible version to be used with the latest Prometheus Ansible Galaxy Roles
    - pip3 install ansible==9.9.0 
- Create a Slack channel, call it #devops, and install "WebHooks" Slack app
- [Create an incoming webhook](https://api.slack.com/messaging/webhooks), and save your webhook URL, you will need it later
- Have an AWS account and IAM user with access keys
- If using a Mac, install gnu-tar, which is required for using Prometheus Ansible Roles. Add it to yout path
    -   ```
        brew install gnu-tar
        ```
        ```
        export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
        ```
    - If executing from a Mac, also run this command (this will prevent hitting [this issue](https://github.com/ansible/ansible/issues/32499)):
        ```
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
        ```

- Create a Slack channel and install "WebHooks" Slack app to the created channel


# Steps

1. Create a "Key Pair" in AWS EC2 instance in PEM format and name it "default-ec2"
2. Download the ssh key
3. Create a directory in your local machine to store the key 
```
cd ~
mkdir -p ~/aws/aws_keys
```
4. Move downloaded SSH Key into created directory
```
mv default-ec2.pem  ~/aws/aws_keys/
```
5. Make sure permissions are 400 on PEM file
```
$ chmod 400 ~/aws/aws_keys/default-ec2.pem
```
6. Create access and secret keys environment variables to be used by Terraform. Obtain both key values from one of your IAM users from your IAM service in AWS. [More details](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html)
```
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_access_key>
```
7. Clone repository
```
git clone https://github.com/christian-arroyo/prometheus_alerting.git
```

8. If you want to use a different OS image, change AMI ID in `/prometheus_alerting/terraform/variables`
9. Execute the following commands, answer 'yes' to prompt
```
cd ~/prometheus_alerting/terraform
terraform init
terraform plan
terraform apply
```
10. Add public IP address from the last line of your stdout into /prometheus_alerting/ansible/ansible_hosts, under `[ec2]`
```
# Replace <IP> bellow with IP address
echo <IP> >> ../ansible/ansible_hosts
```
11. Edit `~/prometheus_alerting/ansible/main_playbook.yml` and enter your Webhook URL:
```
alertmanager_slack_api_url: "<slack_url>"
# example:
alertmanager_slack_api_url: "https://hooks.slack.com/services/XXXXXX/XXXXXXXXXXXXxxXxXXxXXXxx"
```
12. Execute
```
cd ~/prometheus_alerting/ansible
ansible-playbook main_playbook.yml
```

13. Verify there are no failures

# Stress machine

1. SSH into EC2 instance using the IP of your EC2 instance. IP is located in /prometheus_alerting/ansible/ansible_hosts
```
ssh -i ~/aws/aws_keys/default-ec2.pen ec2-user@<ip_address>
```
2. Check how many CPUs your EC2 instance has with `lscpu`
3. Run one of the following commands, depending how many CPUs your systestem has. line1 for 1 CPU, line2 for 2 CPUs, line3 for 4CPUs. This command will start an endless loop with command instruction ( : )
```
for i in 1; do while : ; do : ; done & done
for i in 1 2; do while : ; do : ; done & done
for i in 1 2 3 4; do while : ; do : ; done & done
```

4. Run top, and make sure the process CPU usage is over 85%
5. Wait a few minutes, you can monitor your alerts in the following Prometheus Pages:
- http://<ec2_ip_address>:9090 
- http://<ec2_ip_address>:9093 

Note: Once the alert goes through, it will be posted in the #devops channel of your slack istance in ~4 minutes. If you kill the process after the slack message was sent, a green (healthy) slack message will be sent since the system is not experiencing that issue anymore. 

7. Destroy your resources, answer 'yes' to prompt
```
cd ~/prometheus_alerting/terraform
terraform destroy
```

### Alerts

![Alt text](https://github.com/christian-arroyo/prometheus_alerting/blob/main/screenshots/pending.png?raw=true)
![Alt text](https://github.com/christian-arroyo/prometheus_alerting/blob/main/screenshots/firing.png?raw=true)
![Alt text](https://github.com/christian-arroyo/prometheus_alerting/blob/main/screenshots/am.png?raw=true)
![Alt text](https://github.com/christian-arroyo/prometheus_alerting/blob/main/screenshots/slack.png?raw=true)

### Improvement ideas
- Move Ansible variables to a variables file
- Reformat Slack message to include more details about the alert
- Have Terraform auto-populate IP address into ansible_hosts file
- Have Terraform execute Ansible main playbook

### Issues found during development 
- https://github.com/ansible/ansible/issues/32499
- https://stackoverflow.com/questions/54528115/unable-to-extract-tar-file-though-ansible-unarchive-module-in-macos

