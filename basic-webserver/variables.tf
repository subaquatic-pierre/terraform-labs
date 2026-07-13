variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}


variable "server_port" {
  description = "Web server port"
  default     = 80
  type        = number
}

variable "env" {
  type        = string
  default     = "Learning"
  description = "Learning Terraform"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "basic-webserver"
}


variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}


variable "my_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


variable "key_name" {
  description = "AWS key pair name"
  type        = string
  default     = "basic-webserver-key"
}



