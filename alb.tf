module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "gatmauel-alb"

  load_balancer_type = "application"

  vpc_id = aws_default_vpc.default.id
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]
  security_groups = [aws_security_group.allow_http.id]

  target_groups = [
    {
      name = "tf-gatmauel-lb-tg"
      backend_protocol = "HTTP"
      backend_port = 80
      target_type = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port = 80
      protocol = "HTTP"
      action_type = "forward"
      target_group_index = 0
    }
  ]
}