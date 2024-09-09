variable "ami_id" {
  description = "Value of ami ID"
  type        = string
  # Red Hat
  default = "ami-0583d8c7a9c35822c"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "PrometheusServer"
}

variable "instance_type" {
  description = "Free AWS tier instance type"
  type        = string
  default     = "t2.micro"
}

variable "aws_key_pair" {
  default = "~/aws/aws_keys/default-ec2.pem"
}

variable "instance_ssh_priv_key" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "instance_ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}