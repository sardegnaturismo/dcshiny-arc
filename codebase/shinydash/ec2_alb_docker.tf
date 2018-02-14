output "main_tg_arn" {
  value = "${aws_alb_target_group.default.arn}"
}

// default route to go 
resource "aws_alb_target_group" "default" {
  name                 = "${var.environment}-${var.project}-${var.role}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = 2

  health_check {
    interval            = 20
    path                = "/"
    port                = "traffic-port"
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = "86400"
  }
}
