
provider "aws" {
  profile = "${var.profile}"
  region  = "${var.region}"
  version ="1.7"
}

provider "aws" {
  alias   = "us-east-1"
  profile = "${var.profile}"
  region  = "us-east-1"
  version ="1.7"
}

