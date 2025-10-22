terraform {
  source = "git::https://github.com/david-hankinson/terragrunt-module-vpc.git//network?ref=main"
}

inputs = {
  availability_zones       = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  enable_dns_support       = true
  enable_dns_hostnames     = true
}

