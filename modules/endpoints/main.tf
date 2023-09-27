resource "aws_vpc_endpoint" "secret-manager-endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"

 
  security_group_ids = [ var.security_group]

  private_dns_enabled = true
     tags    = {
     
        Name = "secret manager endpoint"
        Env = "production"
        Provisioner = "terraform"		
       
     }

}
resource "aws_vpc_endpoint_subnet_association" "private-subnet-1" {
  vpc_endpoint_id = aws_vpc_endpoint.secret-manager-endpoint.id
  subnet_id       =var.private-subnet-1
  }

resource "aws_vpc_endpoint_subnet_association" "private-subnet-2" {
  vpc_endpoint_id = aws_vpc_endpoint.secret-manager-endpoint.id
  subnet_id       = var.private-subnet-2
}

resource "aws_vpc_endpoint_subnet_association" "private-subnet-3" {
  vpc_endpoint_id = aws_vpc_endpoint.secret-manager-endpoint.id
  subnet_id       = var.private-subnet-3
}
