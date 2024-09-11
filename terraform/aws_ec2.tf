resource "aws_instance" "prometheus_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "default-ec2"
  vpc_security_group_ids = [aws_security_group.allow_service_ports_sg.id]
  subnet_id              = aws_subnet.my_subnet.id

  tags = {
    Name = var.instance_name
  }
}