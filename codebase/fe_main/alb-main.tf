output "alb_id" {
  value = "${aws_alb.default.id}"
}

# output "alb_canonical_hosted_zone_id" {
#   value = "${aws_alb.default.canonical_hosted_zone_id}"
# }

output "alb_zone_id" {
  value = "${aws_alb.default.zone_id}"
}

output "alb_dns_name" {
  value = "${aws_alb.default.dns_name}"
}

output "alb_http_listener_arn" {
  value = "${aws_alb_listener.http.id}"
}

# output "alb_https_listener_arn" {
#   value = "${aws_alb_listener.https.id}"
# }

// Create security group for ALB 
resource "aws_security_group" "alb_sg_open" {
  count       = 0
  name        = "${var.environment}-${var.project}-${var.role}-alb-sg"
  vpc_id      = "${data.terraform_remote_state.common.vpc_id}"
  description = "sg for ${var.role} ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Create ALB
resource "aws_alb" "default" {
  name            = "${var.environment}-${var.project}-${var.role}-alb"
  internal        = "false"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${data.terraform_remote_state.common.ec2_fe_main_sg}", "${data.terraform_remote_state.common.ec2_cf_iprange_http_id}", "${data.terraform_remote_state.common.ec2_cf_iprange_https_id}"]

  # access_logs {
  #   bucket = "${data.terraform_remote_state.common.s3_lb-logs_id}"
  #   prefix = "${var.role}"
  # }
  idle_timeout = 180

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.default.id}"
  port              = 80
  protocol          = "HTTP"

  default_action = {
    target_group_arn = "${data.terraform_remote_state.shinydash.main_tg_arn}"
    type             = "forward"
  }
}

data "aws_acm_certificate" "frontend" {
  domain   = "*.${var.base_domain}"
  statuses = ["ISSUED"]
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.default.id}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.frontend.arn}"

  default_action = {
    target_group_arn = "${data.terraform_remote_state.shinydash.main_tg_arn}"
    type             = "forward"
  }
}
