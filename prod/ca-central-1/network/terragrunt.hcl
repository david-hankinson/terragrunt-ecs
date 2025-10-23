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
  env                      = "prod"

  # VPC Configuration
  vpc_cidr_block           = "10.0.0.0/16"

  # Subnet Configuration
  public_subnets           = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets          = ["10.0.3.0/24", "10.0.4.0/24"]

  # Security Groups
  allowed_ssh_cidr_blocks  = ["192.168.1.0/24"]         # Restrict SSH
}
 