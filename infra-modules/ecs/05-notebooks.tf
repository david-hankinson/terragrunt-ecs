resource "aws_ecs_task_definition" "jupyter" {
  family             = "${var.env}-jupyter"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_node_role.arn
  network_mode       = "awsvpc"
  cpu                = 256
#   memory             = 256

  container_definitions = jsonencode([
    {
      name        = "jupyter",
      image       = "jupyter/minimal-notebook:latest",
      memory      = 256,
      cpu         = 256,
      essential   = true,
      portMappings = [
        {
          containerPort = 8888,
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.id
          awslogs-region        = "ca-central-1",
          awslogs-stream-prefix = "jupyter-"
        }
      }
    }
  ])
}

# Define the ECS service that will run the task
resource "aws_ecs_service" "jupyter" {
      depends_on = [aws_lb.this]

  name            = "${var.env}-juypter-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.jupyter.arn
  desired_count   = 2

  network_configuration {
    subnets         = var.private_subnets_ids
    security_groups = [aws_security_group.this.id]
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this.name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jupyter.arn
    container_name = "jupyter"
    container_port = 8888
  }
}