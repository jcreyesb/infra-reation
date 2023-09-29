
output alb {
value = aws_alb.alb

}
output albdns {
value = aws_alb.alb.dns_name
}
output albid {
value = aws_alb.alb.zone_id
}
output "tg-production" {
 value = aws_alb_target_group.tg-production

}
output alb-arn {
value = aws_alb.alb
}

output "target_group_arn" {
  value       = aws_alb_target_group.tg-production.arn
}

