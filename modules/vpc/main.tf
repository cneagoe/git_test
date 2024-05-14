resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "main_vpc"
    }
}

resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet1_cidr
    map_public_ip_on_launch = true
    availability_zone = var.availability_zone1
    tags = {
        Name = "public_subnet1"
    }
}

resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet2_cidr
    map_public_ip_on_launch = true
    availability_zone = var.availability_zone2
    tags = {
        Name = "public_subnet2"
    }
}

resource "aws_subnet" "private_subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet1_cidr
    availability_zone = var.availability_zone1
    tags = {
        Name = "private_subnet1"
    }
}

resource "aws_subnet" "private_subnet2" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet2_cidr
    availability_zone = var.availability_zone2
    tags = {
        Name = "private_subnet2"
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}