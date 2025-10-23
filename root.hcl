generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {

}
EOF
}

# File: terragrunt-ecs/root.hcl
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-ecs-state"
    key            = "${path_relative_to_include()}/tofu.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    dynamodb_table = "terragrunt-ecs-lock-table"
  }
}




