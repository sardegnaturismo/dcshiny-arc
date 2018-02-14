output "cluster" {
  value = "${var.cluster}"
}

output "cluster_role_name" {
  value = "${module.ecs.role_name}"
}

module "ecs" {
  source = "git::ssh://git@bitbucket.org/wellnet-team/infrastruttura-terraform-modules.git//ecs"

  environment        = "${var.environment}"
  cluster            = "${var.cluster}"
  cloudwatch_prefix  = "${var.environment}-${var.cluster}" #See ecs_instances module when to set this and when not!
  vpc_id             = "${var.vpc_id}"
  public_subnet_ids  = "${var.public_subnet_ids}"
  private_subnet_ids = "${var.private_subnet_ids}"
  availibility_zones = "${var.availibility_zones}"
  max_size           = "${var.max_size}"
  min_size           = "${var.min_size}"
  desired_capacity   = "${var.desired_capacity}"
  key_name           = "${var.key_name}"

  instance_type         = "${var.instance_type}"
  ecs_aws_ami           = "${var.ecs_aws_ami}"
  alb_security_group_id = "${data.terraform_remote_state.common.ec2_fe_main_sg}"
  custom_userdata       = "${data.template_file.custom_userdata.rendered}"

  # data_persistency_storage = "ebs"
}

data "template_file" "custom_userdata" {
  template = "${file("custom_userdata.sh")}"

  vars {
    efs_id = "${data.terraform_remote_state.common.efs_id}"
    region = "${var.region}"
  }
}

# module "ecs_events" {
#     source              = "git::ssh://git@bitbucket.org/wellnet-team/infrastruttura-terraform-modules.git//ecs_events"


# }
