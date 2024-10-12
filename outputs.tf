output "vpc_id" {
  description = "El ID de la VPC"
  value       = aws_vpc.vpc_cloud_2.id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = [aws_subnet.first_public_subnet.id, aws_subnet.second_public_subnet.id]
}

output "private_subnets" {
  description = "IDs de las subnets privadas"
  value       = [aws_subnet.first_private_subnet.id, aws_subnet.second_private_subnet.id]
}