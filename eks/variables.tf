variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "env" {
  type        = string
  default     = "Learning"
  description = "Learning Terraform"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "AWS EKS Testing"
}


variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

