# Work In Progress
This project creates an EC2 instance with Prometheus installed

# Prerequisites

- Install Terraform - https://developer.hashicorp.com/terraform/install
- Install Ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- Have an AWS account and IAM user with access keys
- Create a Slack channel and install "WebHooks" Slack app to the created channel
- Create a key pair in AWS portal

# Steps

1. Create a "Key Pair" in AWS EC2 instance in PEM format and name it "default-ec2"
2. Download the ssh key
3. Create a directory in your local machine to store the key 
```
$ mkdir -p ~/aws/aws_keys
```
4. Move downloaded SSH Key into created directory
```
mv default-ec2.pem  ~/aws/aws_keys/
```
5. Make sure premissions are 400 on PEM file
```
$ chmod 400 ~/aws/aws_keys/default-ec2.pem
```
6. Create access and secret keys env variables to be used by Terraform. Obtain both key values from one of your IAM users from your IAM service in AWS

```
$ export AWS_ACCESS_KEY_ID=<access_key>
$ export AWS_SECRET_ACCESS_KEY=<secret_access_key>
```
7. Change AMI ID in `./terraform/variables` if you want to use a different OS image
8. Change directories to terraform and execute
```
terraform init
terraform plan
terraform apply
```
9. Add public IP address from output into ansible/inventory.ini


# Terraform
1. Set up Virtual Private Cloud (VPC)
2. Set up Subnet
3. Set up Internet Gateway
4. Set up Route Table
5. Open Ports for Prometheus
6. Set up EC2 instance
7. Set up Key Pair

# Ansible
1. Install Prometheus
2. Set up alertmanager yml file

# Slack
1. Create slack channel
2. Configure slack channel to use Webhooks app
3. 

# Prometheus

### Resources
https://mdl.library.utoronto.ca/technology/tutorials/generating-ssh-key-pairs-mac
https://hvalls.dev/posts/prometheus-grafana-server
https://medium.com/@krishabh080/prometheus-alert-manager-setup-and-alert-configurations-slack-800f6bb5111e
