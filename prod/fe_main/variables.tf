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

variable "public_subnet_ids" {
  type    = "list"
  default = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]
}
