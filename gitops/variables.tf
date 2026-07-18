variable "aws_region" {
  default = "eu-west-1"
}

variable "bucket_name_prefix" {
  type = string
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}


variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}
