resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  # Public IPs are disabled by default on custom subnets
  map_public_ip_on_launch = true
  tags = {
    Name = "Main Subnet"
  }
}

# Allows communication between VPC and the internet
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main Gateway"
  }
}

# Public route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }
  tags = {
    Name = "Main Route Table"
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_security_group" "allow_service_ports_sg" {
  name        = "allow_service_ports_sg"
  description = "Allows inbound traffic from configured services and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "Allow Ports Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_prometheus" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9090
  ip_protocol       = "tcp"
  to_port           = 9090
}

resource "aws_vpc_security_group_ingress_rule" "allow_alertmanager" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9093
  ip_protocol       = "tcp"
  to_port           = 9093
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# This is needed so we can ping the ec2 instance
resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "tcp"
  to_port           = 8
}

# grafana port 3000

resource "aws_vpc_security_group_egress_rule" "egress_rule" {
  security_group_id = aws_security_group.allow_service_ports_sg.id
  cidr_ipv4         = "0.0.0.0/0" # all IPs 
  ip_protocol       = "-1"        # all ports
}

