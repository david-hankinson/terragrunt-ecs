variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Which environment the infrastructure will be deployed in"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}
variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
}
variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
}