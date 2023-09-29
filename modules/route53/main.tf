# resource "aws_route53_zone" "main" {
#   name = var.domain
#     tags = {
#      name = var.proyecto  
#      env = "production"
#      ManagedBy = "Terraform"	
#   }
# }

# resource "aws_route53_record" "main" {
#   zone_id = aws_route53_zone.main.zone_id
#   name    = var.domain
#   type    = "A"
#   records = [var.albdns]
# }


# data "aws_route53_zone" "hosted_zone"{
# name = var.domain_name
#      tags = {
#      name = var.proyecto  
#      env = "production"
#      ManagedBy = "Terraform"	
#   }
# }

resource "aws_route53_zone" "hosted_zone"{
name = var.domain_name
     tags = {
     name = var.proyecto  
     env = "production"
     ManagedBy = "Terraform"	
  }
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = var.domain_name
  type    = "A"
   
    alias {
        name = var.albdns_dns
        zone_id =  var.alb_id
        evaluate_target_health = true 

    }
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.hosted_zone.id
  name    = var.record_name
  type    = "CNAME"
     weighted_routing_policy {
    weight = 90
  }
  records        = [var.albdns_dns]
  set_identifier   = "www"
}