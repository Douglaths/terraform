# Provider de AWS en Norte de Virgina
provider "aws" {
  region = "us-east-1"
}
# Creamos la VPC en el rango definido
resource "aws_vpc" "vpc_cloud_2" {
  cidr_block           = "30.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cloud2_vpc"
  }
}

# Creamos nuestro IG(internet gateway) para la salida a internet publicas
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_cloud_2.id
  tags = {
    Name = "Cloud2ig"
  }
}

# Configuramos la primera red pública en otra zona de disponibilidad
resource "aws_subnet" "First_public_subnet" {
  vpc_id                  = aws_vpc.vpc_cloud_2.id
  cidr_block              = "30.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "FirstPublicSubnet"
  }
}

# Definimos la segunda red pública en la misma zona de disponibilidad
resource "aws_subnet" "second_public_subnet" {
  vpc_id                  = aws_vpc.vpc_cloud_2.id
  cidr_block              = "30.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "SecondPublicSubnet"
  }
}

# Definimos la primera red privada en la misma zona que la primera red pública
resource "aws_subnet" "first_private_subnet" {
  vpc_id            = aws_vpc.vpc_cloud_2.id
  cidr_block        = "30.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "FirstPrivateSubnet"
  }
}

# Establecemos la segunda red privada en la zona de la segunda red pública
resource "aws_subnet" "second_private_subnet" {
  vpc_id            = aws_vpc.vpc_cloud_2.id
  cidr_block        = "30.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "SecondPrivateSubnet"
  }
}


# Creamos la tabla de rutas para las Subredes Públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_cloud_2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}
# Asociamos tabla de rutas públicas con la Primera Subred Pública para su conexion a internet
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.first_public_subnet.id 
  route_table_id = aws_route_table.public_route_table.id
}
# Asociamos tabla de rutas públicas con la Segunda Subred Pública para su conexion a internet
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.second_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
# Creamos tabla de rutas para Subredes Privadas 
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_cloud_2.id
  tags = {
    Name = "PrivateRouteTable"
  }
}
# Asociamos tabla de rutas Privadas con la primera Subred Privada
resource "aws_route_table_association" "private_association_1" {
  subnet_id      = aws_subnet.first_private_subnet.id 
  route_table_id = aws_route_table.private_route_table.id
}
# Asociamos tabla de rutas Privadas con la Segunda Subred Privada
resource "aws_route_table_association" "private_association_2" {
  subnet_id      = aws_subnet.second_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}