module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "example"
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Create just the IAM resources for EKS Auto Mode for use with custom node pools
  create_auto_mode_iam_resources = true
  compute_config = {
    enabled = true
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

}
