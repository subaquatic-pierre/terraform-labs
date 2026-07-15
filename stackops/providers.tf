provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = var.default_tags
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
