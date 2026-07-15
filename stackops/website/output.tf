output "bucket_name" {
  value = aws_s3_bucket.stackops.id
}

output "infra_domain" {
  value = "https://${aws_route53_record.infra.name}"
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.site.id
}
