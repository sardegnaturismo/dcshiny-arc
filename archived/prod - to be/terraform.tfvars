# Use --terragrunt-source-update to clean up the tmp folder if anything goes wrong
# Use --terragrunt-source ../relative/path//to to point to a local checkout at XXX

terragrunt = {
  remote_state {
    backend = "s3"

    config {
      encrypt = false
      bucket  = "prod-ras-archivio-tf"
      key     = "${path_relative_to_include()}/terraform.tfstate"
      region  = "${get_env("TF_VAR_region", "eu-west-1")}"
      profile = "wellnet-ras-turismo"

      # dynamodb_table = "terraform-locks"
    }
  }

  # Configure root level variables that all resources can inherit
  terraform {
    extra_arguments "env" {
      commands = ["${get_terraform_commands_that_need_vars()}"]

      optional_var_files = [
        "${get_tfvars_dir()}/${find_in_parent_folders("env.tfvars", "ignore")}",
      ]
    }
  }
}
