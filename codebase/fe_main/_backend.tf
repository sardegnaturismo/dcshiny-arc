terraform {
  required_version = ">=0.11.0"
  backend "s3" {
    profile = "wellnet-ras-turismo"
    bucket  = "shinydash-config"
    region  = "eu-west-1"
  }
}
