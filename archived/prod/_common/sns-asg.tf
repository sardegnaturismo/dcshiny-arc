############################ OUTPUTS START


output "sns_autoscaling" {
  value = "${aws_sns_topic.autoscaling.id}"
}


############################ OUTPUTS START

resource "aws_sns_topic" "autoscaling" {
  name         = "${module.env.environment}-${module.env.project}-autoscaling"
  display_name = "${module.env.project_full_name} : Autoscaling Notifications"
}
