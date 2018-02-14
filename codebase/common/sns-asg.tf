############################ OUTPUTS START


output "sns_autoscaling" {
  value = "${aws_sns_topic.autoscaling.id}"
}


############################ OUTPUTS START

resource "aws_sns_topic" "autoscaling" {
  name         = "${var.environment}-${var.project}-autoscaling"
  display_name = "${var.project_full_name} : Autoscaling Notifications"
}
