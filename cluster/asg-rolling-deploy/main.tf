data "aws_ec2_instance_type" "instance" {
  instance_type = var.instance_type
}

resource "aws_launch_template" "example" {
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = var.user_data
  update_default_version = true

  lifecycle {
    precondition {
      condition = data.aws_ec2_instance_type.instance.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS Free Tier!"
    }
  }
}

resource "aws_autoscaling_group" "example" {
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.example.id
    version = aws_launch_template.example.latest_version
  }

  target_group_arns = var.target_group_arn
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    postcondition {
      condition = length(self.availability_zones) > 1
      error_message = "You must use more than one AZ for high availability!"
    }
  }
}

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance-sg"
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id
  from_port         = var.server_port
  to_port           = var.server_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance.id
  from_port         = 22
  to_port           = 22
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}
