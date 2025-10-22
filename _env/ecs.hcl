# terraform {
#   source = "../../terragrunt-module-ecs/ecs/"
# }

terraform {
  source = "https://github.com/david-hankinson/terragrunt-module-ecs.git//network/"
}

# https://github.com/david-hankinson/terragrunt-module-vpc.git

#   source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-catalog-example.git//units/mysql"