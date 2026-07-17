module "helm" {
  source       = "./helm"
  aws_region   = var.aws_region
  cluster_name = module.eks.cluster_name
  vpc_id       = module.eks.vpc_id

  depends_on = [module.eks]
}

module "eks" {
  source       = "./eks"
  aws_region   = var.aws_region
  project_name = var.project_name
  eks_version  = var.eks_version
  env          = var.env
  default_tags = var.default_tags
}

# module "website" {
#   source       = "./website"
#   project_name = var.project_name
#   domain_name  = var.domain_name
#   default_tags = var.default_tags
# }


