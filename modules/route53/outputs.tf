output "zone"{
  value = aws_route53_zone.hosted_zone.id

  }
  output "domain_name"{
  value = aws_route53_zone.hosted_zone.domain_name

  }