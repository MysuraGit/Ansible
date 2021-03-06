# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_vpc" "Test-vpc" {
  cidr_block       = var.Dev-vpc
  instance_tenancy = "default"
  enable_dns_support = true 
  enable_dns_hostnames = true 

  tags = {
    Name = "Test_vpc"
  }
}

# create Public aws_subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.Test-vpc.id
  cidr_block = var.public-subnet-1
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true 
  tags = {
    Name = "Public_subnet_1"
  }
}
# create private aws_subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.Test-vpc.id
  cidr_block = var.privat-subnet-1
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = false  

  tags = {
    Name = "Private_subnet_1"
  }
}

# create Internet Gatway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.Test-vpc.id

  tags = {
    Name = "Test_IGW"
  }
}
# create Route Table
resource "aws_route_table" "Test-Route-Table" {
  vpc_id = aws_vpc.Test-vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet_gateway.id
    }
  tags = {
    Name = "Test-Route-Table"
  }
}
# attach route_table_association
resource "aws_route_table_association" "public-subnet-1-route_table_association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.Test-Route-Table.id
}
# Security Group
resource "aws_security_group" "Test-SG" {
  name        = "Test_sg"
  description = "Allow limited inbound external traffic"
  vpc_id      = aws_vpc.Test-vpc.id

  ingress {
      description      = "allow from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }
  
  ingress {
      description      = "allow from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      
    }

  tags = {
    Name = "Test-SG"
  }
}
resource "aws_instance" "web" {
  ami           = "ami-073998ba87e205747" # us-west-2
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.Test-SG.id] # Security Group Yeppudu EEE formate lo ["aws_security_group.Test-SG.id"] unchali
  availability_zone = "ap-southeast-1a"
  associate_public_ip_address = true
  key_name = "Dmysuar"
tags = {
    Name = "jenkins"
  }
}

# DB sErver
resource "aws_instance" "dev" {
  ami           = "ami-073998ba87e205747" # us-west-2
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.private-subnet-1.id
  vpc_security_group_ids = [aws_security_group.Test-SG.id] # Security Group Yeppudu EEE formate lo ["aws_security_group.Test-SG.id"] unchali
  availability_zone = "ap-southeast-1b"
  
  key_name = "Dmysuar"
tags = {
    Name = "jenkins"
  }
}