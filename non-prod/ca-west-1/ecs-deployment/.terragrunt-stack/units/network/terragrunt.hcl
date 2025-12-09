include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  // NOTE: Take note that this source here uses
  // a Git URL instead of a local path.
  //
  // This is because units and stacks are generated
  // as shallow directories when consumed.
  //
  // Assume that a user consuming this unit will exclusively have access
  // to the directory this file is in, and nothing else in this repository.
  source = "../module/"
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