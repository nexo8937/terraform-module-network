output "vpc" {
  value = aws_vpc.vpc.id
}

output "db-subnet-A" {
  value = aws_subnet.db-sub-A.id
}
 
output "db-subnet-B" {
  value = aws_subnet.db-sub-B.id
}

output "pub-subnet-A" {
  value = aws_subnet.pub-sub-A.id
}


output "pub-subnet-B" {
  value = aws_subnet.pub-sub-B.id
}

output "priv-subnet-A" {
  value = aws_subnet.priv-sub-A.id
}


output "priv-subnet-B" {
  value = aws_subnet.priv-sub-B.id
}
