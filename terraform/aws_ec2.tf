resource "aws_instance" "prometheus_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = "default-ec2"
  vpc_security_group_ids = [aws_security_group.allow_service_ports_sg.id]
  subnet_id              = aws_subnet.my_subnet.id

  tags = {
    Name = var.instance_name
  }
  # This provisioner block calls Ansible, which will then install Prometheus
  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u ec2-user -i '${self.public_ip},' --private-key ${var.instance_ssh_priv_key} ../ansible/playbook.yml"
  # }
  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip
  #   user        = "ec2-user"
  #   private_key = file(var.aws_key_pair)
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install httpd -y",
  #     "sudo service httpd start",
  #     "echo Welcome | sudo tee /var/www/html/index.html"
  #   ]
  # }
}