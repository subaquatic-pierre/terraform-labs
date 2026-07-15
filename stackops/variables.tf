variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "eks_version" {
  description = "Version used for AWS EKS control plane"
  type        = string
}

variable "env" {
  description = "Project environment"
  type        = string
}

variable "domain_name" {
  description = "Project Route53 Domain"
  type        = string
}

variable "default_tags" {
  description = "Default tags to write to all resrouces"
  type        = map(any)
  default     = {}
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}



