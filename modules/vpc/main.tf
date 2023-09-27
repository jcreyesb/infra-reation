# create VPC
# Terraform aws create vpc
resource "aws_vpc" "vpc" {
     cidr_block           = var.cidr
     instance_tenancy      =  "default"
     enable_dns_hostnames = true

     tags    = {
        Name = "${var.proyecto}-vpc"
        Env = var.env
        Provisioner = "terraform"
    }
}

resource "aws_internet_gateway"  "internet-gateway" {
    vpc_id = aws_vpc.vpc.id
     
     
}


resource "aws_subnet" "public-subnet-1"{
     vpc_id                  = aws_vpc.vpc.id
     cidr_block              = "${var.public-subnet-1-cidr}"
     availability_zone       = var.zone1
     map_public_ip_on_launch = true
	
     tags    = {
 	     
        Name = "Public Subnet 1" 
 	    Env = var.env
        Provisioner = "terraform"	
        
     }
}


# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = var.zone2
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 2"
    Env = var.env
    Provisioner = "terraform"
  }
}


# Create Public Subnet 3
# terraform aws create subnet
resource "aws_subnet" "public-subnet-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-3-cidr}"
  availability_zone       = var.zone3
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 3"
    Env = var.env
    Provisioner = "terraform"
  }
}

resource "aws_route_table" "public-route-table"{
     vpc_id               = aws_vpc.vpc.id
     route {
        cidr_block        =  var.cidr_all
        gateway_id        = aws_internet_gateway.internet-gateway.id
     }
     tags    = {
     
        Name = "public Route Table"
        Env = var.env
        Provisioner = "terraform"		
        
     }

}

resource "aws_route_table_association" "public-subnet-1-route-table-association" {

     subnet_id   = aws_subnet.public-subnet-1.id
     route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "public-subnet-2-route-table-association" {

     subnet_id   = aws_subnet.public-subnet-2.id
     route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "public-subnet-3-route-table-association" {

     subnet_id   = aws_subnet.public-subnet-3.id
     route_table_id = aws_route_table.public-route-table.id
}


resource "aws_subnet" "private-subnet-1"{
     vpc_id                  = aws_vpc.vpc.id
     cidr_block              = "${var.private-subnet-1-cidr}"
     availability_zone       = var.zone1
     map_public_ip_on_launch = false
	
     tags    = {
 		
       Name = "private subnet 1 | App Tier"
       Env = var.env
       Provisioner = "terraform"
     }
}

resource "aws_subnet" "private-subnet-2"{
     vpc_id                  = aws_vpc.vpc.id
     cidr_block              = "${var.private-subnet-2-cidr}"
     availability_zone       = var.zone2
     map_public_ip_on_launch = false
	
     tags    = {
 		
        Name = "private subnet 2 | App Tier "
        Env = var.env
        Provisioner = "terraform"
     }
}

resource "aws_subnet" "private-subnet-3"{
     vpc_id                  = aws_vpc.vpc.id
     cidr_block              = "${var.private-subnet-3-cidr}"
     availability_zone       = var.zone3
     map_public_ip_on_launch = false
	
     tags    = {
 		
        Name = "private subnet 3 | Database Tier "
        Env = var.env
        Provisioner = "terraform"
     }
}


############################   nat gteway #############33

#allocate Elastic ip 
 
 resource "aws_eip" "eip-nat-gateway1" {
   vpc   = true
 tags    = {
 		
        Name = "Elastic ip 1 "
        env = "production"
        provisioner = "terraform"
     }


 }

#Create Nat Gateway 1 in plubic subnet 1
resource "aws_nat_gateway" "nat-gateway-1" {
   allocation_id = aws_eip.eip-nat-gateway1.id
   subnet_id = aws_subnet.public-subnet-1.id 
tags    = {
 		
        Name = "Nat Gateway Public  1"
        env = "production"
        provisioner = "terraform"
     }

 }


resource "aws_route_table" "private-route-table"{
     vpc_id  = aws_vpc.vpc.id
     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-gateway-1.id
     }
     tags    = {
     
        env = "production"
        provisioner = "terraform"		
        Name = "private Route Table"
     }

}

resource "aws_route_table_association" "private-subnet-1-route-table-association" {

     subnet_id   = aws_subnet.private-subnet-1.id
     route_table_id = aws_route_table.private-route-table.id
}
resource "aws_route_table_association" "private-subnet-2-route-table-association" {

     subnet_id   = aws_subnet.private-subnet-2.id
     route_table_id = aws_route_table.private-route-table.id
}
resource "aws_route_table_association" "private-subnet-3-route-table-association" {

     subnet_id   = aws_subnet.private-subnet-3.id
     route_table_id = aws_route_table.private-route-table.id
}


