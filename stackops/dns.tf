data "aws_route53_zone" "stackops" {
  name = var.domain_name
}

resource "aws_route53_record" "infra" {
  zone_id = data.aws_route53_zone.stackops.zone_id
  name    = "infra.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }


  zone_id = data.aws_route53_zone.stackops.zone_id
  name    = each.value.name
  type    = each.value.type

  records = [
    each.value.value
  ]

  ttl = 60
}
