data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version = "~> 5.0"
  name    = "${var.project_name}-vpc"
  cidr    = var.vpc_cidr


  azs = local.azs

  # Creates this network
  # 10.0.0.0/16

  # ├── Private
  # │     10.0.0.0/20
  # │     10.0.16.0/20
  # │
  # ├── Public
  # │     10.0.48.0/24
  # │     10.0.49.0/24
  # │
  # └── Intra
  #       10.0.52.0/24
  #       10.0.53.0/24
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
}
