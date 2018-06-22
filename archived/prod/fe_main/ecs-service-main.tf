resource "aws_ecs_service" "default" {
  depends_on      = ["aws_alb.default"]
  name            = "${module.env.project}-main-srv"
  cluster         = "${module.env.environment}-${data.terraform_remote_state.be_shinydash.cluster}"
  task_definition = "${data.terraform_remote_state.be_shinydash.main_td_family}:${max("${data.terraform_remote_state.be_shinydash.main_td_revision}", "${data.aws_ecs_task_definition.main.revision}")}"
  desired_count   = 2

  iam_role = "aws-service-role"

  # depends_on      = ["${module.ecs.role_name}"]

  placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
  load_balancer {
    container_name   = "nginx"
    container_port   = 80
    target_group_arn = "${data.terraform_remote_state.be_shinydash.main_tg_arn}"
  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = "${data.terraform_remote_state.be_shinydash.main_td_family}"
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

