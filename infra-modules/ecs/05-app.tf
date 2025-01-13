# resource "aws_lb_target_group" "react" {
#   name     = "${var.env}-react-tg"
#   target_type = "ip"
#   port     = 3000
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#
#   health_check {
#     enabled             = true
#     interval            = 300
#     port                = 3002
#     protocol            = "HTTP"
#     path                = "/"  # Adjust if needed
#     timeout             = 60
#     healthy_threshold   = 2
#     matcher             = "200"
#   }
#
#   tags = {
#     Name = "${var.env}-react-tg"
#   }
# }
#
# resource "aws_lb_target_group" "rails" {
#   name     = "${var.env}-rails-tg"
#   target_type = "ip"
#   port     = 3001
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#
#   health_check {
#     enabled             = true
#     interval            = 300
#     port                = 3000
#     protocol            = "HTTP"
#     path                = "/"  # Adjust if needed for Rails health check
#     timeout             = 60
#     healthy_threshold   = 2
#     matcher             = "200"
#   }
#
#   tags = {
#     Name = "${var.env}-rails-tg"
#   }
# }
#
# resource "aws_lb_target_group" "adminer" {
#   name     = "${var.env}-adminer-tg"
#   target_type = "ip"
#   port     = 8082
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#
#   health_check {
#     enabled             = true
#     interval            = 300
#     port                = 8082
#     protocol            = "HTTP"
#     path                = "/"  # Adminer's health check path
#     timeout             = 60
#     healthy_threshold   = 2
#     matcher             = "200"
#   }
#
#   tags = {
#     Name = "${var.env}-adminer-tg"
#   }
# }
#
# resource "aws_ecs_task_definition" "app" {
#   family                   = "my-multi-tier-app"
#   task_role_arn      = aws_iam_role.ecs_task_role.arn
#   execution_role_arn = aws_iam_role.ecs_node_role.arn
#   requires_compatibilities = ["EC2"]
#   network_mode             = "awsvpc"  # Ensure this matches your ECS setup, could be "awsvpc" if using VPC networking
#
#   cpu    = "1024"  # Total CPU units for the task (adjust based on container needs)
#   memory = "4096"  # Total memory in MiB for the task (adjust based on container needs)
#
#   container_definitions = jsonencode([
#     {
#       name  = "react"
#       image = "node:20.14.0-alpine3.19"
#       essential = true
#       command = ["sh", "-c", "npm i && npm run dev --port 3002"]
#       workingDirectory = "/app"
#       mountPoints = [
#         {
#           sourceVolume = "react-volume"
#           containerPath = "/app"
#         }
#       ]
#       portMappings = [
#         {
#           containerPort = 3002
#           hostPort      = 3002
#         }
#       ]
#       memoryReservation = 512  # 512 MB
#     },
#     {
#       name  = "rails"
#       image = "891377081827.dkr.ecr.ca-central-1.amazonaws.com/ecr-rails-bank-trx-reporting:v1.0.3"  # You'll need to build and push this image to ECR or another registry
#       essential = true
#       environment = [
#         { name = "RAILS_ENV", value = "development" },
#         { name = "APP_DATABASE_PASSWORD", value = "znsoorcM9pGb" },
#         { name = "RAILS_MAX_DB_CONNECTIONS", value = "5" },
#         { name = "REDIS_URL", value = "redis://redis:6379/1" },
#         { name = "BUNDLE_PATH", value = "vendor/bundle" }
#       ]
#       mountPoints = [
#         {
#           sourceVolume = "rails-volume"
#           containerPath = "/rails"
#         }
#       ]
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#         }
#       ]
#       memoryReservation = 1024  # 1024 MB
#     },
#     {
#       name  = "sidekiq"
#       image = "891377081827.dkr.ecr.ca-central-1.amazonaws.com/ecr-rails-bank-trx-reporting:v1.0.3"  # Same as rails container
#       essential = true
#       command = ["bundle", "exec", "sidekiq"]
#       environment = [
#         { name = "RAILS_ENV", value = "development" },
#         { name = "APP_DATABASE_PASSWORD", value = "znsoorcM9pGb" },
#         { name = "RAILS_MAX_DB_CONNECTIONS", value = "5" },
#         { name = "REDIS_URL", value = "redis://redis:6379/1" },
#         { name = "BUNDLE_PATH", value = "vendor/bundle" }
#       ]
#       mountPoints = [
#         {
#           sourceVolume = "rails-volume"
#           containerPath = "/rails"
#         }
#       ]
#       memoryReservation = 512  # 512 MB
#     },
#     {
#       name  = "postgres"
#       image = "postgres:16.3"
#       essential = true
#       environment = [
#         { name = "POSTGRES_DB", value = "rails" },
#         { name = "POSTGRES_USER", value = "rails" },
#         { name = "POSTGRES_PASSWORD", value = "znsoorcM9pGb" }
#       ]
#       mountPoints = [
#         {
#           sourceVolume = "postgres-data"
#           containerPath = "/var/lib/postgresql/data"
#         },
#         {
#           sourceVolume = "postgres-init"
#           containerPath = "/docker-entrypoint-initdb.d"
#         }
#       ]
#       portMappings = [
#         {
#           containerPort = 5432
#           hostPort      = 5432
#         }
#       ]
#       memoryReservation = 1024  # 1024 MB
#     },
#     {
#       name  = "adminer"
#       image = "adminer:4.8.1"
#       essential = false  # Adminer isn't critical for the app to run
#       environment = [
#         { name = "ADMINER_DEFAULT_SERVER", value = "postgres" },
#         { name = "ADMINER_DEFAULT_USER", value = "rails" },
#         { name = "ADMINER_DEFAULT_PASSWORD", value = "znsoorcM9pGb" },
#         { name = "ADMINER_DEFAULT_TYPE", value = "postgresql" },
#         { name = "ADMINER_DEFAULT_PORT", value = "5432" },
#         { name = "ADMINER_DEFAULT_DB", value = "rails" }
#       ]
#       portMappings = [
#         {
#           containerPort = 8080
#           hostPort      = 8080
#         }
#       ]
#       memoryReservation = 128  # 128 MB
#     },
#     {
#       name  = "redis"
#       image = "redis:7.2.3-alpine"
#       essential = true
#       mountPoints = [
#         {
#           sourceVolume = "redis-data"
#           containerPath = "/data"
#         }
#       ]
#       portMappings = [
#         {
#           containerPort = 6379
#           hostPort      = 6379
#         }
#       ]
#       memoryReservation = 256  # 256 MB
#     }
#   ])
#
#   volume {
#   name      = "react-volume"
#   host_path = "/mnt/ecs/react"  # Absolute path for React
# }
#
# volume {
#   name      = "rails-volume"
#   host_path = "/mnt/ecs/rails"  # Absolute path for Rails
# }
#
# volume {
#   name      = "postgres-data"
#   host_path = "/mnt/ecs/postgres/data"  # Absolute path for PostgreSQL data
# }
#
# volume {
#   name      = "postgres-init"
#   host_path = "/mnt/ecs/postgres/init"  # Absolute path for PostgreSQL init scripts
# }
#
# volume {
#   name      = "redis-data"
#   host_path = "/mnt/ecs/redis/data"  # Absolute path for Redis
# }
# }
#
# resource "aws_ecs_service" "app_service" {
#   name            = "${var.env}-app-service"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.app.arn
#   launch_type     = "EC2"
#
#   network_configuration {
#     subnets         = var.public_subnets_ids
#     security_groups = [aws_security_group.this.id]
#   }
#
#   desired_count = 2
#
#   load_balancer {
#     target_group_arn = aws_lb_target_group.react.arn
#     container_name   = "react"
#     container_port   = 3002
#   }
#
#   load_balancer {
#     target_group_arn = aws_lb_target_group.rails.arn
#     container_name   = "rails"
#     container_port   = 3000
#   }
#
#   deployment_maximum_percent = 200
#   deployment_minimum_healthy_percent = 50
#
#   tags = {
#     Name = "${var.env}-app-service"
#   }
# }
#
# # Define EFS file systems for each volume
#
# # React Volume
# resource "aws_efs_file_system" "react" {
#   creation_token = "${var.env}-react"
#   tags = {
#     Name = "${var.env}-react-efs"
#   }
# }
#
# resource "aws_efs_mount_target" "react_mount" {
#   count           = length(var.private_subnets_ids)
#   file_system_id  = aws_efs_file_system.react.id
#   subnet_id       = var.private_subnets_ids[count.index]
#   security_groups = [aws_security_group.efs.id]
# }
#
# # Rails Volume
# resource "aws_efs_file_system" "rails" {
#   creation_token = "${var.env}-rails"
#   tags = {
#     Name = "${var.env}-rails-efs"
#   }
# }
#
# resource "aws_efs_mount_target" "rails_mount" {
#   count           = length(var.private_subnets_ids)
#   file_system_id  = aws_efs_file_system.rails.id
#   subnet_id       = var.private_subnets_ids[count.index]
#   security_groups = [aws_security_group.efs.id]
# }
#
# # Postgres Data Volume
# resource "aws_efs_file_system" "postgres" {
#   creation_token = "${var.env}-postgres"
#   tags = {
#     Name = "${var.env}-postgres-efs"
#   }
# }
#
# resource "aws_efs_mount_target" "postgres_mount" {
#   count           = length(var.private_subnets_ids)
#   file_system_id  = aws_efs_file_system.postgres.id
#   subnet_id       = var.private_subnets_ids[count.index]
#   security_groups = [aws_security_group.efs.id]
# }
#
# # Redis Data Volume
# resource "aws_efs_file_system" "redis" {
#   creation_token = "${var.env}-redis"
#   tags = {
#     Name = "${var.env}-redis-efs"
#   }
# }
#
# resource "aws_efs_mount_target" "redis_mount" {
#   count           = length(var.private_subnets_ids)
#   file_system_id  = aws_efs_file_system.redis.id
#   subnet_id       = var.private_subnets_ids[count.index]
#   security_groups = [aws_security_group.efs.id]
# }
#
# # Security Group for EFS
# resource "aws_security_group" "efs" {
#   name        = "${var.env}-efs-sg"
#   description = "Allow inbound NFS traffic from ECS tasks"
#   vpc_id      = var.vpc_id
#
#   ingress {
#     from_port   = 2049
#     to_port     = 2049
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr_block]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
#
#    resource "aws_lb_listener" "react" {
#      load_balancer_arn = aws_lb.this.arn
#      port              = 3002
#      protocol          = "HTTP"
#
#      default_action {
#        type             = "forward"
#        target_group_arn = aws_lb_target_group.react.arn
#      }
#    }
#
#    resource "aws_lb_listener" "rails" {
#      load_balancer_arn = aws_lb.this.arn
#      port              = 3000
#      protocol          = "HTTP"
#
#      default_action {
#        type             = "forward"
#        target_group_arn = aws_lb_target_group.rails.arn
#      }
#    }
#
#    resource "aws_lb_listener" "adminer" {
#      load_balancer_arn = aws_lb.this.arn
#      port              = 8080
#      protocol          = "HTTP"
#
#      default_action {
#        type             = "forward"
#        target_group_arn = aws_lb_target_group.adminer.arn
#      }
#    }
