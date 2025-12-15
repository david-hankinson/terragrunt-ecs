locals { 
  name = "ecs-deploy"
  env = "non-prod"
}

unit "vpc" {

  source = "git::git@github.com:david-hankinson/terragrunt-module-vpc.git//units/network?ref=main"
  
  path = "vpc"

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
