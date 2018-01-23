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
  vpc_id              = "vpc-f3c9f796"
  project             = "${module.env.project}"
  environment         = "${module.env.environment}"
  role                = "${module.env.environment}-${module.env.project}-shared"
  private_subnets_ids = ["subnet-abdad2dc", "subnet-5b4eae3f", "subnet-f47a5aad"]
  cidr_blocks         = ["172.31.16.0/20", "172.31.0.0/20", "172.31.32.0/20"]
}
