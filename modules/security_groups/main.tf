resource "aws_security_group" "public-sg-prod" {
    name = "Security group producction public"
    description = "Control to public access to ALB"
    vpc_id = var.vpc_id

    ingress {   
        description = " ssh access"    
        protocol = "tcp"
        from_port = var.ssh_port
        to_port = var.ssh_port
        cidr_blocks = [ var.cidr_all ]
    }

    ingress {   
        description = " http access"    
        protocol = "tcp"
        from_port =var.http_port
        to_port =var.http_port
        cidr_blocks = [ var.cidr_all ]
    }

    ingress {   
        description = " https access"    
        protocol = "tcp"
        from_port =var.https_port
        to_port = var.https_port
        cidr_blocks = [ var.cidr_all ]
    }
    egress  {
        description = "egress to internet"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [var.cidr_all]
    }

      tags = {
    Name = "Public security group"
    env = "production"
    ManagedBy = "Terraform"	
  }
  
}
############################# Private Net####################



resource "aws_security_group" "private-sg-prod" {
    name = "Security group producction private"
    description = "Control to private access"
    vpc_id = var.vpc_id

    ingress {   
        description = " ssh access"    
        protocol = "tcp"
        from_port = var.ssh_port
        to_port = var.ssh_port
        cidr_blocks = [ var.cidr_all ]
    }

    ingress {   
        description = " http access"    
        protocol = "tcp"
        from_port =var.http_port
        to_port = var.http_port
        cidr_blocks = [ var.cidr_all ]
    }

    ingress {   
        description = " https access"    
        protocol = "tcp"
        from_port = var.https_port
        to_port = var.https_port
        cidr_blocks = [ var.cidr_all]
    }
    ingress {   
        description = " https access"    
        protocol = "-1"
        from_port =0
        to_port = 0
        cidr_blocks = [ var.cidr_all ]
    }
    
    egress  {
        description = "egress to internet"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [var.cidr_all]
    }

      tags = {
    Name = "Private security group"
    env = "production"
    ManagedBy = "Terraform"	
  }
  
}