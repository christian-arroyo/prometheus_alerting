variable "ami_id" {
  description = "Value of ami ID"
  type        = string
  # Ubuntu
  default = "ami-0e86e20dae9224db8"
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
