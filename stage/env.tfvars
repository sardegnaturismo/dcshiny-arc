# Root level variables that all modules can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.

# Common used variable 

# Syntax <ID Cliente>-<AWS Accound ID>-​<ENVIROMENT>-<PROJECT>-TF
tfstate_global_bucket = "rt-064484720015-stage-shiny-tf"

tfstate_global_bucket_region = "eu-west-1"

profile = "wellnet-ras-turismo"

project = "shinydash"

project_full_name = "shinydash"

key_name = "ras-stage"

account_id = "064484720015"

environment = "stage"

region = "eu-west-1"

# Project specific variables:

cluster = "shinydash"

public_subnet_ids = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]

private_subnet_ids = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]

availibility_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

vpc_id = "vpc-f3c9f796"

base_domain = "sardegnaturismocloud.it"

vpc_azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

private_subnets = ["subnet-a67847ef"]

private_cidr_blocks = ["172.31.48.0/20"]

public_subnets = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]

public_cidr_blocks = ["172.31.16.0/20", "172.31.0.0/20", "172.31.32.0/20"]
