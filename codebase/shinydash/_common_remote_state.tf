
data "terraform_remote_state" "continous" {
  backend = "s3"

  config {
    profile = "${var.profile}"
    bucket  = "tf-ras"
    key     = "global/continous/terraform.tfstate"
    region  = "${var.region}"
    # workspace = "${var.environment}"
  }
}


data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    profile = "${var.profile}"
    bucket  = "${var.bucket}"
    key     = "env:/${var.environment}/common/terraform.tfstate"
    region  = "${var.region}"
    # workspace = "${var.environment}"
  }
}