# variable "http_listener_arn" {
#   type    = "string"
#   default = ""
# }

# variable "https_listener_arn" {
#   type    = "string"
#   default = "arn:aws:elasticloadbalancing:eu-west-1:064484720015:listener/app/prod-ras-alb/9d406f2dafd60ac2/952cde701e658d7a"
# }

variable "role" {
  type    = "string"
  default = "main"
}

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
variable "public_subnet_ids" {
  type        = "list"
  default     = [""]
  description = "subnet where service will be spawn"
}