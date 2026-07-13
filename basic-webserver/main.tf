terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.54.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}


provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      Environment = var.env
      Terraform   = true
      Project     = var.project_name
    }
  }
}

