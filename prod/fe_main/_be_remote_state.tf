data "terraform_remote_state" "be_shinydash" {
  backend = "s3"

  config {
    profile = "wellnet-ras-turismo"
    bucket  = "shinydash-config"
    key     = "prod/shinydash/terraform.tfstate"
    region  = "eu-west-1"
  }
}
