

// Used for path on Codedepoy
variable "app_name" {
  type    = "string"
  default = "UNUSED"
}

variable "deployment_configuration" {
  type    = "string"
  default = "CodeDeployDefault.AllAtOnce" # CodeDeployDefault.OneAtATime | CodeDeployDefault.HalfAtATime | CodeDeployDefault.AllAtOnce	
}


variable "cluster" {
  type    = "string"
  default = "sandbox"
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
  default = "1"
}

variable "min_size" {
  type    = "string"
  default = "1"
}

variable "desired_capacity" {
  type    = "string"
  default = "1"
}

variable "instance_type" {
  type = "string"
  default = "t2.medium"
}

variable "github_oauth_token" { 
  description = "Github access token. See https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/ for help" 
}
variable "github_owner" {
  description = "Github repository owner" 
}

variable "github_repository" {
  description = "Github repository name"
 }

variable "github_branch" {
  description = "Github repository selected branch"
  default =   "master"

 }
variable "poll_for_source_changes" {
  description = "Poll code repository for changes"
  default =   false
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

variable "key_name" {
  type        = "string"
  default     = "sandbox"
  description = "SSH key for server managemente"
}

variable "account_id" {
  type    = "string"
  default = "not_valid" # 
}

 variable "public_subnet_ids" {
  type    = "list"
}

variable "private_subnet_ids" {
  type    = "list"
}


variable "availibility_zones" {
  type    = "list"
}

variable "vpc_id" {
  type    = "string"
}