# output "certificate"{
#   value = aws_acm_certificate.certificate.id 
# }

output "certificate"{
  value = aws_acm_certificate.certificate.arn 
}