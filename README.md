# prometheus_alerting
This project creates an EC2 instance with Prometheus installed

# Prerequisites

- Install Terraform - https://developer.hashicorp.com/terraform/install
- Install Ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- Have an AWS account and IAM user with access keys
- Create a Slack channel and install "WebHooks" Slack app to the created channel

# Steps

1. Create SSH private/public keys. Use defaults for everything except the passphrase. Keys will be stored in ~/.ssh
```
$ ssh-keygen -b 4096 -t rsa
```
2. Verify ssh keys got created
```
$ ls -la ~/.ssh 
total 16
drwx------   4 christianarroyo  staff   128 Sep  8 12:34 .
drwxr-x---+ 35 christianarroyo  staff  1120 Sep  8 12:34 ..
-rw-------   1 christianarroyo  staff  3478 Sep  8 12:34 id_rsa
-rw-r--r--   1 christianarroyo  staff   770 Sep  8 12:34 id_rsa.pub
```

3. Create access and secret keys env variables to be used by Terraform. Obtain keys from your IAM service in AWS

```
$ export AWS_ACCESS_KEY_ID=<access_key>
$ export AWS_SECRET_ACCESS_KEY=<secret_access_key>
```
4. Change AMI ID in `./terraform/variables` if you want to use a different OS image

```
$ terraform init
$ terraform plan
$ terraform apply
$ terraform destroy
```


# Terraform
1. Set up Virtual Private Cloud (VPC)
2. Set up Subnet
3. Set up Internet Gateway
4. Set up Route Table
5. Open Ports for Prometheus
6. Set up EC2 instance

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
