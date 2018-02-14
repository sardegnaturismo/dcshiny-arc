data "terraform_remote_state" "shinydash" {
  backend = "s3"

  config {
    profile = "${var.profile}"
    bucket  = "${var.bucket}"
    key     = "env:/${var.environment}/shinydash/terraform.tfstate"
    region  = "${var.region}"
    # workspace = "${var.environment}"
  }
}