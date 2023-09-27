output "public_sg" {
    value =  aws_security_group.public-sg-prod.id
}

output "private_sg" {
    value = aws_security_group.private-sg-prod.id
}