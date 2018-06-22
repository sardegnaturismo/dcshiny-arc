variable "cluster" {
  type    = "string"
  default = "shinydash"
}

variable "role" {
  type    = "string"
  default = "main"
}

variable "ecs_aws_ami" {
  type    = "string"
  default = ""       # ubuntu linux
}

variable "max_size" {
  type    = "string"
  default = "2"
}

variable "min_size" {
  type    = "string"
  default = "2"
}

variable "desired_capacity" {
  type    = "string"
  default = "2"
}

variable "instance_type" {
  type = "string"

  # default = "c4.large"
  default = "t2.large"
}

# variable "vpc_cidr" {
#   type    = "string"
#   default = "172.31.0.0/16"
# }

variable "vpc_id" {
  type    = "string"
  default = "vpc-f3c9f796"
}

# variable "public_subnet_cidrs" {
#   type    = "list"
#   default = ["172.31.16.0/2","172.31.0.0/20","172.31.32.0/20"]
# }

# variable "private_subnet_cidrs" {
#   type    = "list"
#   default = [""]
# }

variable "availibility_zones" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

# variable "vpc_cidr" {}
# variable "environment" {}
# variable "max_size" {}
# variable "min_size" {}
# variable "desired_capacity" {}
# variable "instance_type" {}
# variable "ecs_aws_ami" {}

variable "public_subnet_ids" {
  type    = "list"
  default = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]
}

variable "private_subnet_ids" {
  type    = "list"
  default = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]
}

# output "default_alb_target_group" {
#   value = "${module.ecs.default_alb_target_group}"
# }


# variable "alb_security_group_id" {
#   type = "string"
#   default = "sg-e9867d92"
# }

