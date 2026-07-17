# output "bucket_name" {
#   value = module.website.bucket_name
# }

# output "infra_domain" {
#   value = module.website.infra_domain
# }

# output "cloudfront_id" {
#   value = module.website.cloudfront_id
# }

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}

