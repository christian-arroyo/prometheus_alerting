terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "prometheus_server_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "prometheus_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.allow_service_ports.id]
  subnet_id              = aws_subnet.my_subnet.id

  tags = {
    Name = var.instance_name
  }
}