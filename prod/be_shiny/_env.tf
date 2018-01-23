module "env" {
  source = "../_env"
}

provider "aws" {
  profile = "${module.env.profile}"
  region  = "${module.env.region}"
}

data "terraform_remote_state" "continous" {
  backend = "s3"

  config {
    profile = "wellnet-ras-turismo"
    bucket  = "tf-ras"
    key     = "global/continous/terraform.tfstate"
    region  = "eu-west-1"
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    profile = "wellnet-ras-turismo"
    bucket  = "shinydash-config"
    key     = "prod/common/terraform.tfstate"
    region  = "eu-west-1"
  }
}
