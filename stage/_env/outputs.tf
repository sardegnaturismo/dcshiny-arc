output "project" {
  value = "${var.project}"
}

output "environment" {
  value = "${var.environment}"
}

output "profile" {
  value = "${var.profile}"
}

output "region" {
  value = "${var.region}"
}

output "base_domain" {
  value = "${var.base_domain}"
}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}

output "key_name" {
  value = "${var.key_name}"
}

output "project_full_name" {
  value = "${var.project_full_name}"
}
