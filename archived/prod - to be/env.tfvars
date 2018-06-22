# Root level variables that all modules can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.

# Common used variable 

# Syntax <ID Cliente>-<AWS Accound ID>-​<ENVIROMENT>-<PROJECT>-TF
tfstate_global_bucket = "al-000123456789-prod-test-tf"

tfstate_global_bucket_region = "eu-west-1"

profile = "default-test"

project = "test"

project_full_name = "test-project"

key_name = "prod-test"

account_id = "000123456789"

environment = "prod"

region = "eu-west-1"
