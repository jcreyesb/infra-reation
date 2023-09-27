output "vpc_id" {
  value = aws_vpc.vpc.id 
  }

output "public-subnet-1" {
  value = aws_subnet.public-subnet-1.id
}
output "public-subnet-2" {
  value = aws_subnet.public-subnet-2.id
}
output "public-subnet-3" {
  value = aws_subnet.public-subnet-3.id
}

output "private-subnet-1" {
 value = aws_subnet.private-subnet-1.id
}
output "private-subnet-2" {
  value = aws_subnet.private-subnet-2.id
}
output "private-subnet-3" {
 value =  aws_subnet.private-subnet-3.id
}
output "public-route-table" {
 value =  aws_route_table.public-route-table.id
}

output "internet-gateway" {
 value =  aws_internet_gateway.internet-gateway
}

output "public-subnet-1-route-table-association" {
 value =  aws_route_table_association.public-subnet-1-route-table-association
}

output "public-subnet-2-route-table-association" {
 value =  aws_route_table_association.public-subnet-2-route-table-association

}

output "public-subnet-3-route-table-association" {
 value =  aws_route_table_association.public-subnet-3-route-table-association
}

output "eip-nat-gateway1" {
  value  = aws_eip.eip-nat-gateway1
}

output "nat-gateway1" {
  value  = aws_nat_gateway.nat-gateway-1
}

output "private-route-table" {
  value       = aws_route_table.private-route-table
}

output "private-subnet-1-route-table-association" {
 value =  aws_route_table_association.private-subnet-1-route-table-association
}

output "private-subnet-2-route-table-association" {
 value =  aws_route_table_association.private-subnet-2-route-table-association
}

output "private-subnet-3-route-table-association" {
 value =  aws_route_table_association.private-subnet-3-route-table-association
}
