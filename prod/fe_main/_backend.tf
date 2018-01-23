terraform {
  backend "s3" {
    profile = "wellnet-ras-turismo"
    bucket  = "shinydash-config"
    key     = "prod/fe_main/terraform.tfstate"
    region  = "eu-west-1"
  }
}
