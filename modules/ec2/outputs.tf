
output cryptobucksapp-producction-alb {
value = aws_alb.alb

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
