############################# OUTPUTS START

output "ec2_cf_iprange_http_id" {
  value = "${aws_security_group.cf-ip-range-http.id}"
}

output "ec2_cf_iprange_https_id" {
  value = "${aws_security_group.cf-ip-range-https.id}"
}

output "ec2_fe_main_sg" {
  value = "${aws_security_group.fe_main_alb_sg.id}"
}

############################# OUTPUTS END

variable vpc_id {
  default = "vpc-f3c9f796"
}

resource "aws_security_group" "fe_main_alb_sg" {
  name        = "${var.environment}-${var.project}-fe_main-alb-sg"
  vpc_id      = "${var.vpc_id}"
  description = "sg for ALB"

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }


  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cf-ip-range-http" {
  name        = "${var.environment}-cf-ip-range-http-sg"
  vpc_id      = "${var.vpc_id}"
  description = "sg for frontend ec2 http"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment = "${var.environment}"
    Name        = "cloudfront"
    AutoUpdate  = "true"
    Protocol    = "http"
  }
}

resource "aws_security_group" "cf-ip-range-https" {
  name        = "${var.environment}-cf-ip-range-https-sg"
  vpc_id      = "${var.vpc_id}"
  description = "sg for frontend ec2 https"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment = "${var.environment}"
    Name        = "cloudfront"
    AutoUpdate  = "true"
    Protocol    = "https"
  }
}

# TODO: fix trigger for lambda
# TODO: create a manual switch for populating seciurity groups

