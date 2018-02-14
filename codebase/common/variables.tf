variable "bucket" {
  type        = "string"
  default     = "sandbox"
  description = "S3 bucket containing terraform state"
}

variable "project" {
  type        = "string"
  default     = "test"
  description = "Project short name"
}

variable "project_full_name" {
  type        = "string"
  default     = "test"
  description = "Project full name"
}

variable "environment" {
  type        = "string"
  default     = "sandbox"
  description = "Deployment Environment"
}

variable "profile" {
  type        = "string"
  default     = "sandbox"
  description = "AWS Credential selected profile"
}

variable "region" {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS selected Region"
}

variable "base_domain" {
  type        = "string"
  default     = "sandbox.com"
  description = "Base url for accessing project resources"
}

variable "key_name" {
  type        = "string"
  default     = "sandbox"
  description = "SSH key for server managemente"
}

data "aws_caller_identity" "current" {}


variable "private_subnets" {
  type        = "list"
  default     = [""]
  description = "subnet where service will be spawn"
}


variable "private_cidr_blocks" {
  type        = "list"
  default     = [""]
  description = "CIDR blocks for private subnets"
}

variable "vpc_azs" {
  type        = "list"
  default     = [""]
  description = "AZ for VPC"
}

variable "public_subnets" {
  type        = "list"
  default     = [""]
  description = "subnet where service will be spawn"
}

variable "public_cidr_blocks" {
  type        = "list"
  default     = [""]
  description = "PRIVATE CIDR blocks for public subnets"
}

variable "account_id" {
  type    = "string"
  default = "not_valid" # 
}

# variable "account_id" {
#   default = "${data.aws_caller_identity.current.account_id}"
#   description = "AWS caller account_id (aka user_id)"


# }


# variable "caller_user" {
#   default = "${data.aws_caller_identity.current.user_id}"
#  description = "AWS caller user id (aka account_id)"


# }


# variable "caller_arn" {
#   default = "${data.aws_caller_identity.current.arn}"
#  description = "AWS caller account arn"
# }

