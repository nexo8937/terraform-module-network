output "vpc" {
  value = aws_vpc.vpc.id
}

output "db-subnet-A" {
  value = aws_subnet.db-sub-A.id
}
 
output "db-subnet-B" {
  value = aws_subnet.db-sub-B.id
}

