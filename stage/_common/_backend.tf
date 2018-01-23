terraform {
  backend "s3" {
    profile = "wellnet-ras-turismo"
    bucket  = "shinydash-config"
    key     = "stage/common/terraform.tfstate"
    region  = "eu-west-1"
  }
}
