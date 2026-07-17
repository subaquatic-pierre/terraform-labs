terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.54.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.2.0"
    }
  }
}
