############################# OUTPUTS START
output "efs_id" {
  value = "${module.efs-main.efs_id}"
}

output "efs_target_id" {
  value = "${module.efs-main.target_id}"
}

output "efs_dns_name" {
  value = "${module.efs-main.dns_name}"
}

############################# OUTPUTS END

############################# VARS END

module "efs-main" {
  source              = "git::ssh://git@bitbucket.org/wellnet-team/infrastruttura-terraform-modules.git//efs"
  vpc_id              = "${var.vpc_id}"
  project             = "${var.project}"
  environment         = "${var.environment}"
  role                = "shared"
  private_subnets_ids = "${var.public_subnets}"
  cidr_blocks         = "${var.public_cidr_blocks}"
}
