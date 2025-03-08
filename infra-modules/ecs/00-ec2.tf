data "aws_ssm_parameter" "this" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "this" {
  name_prefix            = "${var.env}-ecs-cluster-node-lt-"
  image_id               = data.aws_ssm_parameter.this.value
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.this.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config;

      # Enable and start the SSM agent
      systemctl enable amazon-ssm-agent
      systemctl start amazon-ssm-agent

    EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.env}-ecs-asg"
  vpc_zone_identifier       = var.private_subnets_ids
  min_size                  = 2
  max_size                  = 3
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false
  

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.env}-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

## Need an ec2 instance connection endpoint for ssm to private subnet ec2's
## Written slightly different to a 'count' for loop
resource "aws_ec2_instance_connect_endpoint" "private_asg" {
  for_each = var.private_subnets_ids[*]
  subnet_id = each.value
}

