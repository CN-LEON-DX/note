terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev_vpc"
  }
}
# enable_dns_hostnames => EC2 has dns name or not ?
# enable_dns_support => enable for most services for DNS resolver

resource "aws_subnet" "dev-pub-01" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.ZONE1
  tags = {
    Name = "dev-pub-01"
  }
}

resource "aws_subnet" "dev-pub-02" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true" # auto map ipv4 to your instance
  availability_zone = var.ZONE2
  tags = {
    Name = "dev-pub-02"
  }
}

resource "aws_subnet" "dev-pub-03" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true" # auto map ipv4 to your instance
  availability_zone = var.ZONE3
  tags = {
    Name = "dev-pub-03"
  }
}

#----------------------------------------
# Private subnet
resource "aws_subnet" "dev-private-01" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.ZONE1
  tags = {
    Name = "dev-private-01"
  }
}

resource "aws_subnet" "dev-private-02" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.ZONE2
  tags = {
    Name = "dev-private-02"
  }
}

resource "aws_subnet" "dev-private-03" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = var.ZONE3
  tags = {
    Name = "dev-private-03"
  }
}

#----------------------------------------
# Internet Gateway
resource "aws_internet_gateway" "dev-IGW" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "dev-IGW"
  }
}

#----------------------------------------
# Route table
resource "aws_route_table" "dev-pub-RT" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-IGW.id
  }

  tags = {
    Name = "dev-pub-RT"
  }
}

#------------------------------------------------------
# Route table Association
resource "aws_route_table_association" "dev-pub-1-a" {
  subnet_id = aws_subnet.dev-pub-01.id
  route_table_id = aws_route_table.dev-pub-RT.id
}

resource "aws_route_table_association" "dev-pub-2-a" {
  subnet_id = aws_subnet.dev-pub-02.id
  route_table_id = aws_route_table.dev-pub-RT.id
}

resource "aws_route_table_association" "dev-pub-3-a" {
  subnet_id = aws_subnet.dev-pub-03.id
  route_table_id = aws_route_table.dev-pub-RT.id
}


