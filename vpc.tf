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
