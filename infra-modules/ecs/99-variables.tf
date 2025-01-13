variable "env" {
  description = "Which environment the infrastructure will be deployed in"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "public_subnets_ids" {
  type        = list(string)
  description = "public subnet ids"
}

variable "private_subnets_ids" {
  type        = list(string)
  description = "private subnet ids"
}

variable "ec2_instance_type" {
  type        = string
  description = "ec2 instance type"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "vpc zone identifiers"
}

variable "vpc_security_group_ids" {
  type        = string
  description = "vpc security group ids"
}

variable "internet_gw_id" {
  type        = string
  description = "internet gw id"
}

variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr blocks"
}
