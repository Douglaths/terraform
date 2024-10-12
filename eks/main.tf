# Provider de AWS
provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "vpc_cloud_2" {
  cidr_block       = "30.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo_eks_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc_cloud_2.id
  cidr_block        = "30.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc_cloud_2.id
  cidr_block        = "30.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"  # Cambiada a us-east-1b

  tags = {
    Name = "my_public_subnet_2"
  }
}

# Crear una Gateway de Internet para las subnets públicas
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_cloud_2.id

  tags = {
    Name = "internet_gateway_eks"
  }
}

# Crear una tabla de rutas para las subnets públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_cloud_2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route_table_public"
  }
}

# Asociar subnets públicas a la tabla de rutas pública
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}