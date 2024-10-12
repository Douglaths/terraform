resource "aws_db_instance" "my_rds_instance" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0.32"  
  instance_class       = "db.t3.micro"  
  db_name              = "db_rds_douglaths"  
  username             = "admin"  
  password             = "password"  
  parameter_group_name = "default.mysql8.0"  
  skip_final_snapshot  = true
  publicly_accessible  = true  

  vpc_security_group_ids = [aws_security_group.rds_sg.id]  
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name  

  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.first_public_subnet.id, aws_subnet.second_public_subnet.id]  

  tags = {
    Name = "MyDBSubnetGroup"
  }
}