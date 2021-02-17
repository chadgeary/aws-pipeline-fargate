provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
}

variable "aws_prefix" {
  type                     = string
}

variable "aws_profile" {
  type                     = string
}

variable "aws_region" {
  type                     = string
}

variable "kms_manager" {
  type                     = string
  description              = "An IAM user for management of KMS key"
}

data "aws_caller_identity" "aws-account" {
}

data "aws_iam_user" "aws-kmsmanager" {
  user_name                = var.kms_manager
}

data "aws_availability_zones" "aws-azs" {
  state                    = "available"
}

variable "aws_az" {
  type                     = number
  default                  = 0
}

variable "vpc_cidr" {
  type                     = string
}

variable "subnetA_cidr" {
  type                     = string
}

variable "subnetB_cidr" {
  type                     = string
}

variable "subnetC_cidr" {
  type                     = string
}

variable "subnetD_cidr" {
  type                     = string
}

resource "random_string" "aws-suffix" {
  length                  = 5
  upper                   = false
  special                 = false
}

variable "service_port" {
  type                    = number
}

variable "service_protocol" {
  type                    = string
}

variable "service_count" {
  type                    = number
}

variable "client_cidrs" {
  type                     = list
  description              = "List of subnets (in CIDR notation) granted load balancer port and protocol ingress"
  default                  = []
}
