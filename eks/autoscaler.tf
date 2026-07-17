locals {
  sa_name = "cluster-autoscaler"
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${aws_eks_cluster.eks.name}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "${aws_eks_cluster.eks.name}-cluster-autoscaler"
  policy = file("${path.module}/policies/AWSClusterAutoScaler.json")
}


resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}


resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = locals.sa_name
  role_arn        = aws_iam_role.cluster_autoscaler.arn
}

resource "helm_release" "cluster_autoscaler" {
  name = "autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"

  values = [
    yamlencode({
      rbac = {
        serviceAccount = {
          name = locals.sa_name
        }
      }

      autoDiscovery = {
        clusterName = aws_eks_cluster.eks.name
      }

      awsRegion = var.aws_region
    })
  ]

}
