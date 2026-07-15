###############################################################################
# Current AWS account
###############################################################################

data "aws_caller_identity" "current" {}

###############################################################################
# IAM GROUPS
###############################################################################

resource "aws_iam_group" "eks_admins" {
  name = "eks-admins"
}

resource "aws_iam_group" "eks_developers" {
  name = "eks-developers"
}


resource "aws_iam_group" "eks_viewers" {
  name = "eks-viewers"
}

###############################################################################
# IAM USERS
#
# In production these would normally be created manually or through IAM
# Identity Center.
###############################################################################

data "aws_iam_user" "pierre" {
  user_name = "Pierre"
}

resource "aws_iam_user" "developer" {
  name = "${var.project_name}-developer"
}

resource "aws_iam_user" "manager" {
  name = "${var.project_name}-manager"
}

###############################################################################
# Add users to groups
###############################################################################

resource "aws_iam_user_group_membership" "pierre" {
  user = data.aws_iam_user.pierre.user_name
  groups = [
    aws_iam_group.eks_admins.name
  ]
}


resource "aws_iam_user_group_membership" "developer" {
  user = aws_iam_user.developer.name
  groups = [
    aws_iam_group.eks_developers.name
  ]
}


resource "aws_iam_user_group_membership" "manager" {
  user = aws_iam_user.manager.name
  groups = [
    aws_iam_group.eks_viewers.name
  ]
}

###############################################################################
# AWS permissions
#
# These permissions allow users to authenticate to EKS and retrieve cluster
# information.
#
# Kubernetes permissions are handled separately below.
###############################################################################

resource "aws_iam_policy" "eks_access" {
  name = "${var.project_name}-eks-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "admins" {
  group      = aws_iam_group.eks_admins.name
  policy_arn = aws_iam_policy.eks_access.arn
}

resource "aws_iam_group_policy_attachment" "developers" {
  group      = aws_iam_group.eks_developers.name
  policy_arn = aws_iam_policy.eks_access.arn
}

resource "aws_iam_group_policy_attachment" "viewers" {
  group      = aws_iam_group.eks_viewers.name
  policy_arn = aws_iam_policy.eks_access.arn
}

###############################################################################
# ADMIN ACCESS
###############################################################################

resource "aws_eks_access_entry" "pierre" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = data.aws_iam_user.pierre.arn
  kubernetes_groups = [
    "eks-admins"
  ]
}


resource "aws_eks_access_policy_association" "pierre_admin" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = data.aws_iam_user.pierre.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

###############################################################################
# DEVELOPER ACCESS
###############################################################################

resource "aws_eks_access_entry" "developer" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.developer.arn
  kubernetes_groups = [
    "eks-developers"
  ]
}


resource "aws_eks_access_policy_association" "developer" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.developer.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type = "namespace"
    namespaces = [
      "development"
    ]
  }
}

###############################################################################
# VIEWER ACCESS
###############################################################################

resource "aws_eks_access_entry" "manager" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.manager.arn

  kubernetes_groups = [
    "eks-viewers"
  ]
}

resource "aws_eks_access_policy_association" "manager" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.manager.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type = "cluster"
  }
}
