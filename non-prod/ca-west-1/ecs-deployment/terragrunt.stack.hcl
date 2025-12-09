locals { 
  name = "ecs-deploy"
  env = "non-prod"
}

unit "vpc" {

  source = "git::https://github.com/david-hankinson/terragrunt-module-vpc.git//units/network"
  
  path = "units/network"

  values = {
  # Environment
  # env                      = local.env

  # VPC Configuration
  vpc_cidr_block           = "10.1.0.0/16"

  # Subnet Configuration
  public_subnets           = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets          = ["10.1.3.0/24", "10.1.4.0/24"]

  # Security Groups
  allowed_ssh_cidr_blocks  = ["10.1.0.0/16"] 
  # Restrict SSH
}

}

# unit "ecs-deploy" {
#   source = "ecs-deploy"
#   path = "git::https://github.com/david-hankinson/terragrunt-module-ecs.git//ecs?ref="

#   values = {
#       ## env inputs
#   env                      = local.env

#   ## ec2 inputs
#   # ec2_instance_type = "t3.medium"
#   # // vpc_zone_identifier is now typically passed via dependency injection from the stack wiring.
#   # // In the latest Terragrunt deployment patterns, you can reference outputs from other units directly.
#   # // For example, if your unit is named "network", use:
#   vpc_zone_identifier = network.outputs.public_subnets_ids

#   network_path = "../network"

#   ## ecs inputs
#   aws_ecs_cluster_name = "non-prod-ecs-cluster"
#   aws_ecs_capacity_provider_name = "non-prod-capacity-provider"
#   aws_ecs_task_definition_family = "non-prod-td-family"
#   ecs_minimum_scaling_step_size = 1
#   ecs_maximum_scaling_step_size = 2
#   ecs_target_capacity_percentage = 80
#   vpc_sg = network.outputs.vpc_sg
#   vpc_id = network.outputs.vpc_id
#   vpc_security_group_ids = vpc_sg
#   public_subnets_ids = network.outputs.public_subnets_ids
#   private_subnets_ids = network.outputs.private_subnets_ids
#   vpc_cidr_block = network.outputs.vpc_cidr_block
#   internet_gw_id = network.outputs.internet_gw_id
#   }

# }
# 
# unit {
#   source = ""
#   path = 'network'

#   values = ""

# }









































# locals {
#   name = "ecs-deployment"
# }

# unit "network" {
#   // You'll typically want to pin this to a particular version of your catalog repo.
#   // e.g.
#   // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/ec2-asg-stateful-service?ref=v0.1.0"
#   source = "git::https://github.com/david-hankinson/terragrunt-module-ecs.git//ecs?ref=main"

#   path = "network"

#   values = {
#     // This version here is used as the version passed down to the unit
#     // to use when fetching the OpenTofu/Terraform module.
#     version = "main"

#     name          = local.name
#     env = 
#     instance_type = "t4g.micro"
#     min_size      = 2
#     max_size      = 4
#     server_port   = 3000
#     alb_port      = 80

#     db_path     = "../db"
#     asg_sg_path = "../sgs/asg"

#     // This is used for the userdata script that
#     // bootstraps the EC2 instances.
#     db_username = local.db_username
#     db_password = local.db_password
#   }
# }

# unit "db" {
#   // You'll typically want to pin this to a particular version of your catalog repo.
#   // e.g.
#   // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/mysql?ref=v0.1.0"
#   source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/mysql"

#   path = "db"

#   values = {
#     // This version here is used as the version passed down to the unit
#     // to use when fetching the OpenTofu/Terraform module.
#     version = "main"

#     name              = "${replace(local.name, "-", "")}db"
#     instance_class    = "db.t4g.micro"
#     allocated_storage = 20
#     storage_type      = "gp2"

#     # NOTE: This is only here to make it easier to spin up and tear down the stack.
#     # Do not use any of these settings in production.
#     master_username     = local.db_username
#     master_password     = local.db_password
#     skip_final_snapshot = true
#   }
# }

# // We create the security group outside of the ASG unit because
# // we want to handle the wiring of the ASG to the security group
# // to the DB before we start provisioning the service unit.
# unit "asg_sg" {
#   // You'll typically want to pin this to a particular version of your catalog repo.
#   // e.g.
#   // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/sg?ref=v0.1.0"
#   source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/sg"

#   path = "sgs/asg"

#   values = {
#     // This version here is used as the version passed down to the unit
#     // to use when fetching the OpenTofu/Terraform module.
#     version = "main"

#     name = "${local.name}-asg-sg"
#   }
# }

# unit "sg_to_db_sg_rule" {
#   // You'll typically want to pin this to a particular version of your catalog repo.
#   // e.g.
#   // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/sg-to-db-sg-rule?ref=v0.1.0"
#   source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/sg-to-db-sg-rule"

#   path = "rules/sg-to-db-sg-rule"

#   values = {
#     // This version here is used as the version passed down to the unit
#     // to use when fetching the OpenTofu/Terraform module.
#     version = "main"

#     // These paths are used for relative references
#     // to the service and db units as dependencies.
#     sg_path = "../../sgs/asg"
#     db_path = "../../db"
#   }
# }
