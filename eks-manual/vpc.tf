data "aws_availability_zones" "azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.azs.names, 0, 2)
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(local.azs)
  availability_zone = local.azs[count.index]

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)

  tags = {
    Name = "${var.project_name}-private-${count.index}"

    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.project_name}-eks" = "owned"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(local.azs)
  availability_zone = local.azs[count.index]

  vpc_id = aws_vpc.main.id

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)

  tags = {
    Name = "${var.project_name}-private-${count.index}"

    "kubernetes.io/role/internal-elb"               = "1"
    "kubernetes.io/cluster/${var.project_name}-eks" = "owned"
  }
}

resource "aws_subnet" "intra_subnets" {
  count             = length(local.azs)
  availability_zone = local.azs[count.index]

  vpc_id = aws_vpc.main.id

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 20)

  tags = {
    Name = "${var.project_name}-intra-${count.index}"

    "kubernetes.io/cluster/${var.project_name}-eks" = "owned"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public"
  }
}

resource "aws_route_table" "intra" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-intra"
  }
}

resource "aws_route_table_association" "public_zones" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_zones" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "intra_zones" {
  count          = length(aws_subnet.intra_subnets)
  subnet_id      = aws_subnet.intra_subnets[count.index].id
  route_table_id = aws_route_table.intra.id
}




# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   version = "~> 5.0"
#   name    = "${var.project_name}-vpc"
#   cidr    = var.vpc_cidr


#   azs = local.azs

#   private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
#   public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
#   intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

#   public_subnet_tags = {
#     "kubernetes.io/role/elb" = 1
#   }

#   private_subnet_tags = {
#     "kubernetes.io/role/internal-elb" = 1
#   }

#   enable_nat_gateway      = true
#   single_nat_gateway      = true
#   enable_dns_hostnames    = true
#   enable_dns_support      = true
#   map_public_ip_on_launch = true
# }
