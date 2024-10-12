resource "aws_lb_target_group" "my_target_group" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_cloud_2.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
  }

  target_type = "instance"
}

resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.first_public_subnet.id, aws_subnet.second_public_subnet.id]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.ec2_pub1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.ec2_pub2.id
  port             = 80
}