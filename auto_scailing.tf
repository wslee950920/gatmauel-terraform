resource "aws_ami_from_instance" "gatmauel" {
  name = "gatmauelAMI"
  source_instance_id = aws_instance.gatmauel.id
}

resource "aws_launch_template" "gatmauel" {
  name = "gatmauel-launch-template"

  image_id = aws_ami_from_instance.gatmauel.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id, aws_security_group.allow_http.id, aws_default_security_group.default.id]

  key_name = "gatmauel"
}

resource "aws_autoscaling_group" "gatmauel" {
  name = "gatmauel-auto-scaling-group"

  max_size = 3
  min_size = 1
  desired_capacity = 1

  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id, aws_default_subnet.default_az3.id]

  launch_template {
    id      = aws_launch_template.gatmauel.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu-utilization" {
  name                   = "gatmauel-cpu-utilization"
  autoscaling_group_name = aws_autoscaling_group.gatmauel.name

  adjustment_type = "ExactCapacity"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 90.0
  }
}

resource "aws_autoscaling_attachment" "gatmauel" {
  autoscaling_group_name = aws_autoscaling_group.gatmauel.id
  alb_target_group_arn = module.alb.target_group_arns[0]

  depends_on = [
    aws_autoscaling_group.gatmauel,
    module.alb
  ]
}



