variable "aws_region" {
  default = "eu-west-1"
}


variable "bucket_name" {
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
