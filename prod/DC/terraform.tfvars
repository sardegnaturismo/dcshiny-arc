# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the working directory, into a temporary folder, and execute your Terraform commands in that folder.

  # Replace MODULE_REPOSITORY_NAME with the name of git repo containing the iac modules. Ends with "//" and module name (= name of containing folder)  
  terraform {
    source = "git::ssh://git@bitbucket.org/beetobit/wel-mirror-dashboard-modules//dashboard"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE DEPENDENCIES
# These are the modules to create before this
# Used by `terragrunt plan-all` and `terragrunt apply-all` commands  ---------------------------------------------------------------------------------------------------------------------

# UNCOMMENT to activate
dependencies {
  paths = ["../common", "../cluster"]
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------
github_oauth_token = "92c48a800ad929be3197620c879ef82169cc52fc"

github_owner = "sardegnaturismo"

github_repository = "DC_shiny"

poll_for_source_changes = "false"

dashboard_id = "dc"

shiny_image_tag = "dc-shiny-server"

nginx_image_tag = "dc-nginx"

worker_image_tag = "dc-worker"

enable_s3_sync_worker = true

alb_listener_rule_offset = 60

http_listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:064484720015:listener/app/prod-ras-alb/9d406f2dafd60ac2/1f2730a897383305"

https_listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:064484720015:listener/app/prod-ras-alb/9d406f2dafd60ac2/952cde701e658d7a"

service_count = 1
