include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = "${get_terragrunt_dir()}/../../_env/ecs.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::https://github.com/david-hankinson/terragrunt-module-ecs.git//ecs?ref=main"
}

dependency "network" {
  config_path = "../network/"

  mock_outputs = {
    public_subnets_ids = ["id_one", "id_two"]
    private_subnets_ids = ["id_one", "id_two"]
    security_group_ids = ["id_one","id_two"]
    load_balancer_id = "lb"
    lb_target_group_id = "lb_tg"
    env = "non-prod"
    vpc_id = "mock_vpc_id"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_zone_identifier = "aaaaaaa"
    load_balancer_id = "mock_lb"
    aws_ecs_service_load_balancer_tg_arn = "arn:aws:elasticloadbalancing:ca-central-1:000000000000:targetgroup/prod-tg/0000000000000000"
    internet_gw_id = "aaaaa"
    vpc_security_group_ids = "aaaaaaa"
    vpc_sg = "dependency.network.outputs.vpc_sg"
  }
}

inputs = {
  ## env inputs
  env                      = local.env

  ## ec2 inputs
  ec2_instance_type = "t3.medium"
  vpc_zone_identifier = flatten([dependency.network.outputs.public_subnets_ids, dependency.network.outputs.private_subnets_ids])

  ## ecs inputs
  aws_ecs_cluster_name = "non-prod-ecs-cluster"
  aws_ecs_capacity_provider_name = "non-prod-capacity-provider"
  aws_ecs_task_definition_family = "non-prod-td-family"
  ecs_minimum_scaling_step_size = 1
  ecs_maximum_scaling_step_size = 2
  ecs_target_capacity_percentage = 80
  vpc_sg = dependency.network.outputs.vpc_sg
  vpc_id = dependency.network.outputs.vpc_id
  vpc_security_group_ids = dependency.network.outputs.vpc_sg
  public_subnets_ids = dependency.network.outputs.public_subnets_ids
  private_subnets_ids = dependency.network.outputs.private_subnets_ids
  vpc_cidr_block = dependency.network.outputs.vpc_cidr_block
  internet_gw_id = dependency.network.outputs.internet_gw_id
}

# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "non-prod-state.tf"
#     if_exists = "overwrite_terragrunt"
#   }

#   config = {
#     bucket  = "non-prod-ecs-state"
#     key     = "ecs.non-prod.terraform.tfstate"
#     region  = "ca-central-1"
#     encrypt = true
#   }
# }

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = "${get_terragrunt_dir()}/../../_env/network.hcl"
}

terraform {
  source = "git::https://github.com/david-hankinson/terragrunt-module-vpc.git//network?ref=main"
}

inputs = {
  # Environment
  env                      = "non-prod"

  # VPC Configuration
  vpc_cidr_block           = "10.1.0.0/16"

  # Subnet Configuration
  public_subnets           = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets          = ["10.1.3.0/24", "10.1.4.0/24"]

  # Security Groups
  allowed_ssh_cidr_blocks  = ["10.1.0.0/16"] 
  # Restrict SSH
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path           = "${get_terragrunt_dir()}/../../_env/ecs.hcl"
  expose         = true
  merge_strategy = "no_merge"
}

terraform {
  source = "git::https://github.com/david-hankinson/terragrunt-module-ecs.git//ecs?ref=main"
}

dependency "network" {
  config_path = "../network/"

  mock_outputs = {
    public_subnets_ids = ["id_one", "id_two"]
    private_subnets_ids = ["id_one", "id_two"]
    security_group_ids = ["id_one","id_two"]
    load_balancer_id = "lb"
    lb_target_group_id = "lb_tg"
    env = "non-prod"
    vpc_id = "mock_vpc_id"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_zone_identifier = "aaaaaaa"
    load_balancer_id = "mock_lb"
    aws_ecs_service_load_balancer_tg_arn = "arn:aws:elasticloadbalancing:ca-central-1:000000000000:targetgroup/prod-tg/0000000000000000"
    internet_gw_id = "aaaaa"
    vpc_security_group_ids = "aaaaaaa"
    vpc_sg = "dependency.network.outputs.vpc_sg"
  }
}

inputs = {
  ## env inputs
  env                      = local.env

  ## ec2 inputs
  ec2_instance_type = "t3.medium"
  vpc_zone_identifier = flatten([dependency.network.outputs.public_subnets_ids, dependency.network.outputs.private_subnets_ids])

  ## ecs inputs
  aws_ecs_cluster_name = "non-prod-ecs-cluster"
  aws_ecs_capacity_provider_name = "non-prod-capacity-provider"
  aws_ecs_task_definition_family = "non-prod-td-family"
  ecs_minimum_scaling_step_size = 1
  ecs_maximum_scaling_step_size = 2
  ecs_target_capacity_percentage = 80
  vpc_sg = dependency.network.outputs.vpc_sg
  vpc_id = dependency.network.outputs.vpc_id
  vpc_security_group_ids = dependency.network.outputs.vpc_sg
  public_subnets_ids = dependency.network.outputs.public_subnets_ids
  private_subnets_ids = dependency.network.outputs.private_subnets_ids
  vpc_cidr_block = dependency.network.outputs.vpc_cidr_block
  internet_gw_id = dependency.network.outputs.internet_gw_id
}

# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "non-prod-state.tf"
#     if_exists = "overwrite_terragrunt"
#   }

#   config = {
#     bucket  = "non-prod-ecs-state"
#     key     = "ecs.non-prod.terraform.tfstate"
#     region  = "ca-central-1"
#     encrypt = true
#   }
# }