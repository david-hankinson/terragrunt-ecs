resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id] #  # ALB security groups
  subnets            = var.public_subnets_ids       ## Use private subnets

  enable_deletion_protection = false
  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "nginx" {
  name        = "${var.env}-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled           = true
    interval          = 300
    port              = 80
    protocol          = "HTTP"
    path              = "/"
    timeout           = 60
    healthy_threshold = 2
    matcher           = "200"
  }

  tags = {
    Name = "${var.env}-tg"
  }
}

resource "aws_lb_listener" "nginx_http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

resource "aws_eip" "this" {
  for_each = { for idx, subnet_id in var.private_subnets_ids : idx => subnet_id }
  tags     = { Name = "${var.env}-eip" }
}

# resource "aws_route_table" "this" {
#   vpc_id = var.vpc_id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = var.internet_gw_id
#   }
# }

# resource "aws_route_table_association" "public_subnets" {
#   for_each = { for idx, subnet_id in var.public_subnets_ids : idx => subnet_id }

#   subnet_id      = each.value
#   route_table_id = aws_route_table.this.id
# }

# resource "aws_route_table" "nat_rt" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this.id
#   }

#   tags = {
#     Name = "${var.env}-nat-rt"
#   }
# }

# resource aws_route_table_association "private_subnets" {
#   for_each = { for idx, subnet_id in var.private_subnets_ids : idx => subnet_id }

#   subnet_id      = each.value
#   route_table_id = aws_route_table.nat_rt.id
# }

# Route Table for Private Subnets (to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  # Route 1: Intra-VPC traffic to local
  route {
    cidr_block = var.vpc_cidr_block  # e.g., "10.0.0.0/16"
    gateway_id = "local"
  }

  # Route 2: All other traffic to NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.env}-private-rt"
  }
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private_subnets" {
  for_each       = { for idx, subnet_id in var.private_subnets_ids : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

# Route Table for Public Subnets (to Internet Gateway)
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  # Route 1: Intra-VPC traffic to local
  route {
    cidr_block = var.vpc_cidr_block  # e.g., "10.0.0.0/16"
    gateway_id = "local"
  }

  # Route 2: All other traffic to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gw_id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public_subnets" {
  for_each       = { for idx, subnet_id in var.public_subnets_ids : idx => subnet_id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}