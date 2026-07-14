terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.54.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = var.default_tags
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

