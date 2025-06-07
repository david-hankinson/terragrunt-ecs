terraform {
  source = "./"
}

# generate "provider" {
#   path = "provider.tf"
#   if_exists = "overwrite_terragrunt"

#   contents = <<EOF
# terraform {
#   required_providers {
#       aws = {
#         source  = "hashicorp/aws"
#         version = "> 4.0"
#       }
#     }
# }
# EOF
# }

# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = <<EOF
# terraform {
#   backend "s3" {
#     bucket         = "terragrunt-ecs-state"
#     key            = "${path_relative_to_include()}/terragrunt-ecs.tfstate"
#     region         = "ca-central-1"
#     encrypt        = true
#     dynamodb_table = "terragrunt-ecs"
#   }
# }
# EOF
# }


remote_state {
  backend = "s3"
  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    # profile = "anton"
    # role_arn = "arn:aws:iam::424432388155:role/terraform"
    bucket = "terragrunt-ecs-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    dynamodb_table = "terragrunt-ecs-lock-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "ca-central-1"
  profile = "anton"
  
  # assume_role {
  #   session_name = "leson-160"
  #   role_arn = "arn:aws:iam::424432388155:role/terraform"
  # }
}
EOF
}


