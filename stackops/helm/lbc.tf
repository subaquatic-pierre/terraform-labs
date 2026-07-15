locals {
  sa_name = "aws-lbc"
}

resource "aws_iam_role" "lbc" {
  name               = "${var.cluster_name}-lbc"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

resource "aws_iam_policy" "lbc" {
  name   = "${var.cluster_name}-lbc"
  policy = file("${path.module}/policies/AWSLoadBalancerController.json")
}

resource "aws_iam_role_policy_attachment" "lbc" {
  role       = aws_iam_role.lbc.name
  policy_arn = aws_iam_policy.lbc.arn
}

resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = locals.sa_name
  role_arn        = aws_iam_role.lbc.arn
}

resource "helm_release" "aws_lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"

  values = [
    yamlencode({
      clusterName = var.cluster_name

      serviceAccount = {
        create = true
        name   = locals.sa_name
      }

      vpcId = var.vpc_id
    })
  ]

}
