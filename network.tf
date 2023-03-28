#Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc"
  }
}

#Create Public Subnets
resource "aws_subnet" "pub-sub-A" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public A subnet"
  }
}

resource "aws_subnet" "pub-sub-B" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public B subnet"
  }
}

#Create Private Subnets
resource "aws_subnet" "priv-sub-A" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private A subnet"
  }
}

resource "aws_subnet" "priv-sub-B" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.14.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private B subnet"
  }
}

#Create Data Base Subnets
resource "aws_subnet" "db-sub-A" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.15.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "DB subnet A"
  }
}

resource "aws_subnet" "db-sub-B" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.16.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "DB subnet B"
  }
}

#Create Elastic Ip for Nat
resource "aws_eip" "elastic-ip" {
  tags = {
    Name = "ip for NAT"
  }
}


#Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "intenet gateway"
  }
}

#Create NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.pub-sub-A.id
  tags = {
    Name = "nat-gateway"
  }
}

#Create Route table for Public Subnets
resource "aws_route_table" "pub-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route"
  }
}

#Add Public Subnets to Route
resource "aws_route_table_association" "pub-1" {
  subnet_id      = aws_subnet.pub-sub-A.id
  route_table_id = aws_route_table.pub-route.id
}

resource "aws_route_table_association" "pub-2" {
  subnet_id      = aws_subnet.pub-sub-B.id
  route_table_id = aws_route_table.pub-route.id
}

#Create Route table for Private Subnets
resource "aws_route_table" "priv-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "Private Route"
  }
}

#Add Private Subnets to Route
resource "aws_route_table_association" "priv-1" {
  subnet_id      = aws_subnet.priv-sub-A.id
  route_table_id = aws_route_table.priv-route.id
}

resource "aws_route_table_association" "priv-2" {
  subnet_id      = aws_subnet.priv-sub-B.id
  route_table_id = aws_route_table.priv-route.id
}
