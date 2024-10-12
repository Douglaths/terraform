resource "aws_instance" "ec2_pub1" {
  ami                         = "ami-00f251754ac5da7f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.first_public_subnet.id
  key_name                    = "cloud2_vpc"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  user_data                   = file("command1.sh")

  tags = {
    Name = "pub1_ec2"
  }
}

resource "aws_instance" "ec2_pub2" {
  ami                         = "ami-00f251754ac5da7f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.second_public_subnet.id
  key_name                    = "cloud2_vpc"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  user_data                   = file("command2.sh")

  tags = {
    Name = "pub2_ec2"
  }
}