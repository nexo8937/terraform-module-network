#LOAD BALANCER SECURITY GROUP
resource "aws_security_group" "lb-sg" {
  name        = "load balancer sg"
  vpc_id      = var.vpc.id
  description = "Allow HTTP and HTTPS traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Load Balances sg"
  }
}


#WEB SERVER SECURITY GROUP
resource "aws_security_group" "web-server" {
  name        = "wordpresssg"
  vpc_id      = var.vpc.id
  description = "Allow http"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web server sg"
  }
}

#RDS SECURITY GROUP
resource "aws_security_group" "rds" {
  name        = "rdssg"
  vpc_id      = var.vpc.id
  description = "Allow mysql 3306 traffic"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web-server.id, aws_security_group.image-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "RDS sg"
  }
}

# image SECURITY GROUP
resource "aws_security_group" "image-sg" {
  name        = "image-sgsss"
  vpc_id      = var.vpc.id
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "image sg"
  }
}
#Output
#output "image-sg-id" {
#  value = aws_security_group.image-sg.id
#}

#variable
variable "vpc" {}
