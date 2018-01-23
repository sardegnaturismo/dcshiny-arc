resource "aws_ecs_service" "worker" {
  name            = "${module.env.project}-worker-srv"
  cluster         = "${module.env.environment}-${data.terraform_remote_state.be_shinydash.cluster}"
  task_definition = "${data.terraform_remote_state.be_shinydash.worker_td_family}:${max("${data.terraform_remote_state.be_shinydash.worker_td_revision}", "${data.aws_ecs_task_definition.worker.revision}")}"
  desired_count   = 2

  # iam_role        = "${module.ecs.service_role_name}"
  # depends_on      = ["${module.ecs.role_name}"]

  placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
}

data "aws_ecs_task_definition" "worker" {
  task_definition = "${data.terraform_remote_state.be_shinydash.worker_td_family}"
}

# resource "aws_ecs_service" "ftp" {
#   name            = "${module.env.project}-ftp-srv"
#   cluster         = "${module.env.environment}-${data.terraform_remote_state.be_shinydash.cluster}"
#   task_definition = "${data.terraform_remote_state.be_shinydash.ftp_td_family}:${max("${data.terraform_remote_state.be_shinydash.ftp_td_revision}", "${data.aws_ecs_task_definition.ftp.revision}")}"


#   desired_count = 1


#   # iam_role        = "${module.ecs.service_role_name}"
#   # depends_on      = ["${module.ecs.role_name}"]
#   placement_strategy {
#     type  = "binpack"
#     field = "cpu"
#   }
# }


# data "aws_ecs_task_definition" "ftp" {
#   task_definition = "${data.terraform_remote_state.be_shinydash.ftp_td_family}"
# }


# task_definition = "${data.terraform_remote_state.be_shinydash.ftp_td_family}:${max("${aws_ecs_task_definition.mongo.revision}", "${data.aws_ecs_task_definition.ftp.revision}")}"


# resource "aws_ecs_service" "mongo" {
#   name          = "mongo"
#   cluster       = "${aws_ecs_cluster.foo.id}"
#   desired_count = 2


#   # Track the latest ACTIVE revision
#   task_definition = "${aws_ecs_task_definition.mongo.family}:${max("${aws_ecs_task_definition.mongo.revision}", "${data.aws_ecs_task_definition.mongo.revision}")}"
# }


# }

