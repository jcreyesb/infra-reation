resource "aws_acm_certificate" "certificate" {
  domain_name       = var.proyecto
  subject_alternative_names = ["*.proyecto"]
  validation_method = "DNS"

  tags = {
     name = var.proyecto  
     env = "production"
     provisioner = "terraform"	
  }

  lifecycle {
    create_before_destroy = true
  }
}

# data "aws_route53_zone" "cryptobucksapp_com" {
#   name         = "cryptobucksapp.com"
#   private_zone = false
# }


resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.certificate.domain_validation_options.*.resource_record_name[0]
  type    = aws_acm_certificate.certificate.domain_validation_options.*.resource_record_type[0]
  zone_id = "Z008447236GSFQTIL1VTA"
  #zone_id = "${data.aws_route53_zone.cryptobucksapp_com.id}"
  records = [aws_acm_certificate.certificate.domain_validation_options.*.resource_record_value[0]]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = "${aws_acm_certificate.certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
